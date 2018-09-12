//
//  RCComposerReplierHinter.swift
//  RocketChatViewController Example
//
//  Created by Matheus Cardoso on 9/12/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit

typealias RCComposerReplierHinter = RCComposerReplier & RCComposerHinter

extension RCComposerDelegate where Self: RCComposerReplierHinter {
    func numberOfAddons(in composerView: RCComposerView, at slot: RCComposerAddonSlot) -> UInt {
        return 1
    }

    func composerView(_ composerView: RCComposerView, heightForAddonAt slot: RCComposerAddonSlot, index: UInt) -> CGFloat {
        guard isComposerHinting else {
            return 0.0
        }

        return 50.0
    }

    func composerView(_ composerView: RCComposerView, addonAt slot: RCComposerAddonSlot, index: UInt) -> RCComposerAddon? {
        switch slot {
        case .utility:
            return isComposerHinting ? .hint : nil
        case .component:
            return isComposerReplying ? .reply : nil
        }
    }

    func composerView(_ composerView: RCComposerView, didUpdateAddonView view: UIView?, at slot: RCComposerAddonSlot, index: UInt) {
        switch slot {
        case .utility:
            view?.backgroundColor = .orange
        case .component:
            view?.backgroundColor = .blue
        }
    }
}
