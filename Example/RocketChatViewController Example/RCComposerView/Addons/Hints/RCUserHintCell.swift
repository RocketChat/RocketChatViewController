//
//  RCHintsViewCell.swift
//  RocketChatViewController Example
//
//  Created by Matheus Cardoso on 9/12/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit

class RCUserHintCell: UITableViewCell {
    /*
     The user's avatar image view
     */
    let avatarView: UIImageView = tap(UIImageView()) {
        $0.translatesAutoresizingMaskIntoConstraints = false

        $0.layer.cornerRadius = Consts.avatarCornerRadius

        NSLayoutConstraint.activate([
            $0.widthAnchor.constraint(equalToConstant: Consts.avatarWidth),
            $0.heightAnchor.constraint(equalToConstant: Consts.avatarHeight)
        ])
    }

    /*
     The user's name label
     */
    let nameLabel: UILabel = tap(UILabel()) {
        $0.translatesAutoresizingMaskIntoConstraints = false

        $0.font = Consts.nameFont
    }

    /*
     The user's username label
     */
    let usernameLabel: UILabel = tap(UILabel()) {
        $0.translatesAutoresizingMaskIntoConstraints = false

        $0.font = Consts.usernameFont
        $0.textColor = Consts.usernameColor
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width, height: Consts.intrinsicHeight)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    /**
     Shared initialization procedures.
     */
    func commonInit() {
        addSubviews()
        setupConstraints()
    }

    /**
     Adds buttons and other UI elements as subviews.
     */
    private func addSubviews() {
        addSubview(avatarView)
        addSubview(nameLabel)
        addSubview(usernameLabel)
    }

    /**
     Sets up constraints between the UI elements in the composer.
     */
    private func setupConstraints() {
        NSLayoutConstraint.activate([

            // avatarView

            tap(avatarView.leadingAnchor.constraint(equalTo: leadingAnchor)) { $0.constant = Consts.avatarLeading },
            avatarView.centerYAnchor.constraint(equalTo: centerYAnchor),

            // nameLabel
            
            tap(nameLabel.leadingAnchor.constraint(equalTo: avatarView.leadingAnchor)) { $0.constant = Consts.nameLeading },
            tap(nameLabel.bottomAnchor.constraint(equalTo: centerYAnchor)) { $0.constant = Consts.nameBottom },

            // usernameLabel

            tap(usernameLabel.leadingAnchor.constraint(equalTo: avatarView.leadingAnchor)) { $0.constant = Consts.nameLeading },
            tap(usernameLabel.topAnchor.constraint(equalTo: centerYAnchor)) { $0.constant = Consts.usernameTop }
        ])
    }
}

// MARK: Consts

private extension RCUserHintCell {
    /**
     Constants for sizes and margins in the cell view.
     */
    private struct Consts {
        static var intrinsicHeight: CGFloat = 54

        static var avatarWidth: CGFloat = 30
        static var avatarHeight: CGFloat = 30
        static var avatarLeading: CGFloat = 15
        static var avatarCornerRadius: CGFloat = 4

        static var nameLeading: CGFloat = 15
        static var nameBottom: CGFloat = -4
        static var nameFont: UIFont = .systemFont(ofSize: 18.0)

        static var usernameLeading: CGFloat = 15
        static var usernameTop: CGFloat = 4
        static var usernameFont: UIFont = .systemFont(ofSize: 14.0)
        static var usernameColor: UIColor = #colorLiteral(red: 0.6196078431, green: 0.6352941176, blue: 0.6588235294, alpha: 1)
    }
}
