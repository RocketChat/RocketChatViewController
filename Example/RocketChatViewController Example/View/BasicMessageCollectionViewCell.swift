//
//  BasicMessageCollectionViewCell.swift
//  RocketChatViewController Example
//
//  Created by Filipe Alvarenga on 05/08/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit
 
class BasicMessageCollectionViewCell: UICollectionViewCell, BindableCell {
    static let identifier = String(describing: BasicMessageCollectionViewCell.self)

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var message: UILabel!

    func bind(viewModel: AnyChatCellViewModel) {
        guard let viewModel = viewModel.base as? BasicMessageViewModel else {
            return
        }

        username.text = viewModel.username
        message.text = viewModel.text
    }

}
