//
//  DataController.swift
//  RocketChatViewController Example
//
//  Created by Rafael Kellermann Streit on 31/07/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import Foundation

struct Attachment {
    let type: Int // 0 - Image, 1 - Video, 2 - Audio
    let url: URL
}

struct Message {
    let identifier: String
    let text: String
    let attachments: [Attachment]
}

struct Object {
    let identifier: String
    let message: Message
}

final class DataController {

    var data: [Object] = []

    var numberOfSections: Int {
        return 1
    }

    var numberOfRows: Int {
        return data.count
    }

    func object(for indexPath: IndexPath) -> Object? {
        if indexPath.row < data.count {
            return data[indexPath.row]
        }

        return nil
    }

}
