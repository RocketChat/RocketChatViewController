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
        guard let model = object.base as? MessageSectionModel else {
            return []
        }

        let basicMessageViewModel = BasicMessageViewModel(username: "test", text: model.message.text).wrapped

        return [basicMessageViewModel]
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
