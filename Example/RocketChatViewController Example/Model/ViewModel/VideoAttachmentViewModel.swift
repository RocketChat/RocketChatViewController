//
//  VideoAttachmentViewModel.swift
//  RocketChatViewController Example
//
//  Created by Filipe Alvarenga on 04/09/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import Foundation
import DifferenceKit

struct VideoAttachmentViewModel: ChatCellViewModel, Differentiable {
    var relatedReuseIdentifier: String {
        return VideoAttachmentCollectionViewCell.identifier
    }

    var url: URL

    func heightForCurrentState() -> CGFloat? {
        return 222
    }

    // MARK: Differentiable

    var differenceIdentifier: String {
        return url.absoluteString
    }

    func isContentEqual(to source: VideoAttachmentViewModel) -> Bool {
        return url.absoluteString == source.url.absoluteString
    }
}
