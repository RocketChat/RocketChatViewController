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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataController.data = DataControllerPlaceholder.generateDumbData(elements: 5000)
        
    }

}
