//
//  ComposerAssets.swift
//  RocketChatViewController Example
//
//  Created by Matheus Cardoso on 9/5/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit

private var bundle = Bundle(for: ComposerView.self)
private var addButtonImage = ComposerAsset(UIImage(named: "addButton", in: bundle, compatibleWith: nil)!)
private var sendButtonImage = ComposerAsset(UIImage(named: "sendButton", in: bundle, compatibleWith: nil)!)
private var micButtonImage = ComposerAsset(UIImage(named: "micButton", in: bundle, compatibleWith: nil)!)

public struct ComposerAsset<T> {
    let raw: T
    init(_ raw: T) {
        self.raw = raw
    }
}

public extension ComposerAsset where T == UIImage {
    public static var addButton: ComposerAsset<T> {
        return addButtonImage
    }

    public static var sendButton: ComposerAsset<T> {
        return sendButtonImage
    }

    public static var micButton: ComposerAsset<T> {
        return micButtonImage
    }
}
