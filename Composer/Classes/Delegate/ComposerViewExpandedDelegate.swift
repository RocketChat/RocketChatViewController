//
//  ComposerViewExpandedDelegate.swift
//  RocketChatViewController Example
//
//  Created by Matheus Cardoso on 9/12/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit

/**
 An expanded child of the ComposerViewDelegate protocol.
 This adds default implementatios for reply, autocompletion and more.
 */
public protocol ComposerViewExpandedDelegate: ComposerViewDelegate, HintsDelegate {
    func composerViewHintPrefixes(_ composerView: ComposerView) -> [Character]
    func composerViewIsHinting(_ composerView: ComposerView) -> Bool

    func composerView(_ composerView: ComposerView, didChangeHintPrefixedWord word: String)
}

public extension ComposerViewExpandedDelegate {
    func composerViewDidChangeSelection(_ composerView: ComposerView) {
        func didChangeHintPrefixedWord(_ word: String) {
            self.composerView(composerView, didChangeHintPrefixedWord: word)

            composerView.utilityStackView.subviews.forEach {
                ($0 as? HintsView)?.reloadData()
            }
        }

        let text: String = composerView.textView.text

        guard let range = Range(composerView.textView.selectedRange, in: text) else {
            didChangeHintPrefixedWord("")
            return
        }

        let wordRanges = Array(text.indices).filter {
            text[$0] != " " && ($0 == text.startIndex || text[text.index(before: $0)] == " ")
        }.map { index -> Range<String.Index> in
            if let spaceIndex = text[index...].firstIndex(of: " ") {
                return index..<spaceIndex
            }

            return index..<text.endIndex
        }

        let prefixes = composerViewHintPrefixes(composerView)

        if let wordRange = wordRanges.first(where: {
            if range.lowerBound == text.startIndex, let char = text[$0].first {
                if $0.lowerBound == text.startIndex {
                    return prefixes.contains(char)
                } else {
                    return false
                }
            }

            if range.lowerBound == $0.lowerBound, let char = text[$0].first {
                return prefixes.contains(char)
            }

            return $0.contains(text.index(before: range.lowerBound))
        }) {
            let word = String(text[wordRange])
            if let char = word.first, prefixes.contains(char) {
                didChangeHintPrefixedWord(word)
                return
            }
        }

        didChangeHintPrefixedWord("")
    }

    func numberOfAddons(in composerView: ComposerView, at slot: ComposerAddonSlot) -> UInt {
        return 1
    }

    func composerView(_ composerView: ComposerView, addonAt slot: ComposerAddonSlot, index: UInt) -> ComposerAddon? {
        switch slot {
        case .utility:
            return .hints
        case .component:
            return nil
        }
    }

    func composerViewIsReplying(_ composerView: ComposerView) -> Bool {
        return false
    }

    func composerView(_ composerView: ComposerView, didUpdateAddonView view: UIView?, at slot: ComposerAddonSlot, index: UInt) {
        if let view = view as? HintsView {
            view.hintsDelegate = self
        }

        if let view = view as? ReplyView {
            view.backgroundColor = .orange
        }
    }
}
