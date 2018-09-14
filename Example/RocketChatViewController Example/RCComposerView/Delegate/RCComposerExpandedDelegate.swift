//
//  RCComposerExpandedDelegate.swift
//  RocketChatViewController Example
//
//  Created by Matheus Cardoso on 9/12/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit

/**
 An expanded child of the RCComposerDelegate protocol.
 This adds default implementatios for reply, autocompletion and more.
 */
protocol RCComposerExpandedDelegate: RCComposerDelegate, RCHintsDelegate {
    var isComposerReplying: Bool { get }
    var isComposerHinting: Bool { get }
}

extension RCComposerExpandedDelegate {
    func numberOfAddons(in composerView: RCComposerView, at slot: RCComposerAddonSlot) -> UInt {
        return 1
    }

    func composerView(_ composerView: RCComposerView, addonAt slot: RCComposerAddonSlot, index: UInt) -> RCComposerAddon? {
        switch slot {
        case .utility:
            return isComposerHinting ? .hints : nil
        case .component:
            return isComposerReplying ? .reply : nil
        }
    }

    func composerView(_ composerView: RCComposerView, didUpdateAddonView view: UIView?, at slot: RCComposerAddonSlot, index: UInt) {
        if let view = view as? RCHintsView {
            view.hintsDelegate = self
        }

        if let view = view as? RCReplyView {
            view.backgroundColor = .orange
        }
    }
}
