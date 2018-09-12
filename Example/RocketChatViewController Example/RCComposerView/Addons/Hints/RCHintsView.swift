//
//  RCHintsView.swift
//  RocketChatViewController Example
//
//  Created by Matheus Cardoso on 9/12/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit

protocol RCHintsDelegate {
    func numberOfHints(in hintsView: RCHintsView) -> Int
    func maximumHeight(for hintsView: RCHintsView) -> CGFloat
    func hintsView(_ hintsView: RCHintsView, cellForHintAt index: Int) -> UITableViewCell
    func title(for hintsView: RCHintsView) -> String?
}

extension RCHintsDelegate {
    func numberOfHints(in hintsView: RCHintsView) -> Int {
        return 1
    }

    func hintsView(_ hintsView: RCHintsView, cellForHintAt index: Int) -> UITableViewCell {
        return UITableViewCell()
    }

    func title(for hintsView: RCHintsView) -> String? {
        return "Suggestions"
    }

    func maximumHeight(for hintsView: RCHintsView) -> CGFloat {
        return 300
    }
}

class RCHintsFallbackDelegate: RCHintsDelegate {

}

class RCHintsView: UITableView {
    var hintsDelegate: RCHintsDelegate?
    var fallbackDelegate: RCHintsDelegate = RCHintsFallbackDelegate()

    var currentDelegate: RCHintsDelegate {
        return hintsDelegate ?? fallbackDelegate
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: contentSize.width, height: min(contentSize.height, currentDelegate.maximumHeight(for: self)))
    }

    init() {
        super.init(frame: .zero, style: .plain)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    /**
     Shared initialization procedures.
     */
    func commonInit() {
        dataSource = self
        backgroundColor = .blue

        addSubviews()
        setupConstraints()
    }

    /**
     Adds buttons and other UI elements as subviews.
     */
    private func addSubviews() {

    }

    /**
     Sets up constraints between the UI elements in the composer.
     */
    private func setupConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

        ])
    }
}

extension RCHintsView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDelegate.numberOfHints(in: self)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return currentDelegate.hintsView(self, cellForHintAt: indexPath.row)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return currentDelegate.title(for: self)
    }
}
