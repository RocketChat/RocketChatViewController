//
//  RocketChatViewController.swift
//  RocketChatViewController Example
//
//  Created by Rafael Kellermann Streit on 30/07/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit
import DifferenceKit

struct AnyChatViewModel: ChatViewModel, Differentiable {
    var relatedReuseIdentifier: String {
        return base.relatedReuseIdentifier
    }

    let base: ChatViewModel
    let differenceIdentifier: AnyHashable

    let isUpdatedFrom: (AnyChatViewModel) -> Bool

    public init<D: Differentiable & ChatViewModel>(_ base: D) {
        self.base = base
        self.differenceIdentifier = AnyHashable(base.differenceIdentifier)

        self.isUpdatedFrom = { source in
            guard let sourceBase = source.base as? D else { return false }
            return base.isUpdated(from: sourceBase)
        }
    }

    func isUpdated(from source: AnyChatViewModel) -> Bool {
        return isUpdated(from: source)
    }
}

struct AnySectionController: SectionController, Differentiable {
    var model: AnyDifferentiable {
        return base.model
    }

    let base: SectionController
    let differenceIdentifier: AnyHashable

    let isUpdatedFrom: (AnySectionController) -> Bool

    public init<D: Differentiable & SectionController>(_ base: D) {
        self.base = base
        self.differenceIdentifier = AnyHashable(base.differenceIdentifier)

        self.isUpdatedFrom = { source in
            guard let sourceBase = source.base as? D else { return false }
            return base.isUpdated(from: sourceBase)
        }
    }

    func isUpdated(from source: AnySectionController) -> Bool {
        return isUpdatedFrom(source)
    }

    func viewModels() -> [AnyChatViewModel] {
        return base.viewModels()
    }

    func cell(for viewModel: AnyChatViewModel, on collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        return base.cell(for: viewModel, on: collectionView, at: indexPath)
    }

    func height(for viewModel: AnyChatViewModel) -> CGFloat? {
        return base.height(for: viewModel)
    }
}

protocol SectionController {
    var model: AnyDifferentiable { get }
    func viewModels() -> [AnyChatViewModel]
    func cell(for viewModel: AnyChatViewModel, on collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell
    func height(for viewModel: AnyChatViewModel) -> CGFloat?
}

protocol ChatViewModel {
    var relatedReuseIdentifier: String { get }
}

extension ChatViewModel where Self: Differentiable {
    var anyChatViewModel: AnyChatViewModel {
        return AnyChatViewModel(self)
    }
}

protocol BindableCell {
    func bind(viewModel: Any)
}

extension UICollectionViewCell: BindableCell {
    @objc func bind(viewModel: Any) {}
}

final class RocketChatViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewComposer: UIView!

    let dataController = DataController()
    var data: [Section<AnySectionController, AnyChatViewModel>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(
            UINib(
                nibName: BasicMessageCollectionViewCell.identifier, bundle: nil
            ),
            forCellWithReuseIdentifier: BasicMessageCollectionViewCell.identifier
        )

        data = DataControllerPlaceholder.generateDumbData(elements: 5000)
    }

}

extension RocketChatViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].elements.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionController = data[indexPath.section].model.base
        let viewModel = sectionController.viewModels()[indexPath.row]
        return sectionController.cell(for: viewModel, on: collectionView, at: indexPath)
    }
}

extension RocketChatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionController = data[indexPath.section].model.base
        let viewModel = sectionController.viewModels()[indexPath.row]

        guard let height = sectionController.height(for: viewModel) else {
            return CGSize.zero
        }

        return CGSize(width: UIScreen.main.bounds.width, height: height)
    }
}
