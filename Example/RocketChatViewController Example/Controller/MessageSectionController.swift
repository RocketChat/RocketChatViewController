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

    var differenceIdentifier: AnyHashable {
        return AnyHashable(model.differenceIdentifier)
    }

    func isContentEqual(to source: MessageSectionController) -> Bool {
        guard
            let model = model.base as? MessageSectionModel,
            let sourceModel = source.model.base as? MessageSectionModel
        else {
            return false
        }

        return model.isContentEqual(to: sourceModel)
    }

    // MARK: Section Controller

    func viewModels() -> [AnyChatViewModel] {
        guard let model = model.base as? MessageSectionModel else {
            return []
        }

        let basicMessageViewModel = BasicMessageViewModel(username: "test", text: model.message.text).anyChatViewModel

        return [basicMessageViewModel]
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
