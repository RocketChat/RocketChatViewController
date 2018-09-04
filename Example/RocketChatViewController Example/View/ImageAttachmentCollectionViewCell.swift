//
//  ImageAttachmentCollectionViewCell.swift
//  RocketChatViewController Example
//
//  Created by Filipe Alvarenga on 04/09/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit

class ImageAttachmentCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: ImageAttachmentCollectionViewCell.self)

    @IBOutlet weak var image: UIImageView!

    override func bind(viewModel: Any) {
        guard let _ = viewModel as? ImageAttachmentViewModel else {
            return
        }

        // Bind remote image on image view
    }
    
}
