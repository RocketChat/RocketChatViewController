//
//  MessageSectionController.swift
//  RocketChatViewController Example
//
//  Created by Filipe Alvarenga on 05/08/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import Foundation
import IGListKit

struct MessageSectionController: SectionController {
    let object: ListDiffable?

    func viewModels() -> [Any] {
        guard let object = object as? MessageSectionModel else {
            return []
        }

        let basicMessageViewModel = BasicMessageViewModel(username: "test", text: object.message.text)

        return [basicMessageViewModel]
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
