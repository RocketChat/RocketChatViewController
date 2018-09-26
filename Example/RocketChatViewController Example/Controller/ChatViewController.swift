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
    var hintPrefixedWord: String = ""
    var isReplying: Bool = false

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
        return !hintPrefixedWord.isEmpty
    }

    func numberOfHints(in hintsView: HintsView) -> Int {
        return hintPrefixedWord.count
    }

    // MARK: Reply

    func replyViewModel(for composerView: ComposerView) -> ReplyViewModel? {
        return isReplying ? ReplyViewModel(
            nameText: "jaad.brinklei",
            timeText: "2:10 PM",
            text: "This is a multiline chat message from..."
        ) : nil
    }

    func replyViewDidHide(_ replyView: ReplyView) {
        isReplying = false
    }

    func replyViewDidShow(_ replyView: ReplyView) {
        isReplying = true
    }

    func hintsView(_ hintsView: HintsView, cellForHintAt index: Int) -> UITableViewCell {
        let cell: UserHintCell

        if let userCell = hintsView.dequeueReusableCell(withIdentifier: "cell") as? UserHintCell {
            cell = userCell
        } else {
            hintsView.register(UserHintCell.self, forCellReuseIdentifier: "cell")
            cell = hintsView.dequeueReusableCell(withIdentifier: "cell") as? UserHintCell ?? UserHintCell()
        }

        cell.avatarView.backgroundColor = .black
        cell.nameLabel.text = "Karem Flusser"
        cell.usernameLabel.text = "@karem.flusser"

        return cell
    }
}
