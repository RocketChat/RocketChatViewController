//
//  ChatViewController.swift
//  RocketChatViewController Example
//
//  Created by Filipe Alvarenga on 22/08/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit
import DifferenceKit
import RocketChatViewController


final class ChatViewController: RocketChatViewController {
    var isReplying: Bool = false

    var hintPrefixedWord: String = "" {
        didSet {
            let withoutPrefix = String(hintPrefixedWord.dropFirst()).lowercased()

            switch hintPrefixedWord.first {
            case "/":
                hints = withoutPrefix.isEmpty ? DummyData.commands : DummyData.commands.filter { $0.contains(withoutPrefix) }
            case "@":
                hints = withoutPrefix.isEmpty ? DummyData.users.map { $0.username } : DummyData.users.filter { $0.username.contains(withoutPrefix) }.map { $0.username }
            case "#":
                hints = withoutPrefix.isEmpty ? DummyData.rooms : DummyData.rooms.filter { $0.contains(withoutPrefix) }
            default:
                hints = []
            }
        }
    }

    var hints: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        composerView.delegate = self

        collectionView?.register(
            UINib(
                nibName: BasicMessageChatCell.identifier, bundle: nil
            ),
            forCellWithReuseIdentifier: BasicMessageChatCell.identifier
        )

        collectionView?.register(
            UINib(
                nibName: ImageAttachmentChatCell.identifier, bundle: nil
            ),
            forCellWithReuseIdentifier: ImageAttachmentChatCell.identifier
        )

        collectionView?.register(
            UINib(
                nibName: VideoAttachmentChatCell.identifier, bundle: nil
            ),
            forCellWithReuseIdentifier: VideoAttachmentChatCell.identifier
        )

        collectionView?.register(
            UINib(
                nibName: AudioAttachmentChatCell.identifier, bundle: nil
            ),
            forCellWithReuseIdentifier: AudioAttachmentChatCell.identifier
        )

        data = DataControllerPlaceholder.generateDumbData(elements: 5)
        updateData()
        data = DataControllerPlaceholder.generateDumbData(elements: 1)
        updateData()
        data = DataControllerPlaceholder.generateDumbData(elements: 30)
        updateData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let first = data.first {
            if var messageSectionModel = first.base.object.base as? MessageSectionModel {
                messageSectionModel.message.text = "TEST TEST TEST"
                data.remove(at: 0)
                let chatSection = MessageChatSection(object: AnyDifferentiable(messageSectionModel))
                data.insert(AnyChatSection(chatSection), at: 0)
                updateData()
            }
        }

    }
}

extension ChatViewController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionController = data[indexPath.section].base
        let viewModel = sectionController.viewModels()[indexPath.row]
        switch viewModel.base {
        case is BasicMessageChatItem:
            return CGSize(width: UIScreen.main.bounds.width, height: 60)
        case is ImageAttachmentChatItem:
            return CGSize(width: UIScreen.main.bounds.width, height: 202)
        case is VideoAttachmentChatItem:
            return CGSize(width: UIScreen.main.bounds.width, height: 222)
        case is AudioAttachmentChatItem:
            return CGSize(width: UIScreen.main.bounds.width, height: 44)
        default:
            return .zero
        }
    }
}

// MARK: Composer Delegate
extension ChatViewController: ComposerViewExpandedDelegate {
    // MARK: Hint

    func hintPrefixes(for composerView: ComposerView) -> [Character] {
        return ["/", "@", "#"]
    }

    func composerView(_ composerView: ComposerView, didChangeHintPrefixedWord word: String) {
        hintPrefixedWord = word
    }

    func isHinting(in composerView: ComposerView) -> Bool {
        return !hints.isEmpty
    }

    func numberOfHints(in hintsView: HintsView) -> Int {
        return hints.count
    }

    // MARK: Reply

    func viewModel(for replyView: ReplyView) -> ReplyViewModel {
        return ReplyViewModel(
            nameText: "jaad.brinklei",
            timeText: "2:10 PM",
            text: "This is a multiline chat message from..."
        )
    }

    func replyViewDidHide(_ replyView: ReplyView) {
        isReplying = false
    }

    func replyViewDidShow(_ replyView: ReplyView) {
        isReplying = true
    }

    func hintsView(_ hintsView: HintsView, cellForHintAt index: Int) -> UITableViewCell {
        let hint = hints[index]

        if hintPrefixedWord.first == "@", let cell = hintsView.dequeueReusableCell(withType: UserHintCell.self) {
            cell.avatarView.image = DummyData.avatarImage(for: hint)
            cell.usernameLabel.text = hint
            cell.nameLabel.text = DummyData.users.first { $0.username == hint }?.name
            return cell
        }

        let cell = hintsView.dequeueReusableCell(withType: TextHintCell.self)
        cell?.prefixLabel.text = String(hintPrefixedWord.first ?? " ")
        cell?.valueLabel.text = String(hint)
        return cell ?? UITableViewCell()
    }
}
