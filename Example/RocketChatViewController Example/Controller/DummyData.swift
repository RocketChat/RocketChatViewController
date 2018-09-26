//
//  DummyData.swift
//  RocketChatViewController Example
//
//  Created by Matheus Cardoso on 9/26/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import Foundation
import UIKit

struct DummyData {
    static var commands: [String] = [
        "gimme",
        "giphy",
        "invite"
    ]

    static var rooms: [String] = [
        "important",
        "ios",
        "ios-design",
        "mobile-internal",
        "general",
        "support"
    ]

    static var users: [(name: String, username: String)] = [
        ("Matheus Cardoso", "matheus.cardoso"),
        ("Rafael Kellermann", "rafael.kellermann"),
        ("Filipe Alvarenga", "filipe.alvarenga"),
        ("Thiago Sanchez", "thiago.sanchez"),
        ("Gabriel Engel", "gabriel.engel"),
        ("Marcelo Schmidt", "marcelo.schmidt"),
        ("Bruno Quadros", "bruno.quadros"),
        ("Rafael Specht", "rafael.specht"),
        ("Rodrigo Nascimento", "rodrigo.nascimento"),
        ("Aaron Ogle", "aaron.ogle"),
        ("Sing Li", "sing.li")
    ]

    static func avatarImage(for username: String) -> UIImage {
        return UIImage(named: username) ?? UIImage(named: "no_avatar")!
    }
}
