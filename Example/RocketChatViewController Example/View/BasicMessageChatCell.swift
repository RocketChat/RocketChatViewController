//
//  BasicMessageCollectionViewCell.swift
//  RocketChatViewController Example
//
//  Created by Filipe Alvarenga on 05/08/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit
 
class BasicMessageChatCell: UICollectionViewCell, ChatCell {
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

}
