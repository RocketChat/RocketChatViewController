//
//  BasicMessageCollectionViewCell.swift
//  RocketChatViewController Example
//
//  Created by Filipe Alvarenga on 05/08/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit
import RocketChatViewController
 
final class BasicMessageChatCell: UICollectionViewCell, ChatCell {
    static let identifier = String(describing: BasicMessageChatCell.self)

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var message: UILabel!

    func bind(viewModel: AnyChatItem) {
        guard let viewModel = viewModel.base as? BasicMessageChatItem else {
            return
        }

        username.text = viewModel.username
        message.text = viewModel.text
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()

        let layoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        let height = systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        layoutAttributes.bounds.size.height = height

        return layoutAttributes
    }

}
