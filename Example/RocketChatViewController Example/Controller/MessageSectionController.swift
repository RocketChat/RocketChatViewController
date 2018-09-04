//
//  MessageSectionController.swift
//  RocketChatViewController Example
//
//  Created by Filipe Alvarenga on 05/08/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import Foundation
import DifferenceKit

struct MessageSectionController: SectionController {
    var object: AnyDifferentiable

    // MARK: Section Controller

    func viewModels() -> [AnyChatCellViewModel] {
        guard let object = object.base as? MessageSectionModel else {
            return []
        }

        var viewModels: [AnyChatCellViewModel] = []

        let basicMessageViewModel = BasicMessageViewModel(
            username: "test",
            text: object.message.text
        ).wrapped

        viewModels.append(basicMessageViewModel)

        for attachment in object.message.attachments {
            switch attachment.type {
            case 0:
                let imageAttachment = ImageAttachmentViewModel(url: attachment.url)
                viewModels.append(imageAttachment.wrapped)
            case 1:
                let videoAttachment = VideoAttachmentViewModel(url: attachment.url)
                viewModels.append(videoAttachment.wrapped)
            case 2:
                let audioAttachment = AudioAttachmentViewModel(url: attachment.url)
                viewModels.append(audioAttachment.wrapped)
            default:
                break
            }
        }

        return viewModels
    }

    func cell(for viewModel: AnyChatCellViewModel, on collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.relatedReuseIdentifier, for: indexPath)
        cell.bind(viewModel: viewModel.base)
        return cell
    }

    func height(for viewModel: AnyChatCellViewModel) -> CGFloat? {
        return viewModel.heightForCurrentState()
    }
}
