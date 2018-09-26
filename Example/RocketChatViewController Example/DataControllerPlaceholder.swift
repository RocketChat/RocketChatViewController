//
//  DataControllerPlaceholder.swift
//  RocketChatViewController Example
//
//  Created by Rafael Kellermann Streit on 31/07/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import Foundation
import DifferenceKit
import RocketChatViewController

struct DataControllerPlaceholder {

    static func generateRandom(size: UInt = 20) -> String {
        let prefixSize = Int(min(size, 43))
        let uuidString = UUID().uuidString.replacingOccurrences(of: "-", with: "")

        return String(Data(uuidString.utf8)
            .base64EncodedString()
            .replacingOccurrences(of: "=", with: "")
            .prefix(prefixSize))
    }

    static private func generateAttachment() -> Attachment? {
        let randomInt = Int(arc4random_uniform(4))

        if randomInt == 0 {
            return nil
        }

        return Attachment(
            type: randomInt,
            url: URL(string: "https://unsplash.com/photos/oJW6cBoCHfo/download?force=true")!
        )
    }

    static private func generateObject() -> MessageSectionModel {
        var attachments: [Attachment] = []

        if let attachment = generateAttachment() {
            attachments.append(attachment)
        }

        let identifier = generateRandom(size: 20)
        let message = Message(
            identifier: identifier,
            text: generateRandom(size: 43),
            attachments: attachments
        )

        return MessageSectionModel(identifier: identifier, message: message)
    }

    static func generateDumbData(elements: Int = 5000) -> [AnyChatSection] {
        var data: [AnyChatSection] = []

        for _ in 1...elements {
            let object = generateObject()
            let sectionController = AnyChatSection(
                MessageChatSection(
                    object: AnyDifferentiable(
                        object
                    ),
                    controllerContext: nil
                )
            )

            data.append(sectionController)
        }

        return data
    }

}
