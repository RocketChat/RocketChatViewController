//
//  AudioAttachmentViewModel.swift
//  RocketChatViewController Example
//
//  Created by Filipe Alvarenga on 04/09/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import Foundation
import DifferenceKit

struct AudioAttachmentViewModel: ChatCellViewModel, Differentiable {
    var relatedReuseIdentifier: String {
        return AudioAttachmentCollectionViewCell.identifier
    }

    var url: URL

    func heightForCurrentState() -> CGFloat? {
        return 44
    }

    // MARK: Differentiable

    var differenceIdentifier: String {
        return url.absoluteString
    }

    func isContentEqual(to source: AudioAttachmentViewModel) -> Bool {
        return url.absoluteString == source.url.absoluteString
    }
}
