//
//  MessageSectionController.swift
//  RocketChatViewController Example
//
//  Created by Filipe Alvarenga on 05/08/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import Foundation
import DifferenceKit
import RocketChatViewController

struct MessageChatSection: ChatSection {
    var object: AnyDifferentiable

    // MARK: Section Controller

    func viewModels() -> [AnyChatItem] {
        guard let object = object.base as? MessageSectionModel else {
            return []
        }

        var viewModels: [AnyChatItem] = []

        let basicMessageViewModel = BasicMessageChatItem(
            username: "test",
            text: object.message.text
        ).wrapped

        viewModels.append(basicMessageViewModel)

//        for attachment in object.message.attachments {
//            switch attachment.type {
//            case 0:
//                let imageAttachment = ImageAttachmentChatItem(url: attachment.url)
//                viewModels.append(imageAttachment.wrapped)
//            case 1:
//                let videoAttachment = VideoAttachmentChatItem(url: attachment.url)
//                viewModels.append(videoAttachment.wrapped)
//            case 2:
//                let audioAttachment = AudioAttachmentChatItem(url: attachment.url)
//                viewModels.append(audioAttachment.wrapped)
//            default:
//                break
//            }
//        }

        return viewModels
    }

    func cell(for viewModel: AnyChatItem, on collectionView: UICollectionView, at indexPath: IndexPath) -> ChatCell {
        let cell = collectionView.dequeueChatCell(withReuseIdentifier: viewModel.relatedReuseIdentifier, for: indexPath)
        cell.bind(viewModel: viewModel)
        return cell
    }
}
