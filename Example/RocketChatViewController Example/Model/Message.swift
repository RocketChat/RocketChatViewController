//
//  Message.swift
//  RocketChatViewController Example
//
//  Created by Filipe Alvarenga on 05/08/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import Foundation

struct Message {
    let identifier: String
    let text: String
    let attachments: [Attachment]
}
