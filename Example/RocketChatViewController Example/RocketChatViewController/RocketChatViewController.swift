//
//  RocketChatViewController.swift
//  RocketChatViewController Example
//
//  Created by Rafael Kellermann Streit on 30/07/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit
import DifferenceKit

typealias Section = AnySectionController

fileprivate extension NSNotification.Name {
    static let triggerDataUpdate = NSNotification.Name("TRIGGER_DATA_UPDATE")
}

extension UICollectionView {
    func dequeueChatCell(withReuseIdentifier reuseIdetifier: String, for indexPath: IndexPath) -> BindableCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: reuseIdetifier, for: indexPath) as? BindableCell else {
            fatalError("Trying to dequeue a reusable UICollectionViewCell that doesn't conforms to BindableCell protocol")
        }

        return cell
    }
}

/**
    A type-erased ChatCellViewModel that must conform to the Differentiable protocol.

    The `AnyChatCellViewModel` type forwards equality comparisons and utilities operations or properties
    such as relatedReuseIdentifier to an underlying differentiable value,
    hiding its specific underlying type.
 */

struct AnyChatCellViewModel: ChatCellViewModel, Differentiable {
    var relatedReuseIdentifier: String {
        return base.relatedReuseIdentifier
    }

    let base: ChatCellViewModel
    let differenceIdentifier: AnyHashable

    let isUpdatedFrom: (AnyChatCellViewModel) -> Bool

    public init<D: Differentiable & ChatCellViewModel>(_ base: D) {
        self.base = base
        self.differenceIdentifier = AnyHashable(base.differenceIdentifier)

        self.isUpdatedFrom = { source in
            guard let sourceBase = source.base as? D else { return false }
            return base.isContentEqual(to: sourceBase)
        }
    }

    func isContentEqual(to source: AnyChatCellViewModel) -> Bool {
        return isUpdatedFrom(source)
    }
}

/**
    A type-erased SectionController.

    The `AnySectionController` type forwards equality comparisons and servers as a data source
    for RocketChatViewController to build one section, hiding its specific underlying type.
 */

struct AnySectionController: SectionController {
    var object: AnyDifferentiable {
        return base.object
    }

    let base: SectionController

    public init<D: SectionController>(_ base: D) {
        self.base = base
    }

    func viewModels() -> [AnyChatCellViewModel] {
        return base.viewModels()
    }

    func cell(for viewModel: AnyChatCellViewModel, on collectionView: UICollectionView, at indexPath: IndexPath) -> BindableCell {
        return base.cell(for: viewModel, on: collectionView, at: indexPath)
    }
}

extension AnySectionController: Differentiable {
    var differenceIdentifier: AnyHashable {
        return AnyHashable(base.object.differenceIdentifier)
    }

    func isContentEqual(to source: AnySectionController) -> Bool {
        return base.object.isContentEqual(to: source.object)
    }
}

fileprivate extension AnySectionController {
    var toArraySection: ArraySection<AnySectionController, AnyChatCellViewModel> {
        return ArraySection(model: self, elements: viewModels())
    }
}

/**
    The responsible for implementing the data source of a single section
    which represents an object splitted into differentiable view models
    each one being binded on a reusable UICollectionViewCell that get updated when there's
    something to update on its content.

    A SectionController is also responsible for handling the actions
    and interactions with the object related to it.

    A SectionController's object is meant to be immutable.
 */

protocol SectionController {
    var object: AnyDifferentiable { get }
    func viewModels() -> [AnyChatCellViewModel]
    func cell(for viewModel: AnyChatCellViewModel, on collectionView: UICollectionView, at indexPath: IndexPath) -> BindableCell
}

extension SectionController {
    func update() {
        NotificationCenter.default.post(
            name: .triggerDataUpdate,
            object: nil
        )
    }
}

/**
    A single split of an object that binds an UICollectionViewCell and can be differentiated.

    A ChatCellViewModel also holds the related UICollectionViewCell's reuseIdentifier.
 */

protocol ChatCellViewModel {
    var relatedReuseIdentifier: String { get }
}

extension ChatCellViewModel where Self: Differentiable {
    // In order to use a ChatCellViewModel along with a SectionController
    // we must use it as a type-erased ChatCellViewModel, which in this case also means
    // that it must conform to the Differentiable protocol.
    var wrapped: AnyChatCellViewModel {
        return AnyChatCellViewModel(self)
    }
}

/**
    A protocol that must be implemented by all cells to padronize the way we bind the data on its view.
 */

protocol BindableCell {
    func bind(viewModel: AnyChatCellViewModel)
}

/**
    RocketChatViewController is basically a UIViewController that holds
    two key components: a list and a message composer.

    The whole idea is to keep the list as close as possible to a regular UICollectionView,
    but with some features and add-ons to make it more "chat friendly" in the point of view of
    performance, modularity and flexibility.

    To solve modularity (and help with performance) we've created a set of protocols
    and wrappers that ensure that we treat each object as a section of our list
    then break it down as much as possible into subobjects that can be differentiated.

    Bringing it to the chat concept, each message is a section, each section can have one
    or more items, it will depend on the complexity of each message. For example, if it's a simple
    text-only message we can represent it using a single reusable cell for this message's section,
    on the other hand if the message has attachments or multimedia content, it's better to
    split the most basic components of a message (avatar, username and text) into a reusable cell
    and the multimedia content (video, image, link preview, etc) into other reusable cells. This
    way we will wind up with simpler cells that cost less to reuse.

    To solve performance our main efforts are concentrated on updating the views the least
    possible. In order to do that we rely on a third-party (awesome) diffing library
    called DifferenceKit. Based on the benchmarks provided on its GitHub page it is the most
    performatic diffing library available for iOS development now. DifferenceKit also provides a
    UICollectionView extension that performs batch updates based on a changeset making sure that
    only the items that changed are going to be refreshed. On top of DifferenceKit's reloading
    we've implemented a simple operation queue to guarantee that no more than one reload will run
    at once.

    To solve flexibility we thought a lot on how to do the things above but yet keep it a regular
    UICollectionView for those who just want to implement their own list, and we decided that we would
    manage the UICollectionViewDataSource through a public `data` property that reflects on a private `internalData`
    property. This way on a subclass of RocketChatViewController we just need to process the data and set to the `data`
    property that the superclass implementation will handle the data source and will be able to apply the custom reload
    method managed by our operation queue. On the other hand, if anyone wants to implement their message list without
    having to conform to DifferenceKit and our protocols, he just need to override the UICollectionViewDataSource methods
    and provide a custom implementation.

    Minor features:
    - Inverted mode
    - Self-sizing cells support

 */

class RocketChatViewController: UIViewController {
    var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )

        collectionView.backgroundColor = .white
        return collectionView
    }()

    var composerHeightConstraint: NSLayoutConstraint!
    var viewComposer: UIView! = UIView()

    var data: [Section] = []
    private var internalData: [ArraySection<AnySectionController, AnyChatCellViewModel>] = []

    private let updateDataQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.qualityOfService = .userInteractive

        return operationQueue
    }()

    var isInverted = true
    var isSelfSizing = false
    private let invertedTransform = CGAffineTransform(scaleX: 1, y: -1)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupChatViews()
        registerObservers()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func registerObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateData),
            name: .triggerDataUpdate,
            object: nil
        )
    }

    func setupChatViews() {
        view.addSubview(viewComposer)
        view.addSubview(collectionView)

        collectionView.transform = isInverted ? invertedTransform : collectionView.transform

        viewComposer.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        let topMargin = view.safeAreaLayoutGuide.topAnchor
        let bottomMargin = view.safeAreaLayoutGuide.bottomAnchor

        composerHeightConstraint = viewComposer.heightAnchor.constraint(equalToConstant: 50)

        NSLayoutConstraint.activate([
            composerHeightConstraint,
            viewComposer.bottomAnchor.constraint(equalTo: bottomMargin),
            viewComposer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewComposer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topMargin),
            collectionView.bottomAnchor.constraint(equalTo: viewComposer.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.scrollsToTop = false

        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout, isSelfSizing {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        }
    }

    @objc func updateData() {
        updateDataQueue.addOperation { [weak self] in
            guard let strongSelf = self else { return }

            let changeset = StagedChangeset(source: strongSelf.internalData, target: strongSelf.data.map({ $0.toArraySection }))

            DispatchQueue.main.async {
                strongSelf.collectionView.reload(using: changeset, interrupt: { $0.changeCount > 100 }) { newData in
                    strongSelf.internalData = newData
                    strongSelf.data = newData.map { $0.model }
                }
            }
        }
    }

}

extension RocketChatViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return internalData.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return internalData[section].elements.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionController = internalData[indexPath.section].model
        let viewModel = sectionController.viewModels()[indexPath.row]

        guard let chatCell = sectionController.cell(for: viewModel, on: collectionView, at: indexPath) as? UICollectionViewCell else {
            fatalError("The object conforming to BindableCell is not a UICollectionViewCell as it must be")
        }

        return chatCell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.contentView.transform = isInverted ? invertedTransform : cell.contentView.transform
    }
}

extension RocketChatViewController: UICollectionViewDelegateFlowLayout {}
