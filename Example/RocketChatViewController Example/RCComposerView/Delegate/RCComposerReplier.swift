//
//  RCComposerReplier.swift
//  RocketChatViewController Example
//
//  Created by Matheus Cardoso on 9/12/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit

protocol RCComposerReplier {
    var isComposerReplying: Bool { get }
}

extension RCComposerDelegate where Self: RCComposerReplier {
    func numberOfAddons(in composerView: RCComposerView, at slot: RCComposerAddonSlot) -> UInt {
        return slot == .component ? 1 : 0
    }

    func composerView(_ composerView: RCComposerView, heightForAddonAt slot: RCComposerAddonSlot, index: UInt) -> CGFloat {
        guard isComposerReplying else {
            return 0.0
        }

        return 50.0
    }

    func composerView(_ composerView: RCComposerView, addonAt slot: RCComposerAddonSlot, index: UInt) -> RCComposerAddon? {
        guard isComposerReplying else {
            return nil
        }

        switch slot {
        case .utility:
            return .reply
        case .component:
            return nil
        }
    }

    func composerView(_ composerView: RCComposerView, didUpdateAddonView view: UIView?, at slot: RCComposerAddonSlot, index: UInt) {
        switch slot {
        case .component:
            view?.backgroundColor = .blue
        default:
            break
        }
    }
}
