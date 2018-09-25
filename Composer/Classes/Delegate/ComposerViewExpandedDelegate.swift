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
    func composerView(_ composerView: ComposerView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        func didChangeHintPrefixedWord(_ word: String) {
            self.composerView(composerView, didChangeHintPrefixedWord: word)

            composerView.utilityStackView.subviews.forEach {
                ($0 as? HintsView)?.reloadData()
            }

            composerView.updateHeight()
        }

        guard let range = Range(range, in: composerView.textView.text) else {
            didChangeHintPrefixedWord("")
            return true
        }

        guard !text.trimmingCharacters(in: [" "]).isEmpty || composerView.textView.text[range].count > 0 else {
            didChangeHintPrefixedWord("")
            return true
        }
        
        let textView: ComposerTextView = composerView.textView
        let textViewText: String = textView.text
        let newText: String = textViewText.replacingCharacters(in: range, with: text)

        let wordRanges = Array(newText.indices).filter {
            newText[$0] != " " && ($0 == newText.startIndex || newText[newText.index(before: $0)] == " ")
        }.map { index -> Range<String.Index> in
            if let spaceIndex = newText[index...].firstIndex(of: " ") {
                return index..<spaceIndex
            }

            return index..<newText.endIndex
        }

        let prefixes = composerViewHintPrefixes(composerView)

        if let wordRange = wordRanges.first(where: {
            if range.lowerBound == newText.startIndex, let char = newText[$0].first {
                return prefixes.contains(char)
            }

            if range.lowerBound == $0.lowerBound, let char = newText[$0].first {
                return prefixes.contains(char)
            }

            return $0.contains(newText.index(before: range.lowerBound))
        }) {
            let word = String(newText[wordRange])
            if let char = word.first, prefixes.contains(char) {
                didChangeHintPrefixedWord(word)
                return true
            }
        }

        didChangeHintPrefixedWord("")

        return true
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

    func textChanged(in composerView: ComposerView) {
        if let lastComponent = composerView.textView.text.components(separatedBy: " ").last,
            let firstCharacter = lastComponent.first,
            composerViewHintPrefixes(composerView).contains(firstCharacter) {

            //composerView(composerView, didChangeHintPrefixedText: lastComponent)
        }
    }
}
