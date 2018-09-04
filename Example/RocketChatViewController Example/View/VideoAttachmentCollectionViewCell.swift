//
//  VideoAttachmentCollectionViewCell.swift
//  RocketChatViewController Example
//
//  Created by Filipe Alvarenga on 04/09/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit

class VideoAttachmentCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: VideoAttachmentCollectionViewCell.self)

    @IBOutlet weak var videoPreview: UIImageView!

    override func bind(viewModel: Any) {
        guard let _ = viewModel as? VideoAttachmentViewModel else {
            return
        }

        // Bind remote video URL on video player view
    }

}
