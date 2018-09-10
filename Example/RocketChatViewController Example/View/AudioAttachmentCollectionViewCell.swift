//
//  AudioAttachmentCollectionViewCell.swift
//  RocketChatViewController Example
//
//  Created by Filipe Alvarenga on 04/09/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit

class AudioAttachmentCollectionViewCell: UICollectionViewCell, BindableCell {
    static let identifier = String(describing: AudioAttachmentCollectionViewCell.self)

    func bind(viewModel: AnyChatCellViewModel) {
        guard let _ = viewModel.base as? AudioAttachmentViewModel else {
            return
        }

        // Bind audio file from remote url
    }
}
