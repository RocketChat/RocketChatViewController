//
//  RocketChatViewController.swift
//  RocketChatViewController Example
//
//  Created by Rafael Kellermann Streit on 30/07/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit
import DifferenceKit

protocol SectionController {
    static func viewModels(for object: Any) -> [AnyDifferentiable]
    func cell(for viewModel: Any, on collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell
    func height(for viewModel: Any) -> CGFloat?
}

typealias ChatData = (object: AnyDifferentiable, sectionController: AnyDifferentiable)

final class RocketChatViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewComposer: UIView!

    let dataController = DataController()
    var data: [MessageSection] = []
    
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
        let sectionController = data[indexPath.section]
        let viewModel = sectionController.elements[indexPath.row].base
        return sectionController.cell(for: viewModel, on: collectionView, at: indexPath)
    }
}

extension RocketChatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionController = data[indexPath.section]
        let viewModel = sectionController.elements[indexPath.row].base

        guard let height = sectionController.height(for: viewModel) else {
            return CGSize.zero
        }

        return CGSize(width: UIScreen.main.bounds.width, height: height)
    }
}
