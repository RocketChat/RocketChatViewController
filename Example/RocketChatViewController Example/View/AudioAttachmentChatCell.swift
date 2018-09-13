//
//  AudioAttachmentCollectionViewCell.swift
//  RocketChatViewController Example
//
//  Created by Filipe Alvarenga on 04/09/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit

class AudioAttachmentChatCell: UICollectionViewCell, ChatCell {
    static let identifier = String(describing: AudioAttachmentChatCell.self)

    func bind(viewModel: AnyChatItem) {
        guard let _ = viewModel.base as? AudioAttachmentChatItem else {
            return
        }

        // Bind audio file from remote url
    }
}
