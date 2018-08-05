//
//  RocketChatViewController.swift
//  RocketChatViewController Example
//
//  Created by Rafael Kellermann Streit on 30/07/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit
import IGListKit

protocol SectionController {
    var object: ListDiffable? { get }

    func viewModels() -> [Any]
    func cell(for viewModel: Any, on collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell
    func height(for viewModel: Any) -> CGFloat?
}

typealias ChatData = (object: ListDiffable, sectionController: SectionController)

final class RocketChatViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewComposer: UIView!

    let dataController = DataController()
    var data: [ChatData] = []
    
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
        return data[section].sectionController.viewModels().count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionController = data[indexPath.section].sectionController
        let viewModel = sectionController.viewModels()[indexPath.row]

        return sectionController.cell(for: viewModel, on: collectionView, at: indexPath)
    }
}

extension RocketChatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionController = data[indexPath.section].sectionController
        let viewModel = sectionController.viewModels()[indexPath.row]

        guard let height = sectionController.height(for: viewModel) else {
            return CGSize.zero
        }

        return CGSize(width: UIScreen.main.bounds.width, height: height)
    }
}
