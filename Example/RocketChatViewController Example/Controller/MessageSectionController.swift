//
//  MessageSectionController.swift
//  RocketChatViewController Example
//
//  Created by Filipe Alvarenga on 05/08/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import Foundation
import DifferenceKit

struct MessageSection: SectionController, DifferentiableSection {
    init<C>(model: MessageSectionModel, elements: C) where C : Collection, C.Element == AnyDifferentiable {
        self.model = model
        self.elements = elements as? [AnyDifferentiable] ?? []
    }

    let model: MessageSectionModel
    var elements: [AnyDifferentiable]

    static func viewModels(for object: Any) -> [AnyDifferentiable] {
        guard let object = object as? MessageSectionModel else {
            return []
        }

        let basicMessageViewModel = BasicMessageViewModel(username: "test", text: object.message.text)

        return [AnyDifferentiable(basicMessageViewModel)]
    }

    func cell(for viewModel: Any, on collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel {
        case is BasicMessageViewModel:
            let basicMessageCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BasicMessageCollectionViewCell.identifier,
                for: indexPath
            )

            basicMessageCell.bind(viewModel: viewModel)
            return basicMessageCell
        default:
            break
        }

        return UICollectionViewCell()
    }

    func height(for viewModel: Any) -> CGFloat? {
        switch viewModel {
        case is BasicMessageViewModel:
            return 60
        default:
            return nil
        }
    }
}
