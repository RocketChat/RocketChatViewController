//
//  MessageSectionModel.swift
//  RocketChatViewController Example
//
//  Created by Filipe Alvarenga on 05/08/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import Foundation
import DifferenceKit

struct MessageSectionModel: Differentiable {
    let identifier: String
    var message: Message

    init(identifier: String, message: Message) {
        self.identifier = identifier
        self.message = message
    }

    // MARK: Differentiable

    var differenceIdentifier: String {
        return identifier
    }

    func isContentEqual(to source: MessageSectionModel) -> Bool {
        return message.text == source.message.text
    }
}
