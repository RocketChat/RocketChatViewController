//
//  RCComposerAddon.swift
//  RocketChatViewController Example
//
//  Created by Matheus Cardoso on 9/6/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit

struct RCComposerAddon: Hashable {
    let viewType: UIView.Type

    var hashValue: Int {
        return viewType.hash()
    }

    static func == (lhs: RCComposerAddon, rhs: RCComposerAddon) -> Bool {
        return lhs.viewType == rhs.viewType
    }
}

extension RCComposerAddon {
    static var reply: RCComposerAddon {
        return RCComposerAddon(viewType: RCReplyAddonView.self)
    }

    static var hint: RCComposerAddon {
        return RCComposerAddon(viewType: RCReplyAddonView.self)
    }
}
