//
//  RocketChatViewController.swift
//  RocketChatViewController Example
//
//  Created by Rafael Kellermann Streit on 30/07/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit

final class RocketChatViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewComposer: UIView!

    let dataController = DataController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataController.data = DataControllerPlaceholder.generateDumbData(elements: 5000)
        
    }

}
