//
//  ImageAttachmentCollectionViewCell.swift
//  RocketChatViewController Example
//
//  Created by Filipe Alvarenga on 04/09/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit

class ImageAttachmentChatCell: UICollectionViewCell, ChatCell {
    static let identifier = String(describing: ImageAttachmentChatCell.self)

    @IBOutlet weak var image: UIImageView!

    func bind(viewModel: AnyChatItem) {
        guard let _ = viewModel.base as? ImageAttachmentChatItem else {
            return
        }

        // Bind remote image on image view
    }
}
