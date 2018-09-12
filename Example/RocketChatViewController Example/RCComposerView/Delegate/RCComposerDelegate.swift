//
//  RCComposerDelegate.swift
//  RocketChatViewController Example
//
//  Created by Matheus Cardoso on 9/12/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit

protocol RCComposerDelegate: class {
    /**
     Asks the delegate for the button to place in the slot.
     */
    func composerView(_ composerView: RCComposerView, buttonAt slot: RCComposerButtonSlot) -> RCComposerButton?

    /**
     Asks the delegate which height should be the maximum for the composer (not counting addons).
     */
    func maximumHeight(for composerView: RCComposerView) -> CGFloat

    /**
     Asks the how many addons to place in the composer.
     */
    func numberOfAddons(in composerView: RCComposerView, at slot: RCComposerAddonSlot) -> UInt

    /**
     Asks the delegate which addon to place in the addon index slot.
     */
    func composerView(_ composerView: RCComposerView, addonAt slot: RCComposerAddonSlot, index: UInt) -> RCComposerAddon?

    /**
     Asks the delegate which height should the addon view have.
     */
    func composerView(_ composerView: RCComposerView, heightForAddonAt slot: RCComposerAddonSlot, index: UInt) -> CGFloat

    /**
     Tells the delegate the current addon view has been updated or changed.
     */
    func composerView(_ composerView: RCComposerView, didUpdateAddonView view: UIView?, at slot: RCComposerAddonSlot, index: UInt)

    /**
     Tells the delegate the button in the slot has been tapped.
     */
    func composerView(_ composerView: RCComposerView, didTapButtonAt slot: RCComposerButtonSlot)
}

extension RCComposerDelegate {
    func composerView(_ composerView: RCComposerView, buttonAt slot: RCComposerButtonSlot) -> RCComposerButton? {
        switch slot {
        case .left:
            return .addButton
        case .right:
            return .sendButton
        }
    }

    func maximumHeight(for composerView: RCComposerView) -> CGFloat {
        return UIScreen.main.bounds.height/3.0
    }

    func numberOfAddons(in composerView: RCComposerView, at slot: RCComposerAddonSlot) -> UInt {
        return 0
    }

    func composerView(_ composerView: RCComposerView, addonAt slot: RCComposerAddonSlot, index: UInt) -> RCComposerAddon? {
        return nil
    }

    func composerView(_ composerView: RCComposerView, heightForAddonAt slot: RCComposerAddonSlot, index: UInt) -> CGFloat {
        return 50.0
    }

    func composerView(_ composerView: RCComposerView, didUpdateAddonView view: UIView?, at slot: RCComposerAddonSlot, index: UInt) { }
    func composerView(_ composerView: RCComposerView, didTapButtonAt slot: RCComposerButtonSlot) { }
}
