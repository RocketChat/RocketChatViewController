//
//  MessageSectionModel.swift
//  RocketChatViewController Example
//
//  Created by Filipe Alvarenga on 05/08/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import Foundation
import IGListKit

final class MessageSectionModel: ListDiffable {
    let identifier: String
    let message: Message

    init(identifier: String, message: Message) {
        self.identifier = identifier
        self.message = message
    }

    // MARK: ListDiffable

    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? MessageSectionModel else  { return false }
        return object.identifier == identifier
            && object.message.text == message.text
    }
}
