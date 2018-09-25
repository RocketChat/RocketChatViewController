//
//  ReplyView.swift
//  RocketChatViewController Example
//
//  Created by Matheus Cardoso on 9/6/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit

public class ReplyView: UIView {

    let backgroundView = tap(UIView()) {
        $0.translatesAutoresizingMaskIntoConstraints = false

        $0.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9568627451, blue: 0.9607843137, alpha: 1)
        $0.layer.cornerRadius = 4.0
    }

    let nameLabel = tap(UILabel()) {
        $0.translatesAutoresizingMaskIntoConstraints = false

        $0.text = "jaad.brinkley"
        $0.textColor = #colorLiteral(red: 0.1137254902, green: 0.4549019608, blue: 0.9607843137, alpha: 1)
        $0.font = .preferredFont(forTextStyle: .title3)
        $0.adjustsFontForContentSizeCategory = true
    }

    let timeLabel = tap(UILabel()) {
        $0.translatesAutoresizingMaskIntoConstraints = false

        $0.text = "2:10 PM"
        $0.textColor = #colorLiteral(red: 0.6196078431, green: 0.6352941176, blue: 0.6588235294, alpha: 1)
        $0.font = .preferredFont(forTextStyle: .footnote)
        $0.adjustsFontForContentSizeCategory = true
    }

    let textLabel = tap(UILabel()) {
        $0.translatesAutoresizingMaskIntoConstraints = false

        $0.text = "This is a multiline chat message from..."
        $0.font = .preferredFont(forTextStyle: .body)
        $0.adjustsFontForContentSizeCategory = true
    }

    let closeButton = tap(UIButton()) {
        $0.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            $0.widthAnchor.constraint(equalToConstant: 20),
            $0.heightAnchor.constraint(equalToConstant: 20)
        ])

        $0.setBackgroundImage(ComposerAsset.cancelReplyButton.raw, for: .normal)
        $0.tintColor = #colorLiteral(red: 0.6196078431, green: 0.6352941176, blue: 0.6588235294, alpha: 1)
    }

    public override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width,
                      height: 10 +
                        nameLabel.intrinsicContentSize.height +
                        textLabel.intrinsicContentSize.height + 3 + 15 + 13
        )
    }

    public init() {
        super.init(frame: .zero)
        self.commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    /**
     Shared initialization procedures.
     */
    private func commonInit() {
        addSubviews()
        setupConstraints()
    }

    /**
     Adds buttons and other UI elements as subviews.
     */
    private func addSubviews() {
        addSubview(backgroundView)

        backgroundView.addSubview(nameLabel)
        backgroundView.addSubview(timeLabel)
        backgroundView.addSubview(textLabel)

        addSubview(closeButton)
    }

    /**
     Sets up constraints between the UI elements in the composer.
     */
    private func setupConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            backgroundView.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -10),
            backgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),

            nameLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 15),
            nameLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 13),

            timeLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
            timeLabel.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),

            textLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10),
            textLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
            textLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: 10),

            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 15)
        ])
    }
}
