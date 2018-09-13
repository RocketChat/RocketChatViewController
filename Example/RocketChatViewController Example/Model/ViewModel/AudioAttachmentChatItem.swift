//
//  AudioAttachmentViewModel.swift
//  RocketChatViewController Example
//
//  Created by Filipe Alvarenga on 04/09/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import Foundation
import DifferenceKit

struct AudioAttachmentChatItem: ChatItem, Differentiable {
    var relatedReuseIdentifier: String {
        return AudioAttachmentChatCell.identifier
    }

    var url: URL

    // MARK: Differentiable

    var differenceIdentifier: String {
        return url.absoluteString
    }

    func isContentEqual(to source: AudioAttachmentChatItem) -> Bool {
        return url.absoluteString == source.url.absoluteString
    }
}
