//
//  ChatViewController.swift
//  RocketChatViewController Example
//
//  Created by Filipe Alvarenga on 22/08/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit
import DifferenceKit

final class ChatViewController: RocketChatViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(
            UINib(
                nibName: BasicMessageCollectionViewCell.identifier, bundle: nil
            ),
            forCellWithReuseIdentifier: BasicMessageCollectionViewCell.identifier
        )

        collectionView.register(
            UINib(
                nibName: ImageAttachmentCollectionViewCell.identifier, bundle: nil
            ),
            forCellWithReuseIdentifier: ImageAttachmentCollectionViewCell.identifier
        )

        collectionView.register(
            UINib(
                nibName: VideoAttachmentCollectionViewCell.identifier, bundle: nil
            ),
            forCellWithReuseIdentifier: VideoAttachmentCollectionViewCell.identifier
        )

        collectionView.register(
            UINib(
                nibName: AudioAttachmentCollectionViewCell.identifier, bundle: nil
            ),
            forCellWithReuseIdentifier: AudioAttachmentCollectionViewCell.identifier
        )

        data = DataControllerPlaceholder.generateDumbData(elements: 10)
        updateData()
        data = []
        updateData()
        data = DataControllerPlaceholder.generateDumbData(elements: 220)
        updateData()
    }
}
