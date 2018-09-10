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

/**
    A type-erased ChatCellViewModel that must conform to the Differentiable protocol.

    The `AnyChatCellViewModel` type forwards equality comparisons and utilities operations or properties
    such as relatedReuseIdentifier and heightForCurrentState() to an underlying differentiable value,
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

    func heightForCurrentState() -> CGFloat? {
        return base.heightForCurrentState()
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

    func cell(for viewModel: AnyChatCellViewModel, on collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        return base.cell(for: viewModel, on: collectionView, at: indexPath)
    }

    func height(for viewModel: AnyChatCellViewModel) -> CGFloat? {
        return base.height(for: viewModel)
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
    func cell(for viewModel: AnyChatCellViewModel, on collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell
    func height(for viewModel: AnyChatCellViewModel) -> CGFloat?
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

    A ChatCellViewModel also holds the related UICollectionViewCell's reuseIdentifier
    and is reponsible for calculating its height based on its state when not using
    self-sizing cells.
 */

protocol ChatCellViewModel {
    var relatedReuseIdentifier: String { get }
    func heightForCurrentState() -> CGFloat?
}

extension ChatCellViewModel {
    // The heightForCurrentState is set to nil by default, we must override in order to
    // manually calculate a ChatCellViewModel height.
    func heightForCurrentState() -> CGFloat? { return nil }
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
    A helper protocol that makes all UICollectionViewCells to have a `bind(viewModel: Any)`
    method meant to be overwritten.

    With the help of this protocol we doesn't need to always cast an UICollectionViewCell to
    a dynamic type just to bind a view model on it.
 */

protocol BindableCell {
    func bind(viewModel: Any)
}

extension UICollectionViewCell: BindableCell {
    @objc func bind(viewModel: Any) {}
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
    var collectionView: UICollectionView =  {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )

        collectionView.backgroundColor = .white
        return collectionView
    }()

    var composerHeightConstraint: NSLayoutConstraint!
    lazy var composerView: RCComposerView = {
        let composer = RCComposerView(frame: .zero)
        composer.delegate = self

        return composer
    }()

    var data: [Section] = []
    private var internalData: [ArraySection<AnySectionController, AnyChatCellViewModel>] = []

    private let updateDataQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.qualityOfService = .userInteractive

        return operationQueue
    }()

    var isInverted = true
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
        view.addSubview(composerView)
        view.addSubview(collectionView)

        collectionView.transform = isInverted ? invertedTransform : collectionView.transform

        composerView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        let topMargin = view.safeAreaLayoutGuide.topAnchor
        let bottomMargin = view.safeAreaLayoutGuide.bottomAnchor

        composerView.bottomAnchor.constraint(equalTo: bottomMargin).isActive = true
        composerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        composerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        collectionView.topAnchor.constraint(equalTo: topMargin).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: composerView.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        collectionView.dataSource = self
        collectionView.delegate = self
    }

    @objc func updateData() {
        updateDataQueue.addOperation { [weak self] in
            guard let strongSelf = self else { return }

            DispatchQueue.main.async {
                let changeset = StagedChangeset(source: strongSelf.internalData, target: strongSelf.data.map({ $0.toArraySection }))
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
        return sectionController.cell(for: viewModel, on: collectionView, at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.contentView.transform = isInverted ? invertedTransform : cell.contentView.transform
    }
}

extension RocketChatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionController = internalData[indexPath.section].model
        let viewModel = sectionController.viewModels()[indexPath.row]

        guard let height = sectionController.height(for: viewModel) else {
            return CGSize.zero
        }

        return CGSize(width: UIScreen.main.bounds.width, height: height)
    }
}

// MARK: Composer Delegate

extension RocketChatViewController: RCComposerViewDelegate {
    func composerView(_ composerView: RCComposerView, didTapButtonAt slot: RCComposerButtonSlot) {
        switch slot {
        case .right:
            composerView.textView.text = ""
        case .left:
            break
        }
    }

    func composerView(_ composerView: RCComposerView, heightForAddonAt slot: RCComposerAddonSlot) -> CGFloat {
        return CGFloat(50.0 * (sin(Date().timeIntervalSince1970) + 1))
    }

    func composerView(_ composerView: RCComposerView, addonAt slot: RCComposerAddonSlot) -> RCComposerAddon? {
        return .replyAddon
    }

    func composerView(_ composerView: RCComposerView, didUpdateAddonView view: UIView?, at slot: RCComposerAddonSlot) {
        if let replyView = view as? RCReplyAddonView {
            replyView.backgroundColor = .orange
        }
    }
}
