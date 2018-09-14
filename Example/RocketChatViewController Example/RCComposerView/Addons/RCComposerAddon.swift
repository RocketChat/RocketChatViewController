//
//  RCComposerAddon.swift
//  RocketChatViewController Example
//
//  Created by Matheus Cardoso on 9/6/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit

struct RCComposerAddon {
    let viewType: UIView.Type

    static func == (lhs: RCComposerAddon, rhs: RCComposerAddon) -> Bool {
        return lhs.viewType == rhs.viewType
    }
}

extension RCComposerAddon {
    static var reply: RCComposerAddon {
        return RCComposerAddon(viewType: RCReplyView.self)
    }

    static var hints: RCComposerAddon {
        return RCComposerAddon(viewType: RCHintsView.self)
    }
}
