//
//  ChatViewController.swift
//  RocketChatViewController Example
//
//  Created by Filipe Alvarenga on 22/08/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit
import DifferenceKit
import RocketChatViewController

final class ChatViewController: RocketChatViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        isSelfSizing = true

        collectionView.register(
            UINib(
                nibName: BasicMessageChatCell.identifier, bundle: nil
            ),
            forCellWithReuseIdentifier: BasicMessageChatCell.identifier
        )

        collectionView.register(
            UINib(
                nibName: ImageAttachmentChatCell.identifier, bundle: nil
            ),
            forCellWithReuseIdentifier: ImageAttachmentChatCell.identifier
        )

        collectionView.register(
            UINib(
                nibName: VideoAttachmentChatCell.identifier, bundle: nil
            ),
            forCellWithReuseIdentifier: VideoAttachmentChatCell.identifier
        )

        collectionView.register(
            UINib(
                nibName: AudioAttachmentChatCell.identifier, bundle: nil
            ),
            forCellWithReuseIdentifier: AudioAttachmentChatCell.identifier
        )

        data = DataControllerPlaceholder.generateDumbData(elements: 1000)
        updateData()
    }

}

