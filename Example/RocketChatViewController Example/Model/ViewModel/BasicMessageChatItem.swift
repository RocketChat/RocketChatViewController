//
//  BasicMessageViewModel.swift
//  RocketChatViewController Example
//
//  Created by Filipe Alvarenga on 05/08/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import Foundation
import DifferenceKit

struct BasicMessageChatItem: ChatItem, Differentiable, Equatable {
    var relatedReuseIdentifier: String {
        return BasicMessageChatCell.identifier
    }

    var username: String
    var text: String

    // MARK: Differentiable

    var differenceIdentifier: String {
        return username + text
    }
}
