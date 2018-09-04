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

protocol SectionController {
    var object: AnyDifferentiable { get }
    func viewModels() -> [AnyChatCellViewModel]
    func cell(for viewModel: AnyChatCellViewModel, on collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell
    func height(for viewModel: AnyChatCellViewModel) -> CGFloat?
}

protocol ChatCellViewModel {
    var relatedReuseIdentifier: String { get }
    func heightForCurrentState() -> CGFloat?
}

extension ChatCellViewModel {
    func heightForCurrentState() -> CGFloat? { return nil }
}

extension ChatCellViewModel where Self: Differentiable {
    var wrapped: AnyChatCellViewModel {
        return AnyChatCellViewModel(self)
    }
}

protocol BindableCell {
    func bind(viewModel: Any)
}

extension UICollectionViewCell: BindableCell {
    @objc func bind(viewModel: Any) {}
}

class RocketChatViewController: UIViewController {
    var collectionView: UICollectionView =  {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )

        collectionView.backgroundColor = .white
        return collectionView
    }()
    var viewComposer: UIView! = UIView()

    var data: [Section] = []
    private var internalData: [Section] = []

    private let updateDataQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.qualityOfService = .userInteractive

        return operationQueue
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupChatViews()
    }

    func setupChatViews() {
        view.addSubview(viewComposer)
        view.addSubview(collectionView)

        viewComposer.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        let topMargin = view.safeAreaLayoutGuide.topAnchor
        let bottomMargin = view.safeAreaLayoutGuide.bottomAnchor

        viewComposer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        viewComposer.bottomAnchor.constraint(equalTo: bottomMargin).isActive = true
        viewComposer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        viewComposer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        collectionView.topAnchor.constraint(equalTo: topMargin).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: viewComposer.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        collectionView.dataSource = self
        collectionView.delegate = self
    }

    func updateData() {
        updateDataQueue.addOperation { [weak self] in
            guard let strongSelf = self else { return }

            DispatchQueue.main.async {
                let changeset = StagedChangeset(source: strongSelf.internalData, target: strongSelf.data)
                strongSelf.collectionView.reload(using: changeset, interrupt: { $0.changeCount > 100 }) { newData in
                    strongSelf.internalData = newData
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
        let sectionController = internalData[indexPath.section].model.base
        let viewModel = sectionController.viewModels()[indexPath.row]
        return sectionController.cell(for: viewModel, on: collectionView, at: indexPath)
    }
}

extension RocketChatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionController = internalData[indexPath.section].model.base
        let viewModel = sectionController.viewModels()[indexPath.row]

        guard let height = sectionController.height(for: viewModel) else {
            return CGSize.zero
        }

        return CGSize(width: UIScreen.main.bounds.width, height: height)
    }
}
