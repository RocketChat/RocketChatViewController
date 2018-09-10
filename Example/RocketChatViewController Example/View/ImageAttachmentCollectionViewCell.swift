//
//  ImageAttachmentCollectionViewCell.swift
//  RocketChatViewController Example
//
//  Created by Filipe Alvarenga on 04/09/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit

class ImageAttachmentCollectionViewCell: UICollectionViewCell, BindableCell {
    static let identifier = String(describing: ImageAttachmentCollectionViewCell.self)

    @IBOutlet weak var image: UIImageView!

    func bind(viewModel: AnyChatCellViewModel) {
        guard let _ = viewModel.base as? ImageAttachmentViewModel else {
            return
        }

        // Bind remote image on image view
    }
}
