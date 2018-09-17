//
//  RocketChatViewController.swift
//  RocketChatViewController Example
//
//  Created by Rafael Kellermann Streit on 30/07/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit
import DifferenceKit

fileprivate extension NSNotification.Name {
    static let triggerDataUpdate = NSNotification.Name("TRIGGER_DATA_UPDATE")
}

public extension UICollectionView {
    public func dequeueChatCell(withReuseIdentifier reuseIdetifier: String, for indexPath: IndexPath) -> ChatCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: reuseIdetifier, for: indexPath) as? ChatCell else {
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

public struct AnyChatItem: ChatItem, Differentiable {
   public var relatedReuseIdentifier: String {
        return base.relatedReuseIdentifier
    }

    public let base: ChatItem
    public let differenceIdentifier: AnyHashable

    let isUpdatedFrom: (AnyChatItem) -> Bool

    public init<D: Differentiable & ChatItem>(_ base: D) {
        self.base = base
        self.differenceIdentifier = AnyHashable(base.differenceIdentifier)

        self.isUpdatedFrom = { source in
            guard let sourceBase = source.base as? D else { return false }
            return base.isContentEqual(to: sourceBase)
        }
    }

    public func isContentEqual(to source: AnyChatItem) -> Bool {
        return isUpdatedFrom(source)
    }
}

/**
    A type-erased SectionController.

    The `AnySectionController` type forwards equality comparisons and servers as a data source
    for RocketChatViewController to build one section, hiding its specific underlying type.
 */

public struct AnyChatSection: ChatSection {
    public var object: AnyDifferentiable {
        return base.object
    }

    public let base: ChatSection

    public init<D: ChatSection>(_ base: D) {
        self.base = base
    }

    public func viewModels() -> [AnyChatItem] {
        return base.viewModels()
    }

    public func cell(for viewModel: AnyChatItem, on collectionView: UICollectionView, at indexPath: IndexPath) -> ChatCell {
        return base.cell(for: viewModel, on: collectionView, at: indexPath)
    }
}

extension AnyChatSection: Differentiable {
    public var differenceIdentifier: AnyHashable {
        return AnyHashable(base.object.differenceIdentifier)
    }

    public func isContentEqual(to source: AnyChatSection) -> Bool {
        return base.object.isContentEqual(to: source.object)
    }
}

fileprivate extension AnyChatSection {
    var toArraySection: ArraySection<AnyChatSection, AnyChatItem> {
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

public protocol ChatSection {
    var object: AnyDifferentiable { get }
    func viewModels() -> [AnyChatItem]
    func cell(for viewModel: AnyChatItem, on collectionView: UICollectionView, at indexPath: IndexPath) -> ChatCell
}

public extension ChatSection {
    public func update() {
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

public protocol ChatItem {
    var relatedReuseIdentifier: String { get }
}

public extension ChatItem where Self: Differentiable {
    // In order to use a ChatCellViewModel along with a SectionController
    // we must use it as a type-erased ChatCellViewModel, which in this case also means
    // that it must conform to the Differentiable protocol.
    public var wrapped: AnyChatItem {
        return AnyChatItem(self)
    }
}

/**
    A protocol that must be implemented by all cells to padronize the way we bind the data on its view.
 */

public protocol ChatCell {
    func bind(viewModel: AnyChatItem)
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

open class RocketChatViewController: UIViewController {
    public var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )

        collectionView.backgroundColor = .white
        return collectionView
    }()

    open var composerHeightConstraint: NSLayoutConstraint!
    open var viewComposer: UIView! = UIView()

    open var data: [AnyChatSection] = []
    private var internalData: [ArraySection<AnyChatSection, AnyChatItem>] = []

    private let updateDataQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.qualityOfService = .background

        return operationQueue
    }()

    open var isInverted = false
    open var isSelfSizing = true
    private let invertedTransform = CGAffineTransform(scaleX: 1, y: -1)

    override open func viewDidLoad() {
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

    override open func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            super.viewSafeAreaInsetsDidChange()

            let top = isInverted ? view.safeAreaInsets.bottom : view.safeAreaInsets.top
            let bottom = isInverted ? view.safeAreaInsets.top : view.safeAreaInsets.bottom

            collectionView.contentInset = UIEdgeInsets(
                top: top,
                left: view.safeAreaInsets.left,
                bottom: bottom,
                right: view.safeAreaInsets.right
            )
        }
    }

    func setupChatViews() {
        view.addSubview(viewComposer)
        view.addSubview(collectionView)

        collectionView.transform = isInverted ? invertedTransform : collectionView.transform

        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout, isSelfSizing {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }

        viewComposer.backgroundColor = .blue
        collectionView.backgroundColor = .red

        viewComposer.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        var bottomMargin: NSLayoutYAxisAnchor
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
            bottomMargin = view.safeAreaLayoutGuide.bottomAnchor
        } else {
            bottomMargin = view.bottomAnchor
        }

        composerHeightConstraint = viewComposer.heightAnchor.constraint(equalToConstant: 50)

        NSLayoutConstraint.activate([
            composerHeightConstraint,
            viewComposer.bottomAnchor.constraint(equalTo: bottomMargin),
            viewComposer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewComposer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: viewComposer.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.scrollsToTop = false
    }

    @objc open func updateData() {
        updateDataQueue.addOperation { [weak self] in
            guard let strongSelf = self else { return }

            DispatchQueue.main.async {
                let changeset = StagedChangeset(source: strongSelf.internalData, target: strongSelf.data.map({ $0.toArraySection }))
                strongSelf.collectionView.reload(using: changeset, updateRows: { indexPaths in
                    for indexPath in indexPaths {
                        if strongSelf.collectionView.indexPathsForVisibleItems.contains(indexPath),
                            let cell = strongSelf.collectionView.cellForItem(at: indexPath) as? ChatCell {
                            let viewModel = strongSelf.internalData[indexPath.section].elements[indexPath.item]
                            cell.bind(viewModel: viewModel)
                        }
                    }
                }, interrupt: { $0.changeCount > 100 }) { newData in
                    strongSelf.internalData = newData
                    strongSelf.data = newData.map { $0.model }
                }
            }
        }
    }

}

extension RocketChatViewController: UICollectionViewDataSource {
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return internalData.count
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return internalData[section].elements.count
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionController = internalData[indexPath.section].model
        let viewModel = sectionController.viewModels()[indexPath.row]

        guard let chatCell = sectionController.cell(for: viewModel, on: collectionView, at: indexPath) as? UICollectionViewCell else {
            fatalError("The object conforming to BindableCell is not a UICollectionViewCell as it must be")
        }

        return chatCell
    }

    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.contentView.transform = isInverted ? invertedTransform : cell.contentView.transform
    }
}

extension RocketChatViewController: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

}
