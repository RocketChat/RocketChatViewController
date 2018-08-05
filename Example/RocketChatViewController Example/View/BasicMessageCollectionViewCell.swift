//
//  BasicMessageCollectionViewCell.swift
//  RocketChatViewController Example
//
//  Created by Filipe Alvarenga on 05/08/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit

protocol BindableCell {
    func bind(viewModel: Any)
}

extension UICollectionViewCell: BindableCell {
    @objc func bind(viewModel: Any) {}
}

class BasicMessageCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: BasicMessageCollectionViewCell.self)

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var message: UILabel!

    override func bind(viewModel: Any) {
        guard let viewModel = viewModel as? BasicMessageViewModel else {
            return
        }

        username.text = viewModel.username
        message.text = viewModel.text
    }

}
