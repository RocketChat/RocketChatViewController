//
//  RCComposerHinter.swift
//  RocketChatViewController Example
//
//  Created by Matheus Cardoso on 9/12/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit

protocol RCComposerHinter {
    var isComposerHinting: Bool { get }
}

extension RCComposerDelegate where Self: RCComposerHinter {
    func numberOfAddons(in composerView: RCComposerView, at slot: RCComposerAddonSlot) -> UInt {
        return slot == .utility ? 1 : 0
    }

    func composerView(_ composerView: RCComposerView, heightForAddonAt slot: RCComposerAddonSlot, index: UInt) -> CGFloat {
        guard isComposerHinting else {
            return 0.0
        }

        return 50.0
    }

    func composerView(_ composerView: RCComposerView, addonAt slot: RCComposerAddonSlot, index: UInt) -> RCComposerAddon? {
        guard isComposerHinting else {
            return nil
        }

        switch slot {
        case .utility:
            return nil
        case .component:
            return .reply
        }
    }

    func composerView(_ composerView: RCComposerView, didUpdateAddonView view: UIView?, at slot: RCComposerAddonSlot, index: UInt) {
        switch slot {
        case .utility:
            view?.backgroundColor = .orange
        default:
            break
        }
    }
}
