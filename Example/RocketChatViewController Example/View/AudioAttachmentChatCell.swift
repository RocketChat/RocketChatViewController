//
//  AudioAttachmentCollectionViewCell.swift
//  RocketChatViewController Example
//
//  Created by Filipe Alvarenga on 04/09/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit
import RocketChatViewController

class AudioAttachmentChatCell: UICollectionViewCell, ChatCell {
    var adjustedHorizontalInsets: CGFloat = 0

    static let identifier = String(describing: AudioAttachmentChatCell.self)

    var viewModel: AnyChatItem?

    func configure() {
        guard let _ = viewModel?.base as? AudioAttachmentChatItem else {
            return
        }

        // Bind audio file from remote url
    }
}
