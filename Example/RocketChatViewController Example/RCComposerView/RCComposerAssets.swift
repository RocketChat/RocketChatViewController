//
//  RCComposerAssets.swift
//  RocketChatViewController Example
//
//  Created by Matheus Cardoso on 9/5/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit

private var addButtonImage = RCComposerAsset(#imageLiteral(resourceName: "addButton"))
private var sendButtonImage = RCComposerAsset(#imageLiteral(resourceName: "sendButton"))
private var micButtonImage = RCComposerAsset(#imageLiteral(resourceName: "micButton"))

struct RCComposerAsset<T> {
    let raw: T
    init(_ raw: T) {
        self.raw = raw
    }
}

extension RCComposerAsset where T == UIImage {
    static var addButton: RCComposerAsset<T> {
        return addButtonImage
    }

    static var sendButton: RCComposerAsset<T> {
        return sendButtonImage
    }

    static var micButton: RCComposerAsset<T> {
        return micButtonImage
    }
}
