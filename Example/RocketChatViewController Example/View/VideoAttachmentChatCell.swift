//
//  VideoAttachmentCollectionViewCell.swift
//  RocketChatViewController Example
//
//  Created by Filipe Alvarenga on 04/09/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit
import RocketChatViewController

class VideoAttachmentChatCell: UICollectionViewCell, ChatCell {
    var messageWidth: CGFloat = 0

    static let identifier = String(describing: VideoAttachmentChatCell.self)

    @IBOutlet weak var videoPreview: UIImageView!

    var viewModel: AnyChatItem?

    func configure(completeRendering: Bool) {
        guard let _ = viewModel?.base as? VideoAttachmentChatItem else {
            return
        }

        // Bind remote video URL on video player view
    }
}
