//
//  ChatViewController.swift
//  RocketChatViewController Example
//
//  Created by Filipe Alvarenga on 22/08/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit
import DifferenceKit

final class ChatViewController: RocketChatViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(
            UINib(
                nibName: BasicMessageCollectionViewCell.identifier, bundle: nil
            ),
            forCellWithReuseIdentifier: BasicMessageCollectionViewCell.identifier
        )

        collectionView.register(
            UINib(
                nibName: ImageAttachmentCollectionViewCell.identifier, bundle: nil
            ),
            forCellWithReuseIdentifier: ImageAttachmentCollectionViewCell.identifier
        )

        collectionView.register(
            UINib(
                nibName: VideoAttachmentCollectionViewCell.identifier, bundle: nil
            ),
            forCellWithReuseIdentifier: VideoAttachmentCollectionViewCell.identifier
        )

        collectionView.register(
            UINib(
                nibName: AudioAttachmentCollectionViewCell.identifier, bundle: nil
            ),
            forCellWithReuseIdentifier: AudioAttachmentCollectionViewCell.identifier
        )

        data = DataControllerPlaceholder.generateDumbData(elements: 10)
        updateData()
        data = []
        updateData()
        data = DataControllerPlaceholder.generateDumbData(elements: 5000)
        updateData()
    }
}

extension ChatViewController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionController = data[indexPath.section].base
        let viewModel = sectionController.viewModels()[indexPath.row]
        switch viewModel.base {
        case is BasicMessageViewModel:
            return CGSize(width: UIScreen.main.bounds.width, height: 60)
        case is ImageAttachmentViewModel:
            return CGSize(width: UIScreen.main.bounds.width, height: 202)
        case is VideoAttachmentViewModel:
            return CGSize(width: UIScreen.main.bounds.width, height: 222)
        case is AudioAttachmentViewModel:
            return CGSize(width: UIScreen.main.bounds.width, height: 44)
        default:
            return .zero
        }
    }
}
