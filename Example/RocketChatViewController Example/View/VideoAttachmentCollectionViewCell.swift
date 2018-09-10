//
//  VideoAttachmentCollectionViewCell.swift
//  RocketChatViewController Example
//
//  Created by Filipe Alvarenga on 04/09/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit

class VideoAttachmentCollectionViewCell: UICollectionViewCell, BindableCell {
    static let identifier = String(describing: VideoAttachmentCollectionViewCell.self)

    @IBOutlet weak var videoPreview: UIImageView!

    func bind(viewModel: AnyChatCellViewModel) {
        guard let _ = viewModel.base as? VideoAttachmentViewModel else {
            return
        }

        // Bind remote video URL on video player view
    }
}
