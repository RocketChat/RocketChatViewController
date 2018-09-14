//
//  BasicMessageViewModel.swift
//  RocketChatViewController Example
//
//  Created by Filipe Alvarenga on 05/08/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import Foundation
import DifferenceKit
import RocketChatViewController

struct BasicMessageChatItem: ChatItem, Differentiable {
    var relatedReuseIdentifier: String {
        return BasicMessageChatCell.identifier
    }

    var username: String
    var text: String

    // MARK: Differentiable

    var differenceIdentifier: String {
        return username + text
    }

    func isContentEqual(to source: BasicMessageChatItem) -> Bool {
        return text == source.text
    }
}
