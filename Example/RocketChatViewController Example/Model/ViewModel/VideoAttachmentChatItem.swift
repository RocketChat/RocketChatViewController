//
//  VideoAttachmentViewModel.swift
//  RocketChatViewController Example
//
//  Created by Filipe Alvarenga on 04/09/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import Foundation
import DifferenceKit

struct VideoAttachmentChatItem: ChatItem, Differentiable, Equatable {
    var relatedReuseIdentifier: String {
        return VideoAttachmentChatCell.identifier
    }

    var url: URL

    // MARK: Differentiable

    var differenceIdentifier: String {
        return url.absoluteString
    }
}
