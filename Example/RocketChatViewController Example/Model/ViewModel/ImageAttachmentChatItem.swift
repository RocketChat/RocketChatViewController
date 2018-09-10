//
//  ImageAttachmentViewModel.swift
//  RocketChatViewController Example
//
//  Created by Filipe Alvarenga on 04/09/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import Foundation
import DifferenceKit

struct ImageAttachmentChatItem: ChatItem, Differentiable {
    var relatedReuseIdentifier: String {
        return ImageAttachmentChatCell.identifier
    }

    var url: URL

    // MARK: Differentiable

    var differenceIdentifier: String {
        return url.absoluteString
    }

    func isContentEqual(to source: ImageAttachmentChatItem) -> Bool {
        return url.absoluteString == source.url.absoluteString
    }
}
