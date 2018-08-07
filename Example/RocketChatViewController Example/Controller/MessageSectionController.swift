//
//  MessageSectionController.swift
//  RocketChatViewController Example
//
//  Created by Filipe Alvarenga on 05/08/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import Foundation
import DifferenceKit

struct MessageSectionController: SectionController, Differentiable {
    var model: AnyDifferentiable

    // MARK: Differentiable

    var differenceIdentifier: String {
        return (model.base as? MessageSectionModel)?.identifier ?? ""
    }

    func isUpdated(from source: MessageSectionController) -> Bool {
        return (model.base as? MessageSectionModel)?.message.text != (source.model.base as? MessageSectionModel)?.message.text
    }

    // MARK: Section Controller

    func viewModels() -> [AnyChatViewModel] {
        guard let model = model.base as? MessageSectionModel else {
            return []
        }

        let basicMessageViewModel = BasicMessageViewModel(username: "test", text: model.message.text)
        return [basicMessageViewModel].map { AnyChatViewModel($0) }
    }

    func cell(for viewModel: AnyChatViewModel, on collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.relatedReuseIdentifier, for: indexPath)
        cell.bind(viewModel: viewModel.base)
        return cell
    }

    func height(for viewModel: AnyChatViewModel) -> CGFloat? {
        switch viewModel.base {
        case is BasicMessageViewModel:
            return 60
        default:
            return nil
        }
    }
}
