//
//  RCComposerView.swift
//  RocketChatViewController Example
//
//  Created by Matheus Cardoso on 9/5/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit

/**
 An enum that represents a place in the composer view where a button is placed.
 */
enum RCComposerButtonSlot {
    case leftSlot
    case rightSlot
}

/**
 An enum that represents the state of a button in the composer.
 */
enum RCComposerButtonState {
    case normal
    case disabled
    case hidden
}

/**
 A helper function that returns the object with a transformation applied.
 */
@discardableResult private func tap<Object>(_ object: Object, transform: (inout Object) throws -> Void) rethrows -> Object {
    var object = object
    try transform(&object)
    return object
}

/**
 A struct that represents a button in the composer.
 */
struct RCComposerButton {
    var state: RCComposerButtonState
    var image: RCComposerAsset<UIImage>

    func withState(_ state: RCComposerButtonState) -> RCComposerButton {
        return tap(self) { $0.state = state }
    }
}

extension RCComposerButton {
    /**
     Default add sign button.
     */
    static var addButton: RCComposerButton {
        return RCComposerButton(state: .normal, image: .addButton)
    }

    /**
     Default microphone button.
     */
    static var micButton: RCComposerButton {
        return RCComposerButton(state: .normal, image: .micButton)
    }

    /**
     Default send button.
     */
    static var sendButton: RCComposerButton {
        return RCComposerButton(state: .normal, image: .sendButton)
    }
}

protocol RCComposerDelegate: class {
    /**
     Asks the delegate for the button to place in the slot.
     */
    func composerView(_ composerView: RCComposerView, buttonForSlot slot: RCComposerButtonSlot) -> RCComposerButton?

    /**
     Asks the delegate which height should be the maximum for the composer.
     */
    func composerViewMaximumHeight(_ composerView: RCComposerView) -> CGFloat

    /**
     Asks the delegate which height should the addon view have.
     */
    func composerHeightForAddonView(_ composerView: RCComposerView) -> CGFloat

    /**
     Asks the delegate which addon to place in the addon slot.
     */
    func composerCurrentAddon(_ composerView: RCComposerView) -> RCComposerAddon?

    /**
     Tells the delegate the current addon view has been updated or changed.
     */
    func composer(_ composerView: RCComposerView, didUpdateCurrentAddonView view: UIView?)

    /**
     Tells the delegate the button in the slot has been tapped.
     */
    func composer(_ composerView: RCComposerView, didTapButtonInSlot slot: RCComposerButtonSlot)
}

extension RCComposerDelegate {
    func composerView(_ composerView: RCComposerView, buttonForSlot slot: RCComposerButtonSlot) -> RCComposerButton? {
        switch slot {
        case .leftSlot:
            return .addButton
        case .rightSlot:
            return .sendButton
        }
    }

    func composerViewMaximumHeight(_ composerView: RCComposerView) -> CGFloat {
        return UIScreen.main.bounds.height/3.0
    }

    func composerHeightForAddonView(_ composerView: RCComposerView) -> CGFloat {
        return 50.0
    }

    func composerCurrentAddon(_ composerView: RCComposerView) -> RCComposerAddon? {
        return nil
    }

    func composer(_ composerView: RCComposerView, didUpdateCurrentAddonView view: UIView?) { }
    func composer(_ composerView: RCComposerView, didTapButtonInSlot slot: RCComposerButtonSlot) { }
}

/*
 A default RCComposerDelegate delegate with default behaviors.
 */
private class RCDefaultComposerDelegate: RCComposerDelegate { }

// MARK: Initializers

class RCComposerView: UIView {
    /**
     The object that acts as the delegate of the composer.
     */
    weak var delegate: RCComposerDelegate?

    /**
     A default delegate for when delegate is nil.
     */
    private var defaultDelegate = RCDefaultComposerDelegate()

    /**
     Returns the delegate if set, if not, returns the default delegate.

     Delegate should only be accessed inside this class via this computed property.
     */
    private var currentDelegate: RCComposerDelegate {
        return delegate ?? defaultDelegate
    }

    /**
     The composer's height constraint.
     */
    lazy var heightConstraint: NSLayoutConstraint = {
        return heightAnchor.constraint(equalToConstant: Sizes.composerHeight)
    }()

    /**
     The button that stays in the left side of the composer.
     */
    let leftButton = tap(UIButton()) {
        $0.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            $0.widthAnchor.constraint(equalToConstant: Sizes.leftButtonWidth),
            $0.heightAnchor.constraint(equalToConstant: Sizes.leftButtonHeight)
        ])

        $0.addTarget(self, action: #selector(touchUpInside(button:)), for: .touchUpInside)
    }

    /**
     The button that stays in the right side of the composer.
     */
    let rightButton = tap(UIButton()) {
        $0.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            $0.widthAnchor.constraint(equalToConstant: Sizes.rightButtonWidth),
            $0.heightAnchor.constraint(equalToConstant: Sizes.rightButtonHeight)
        ])

        $0.addTarget(self, action: #selector(touchUpInside(button:)), for: .touchUpInside)
    }

    /**
     The text view used to compose the message.
     */
    let textView = tap(RCComposerTextView()) {
        $0.translatesAutoresizingMaskIntoConstraints = false

        $0.placeholderLabel.text = "Type a message"
        $0.font = UIFont.systemFont(ofSize: Sizes.fontSize)
    }

    /**
     The separator line on top of the composer
     */
    let topSeparatorView = tap(UIView()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = #colorLiteral(red: 0.8823529412, green: 0.8980392157, blue: 0.9098039216, alpha: 1)

        NSLayoutConstraint.activate([
            $0.heightAnchor.constraint(equalToConstant: Sizes.topSeparatorViewHeight)
        ])
    }

    // MARK: Addons

    /**
     The view that contains additional content on top of the composer
     */
    let addonContainerView = tap(UIView()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    /**
     The addon container view height constraint.
     */
    lazy var addonContainerHeightConstraint: NSLayoutConstraint = {
        let constraint = addonContainerView.heightAnchor.constraint(equalToConstant: 0)
        return constraint
    }()

    /**
     The cache for registered addon classes and instances
     */
    private var addonCache = [RCComposerAddon: UIView]()

    override init(frame: CGRect) {
        super.init(frame: frame)
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
        textView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

        addSubviews()
        setupConstraints()
    }

    /**
     Adds buttons and other UI elements as subviews.
     */
    private func addSubviews() {
        addSubview(addonContainerView)
        addSubview(topSeparatorView)
        addSubview(leftButton)
        addSubview(rightButton)
        addSubview(textView)
    }

    /**
     Sets up constraints between the UI elements in the composer.
     */
    private func setupConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            heightConstraint,

            // topSeparatorView constraints
            topSeparatorView.topAnchor.constraint(equalTo: topAnchor),
            topSeparatorView.widthAnchor.constraint(equalTo: widthAnchor),

            // addonContainerView constraints
            addonContainerHeightConstraint,
            addonContainerView.widthAnchor.constraint(equalTo: widthAnchor),
            addonContainerView.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor),

            // leftButton constraints

            tap(leftButton.leadingAnchor.constraint(equalTo: leadingAnchor)) {
                $0.constant = Sizes.leftButtonLeading
            },
            tap(leftButton.bottomAnchor.constraint(equalTo: bottomAnchor)) {
                $0.constant = -Sizes.leftButtonBottom
            },

            // textView constraints

            tap(textView.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor)) {
                $0.constant = Sizes.textViewLeading
            },
            tap(textView.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor)) {
                $0.constant = -Sizes.textViewTrailing
            },
            tap(textView.topAnchor.constraint(equalTo: addonContainerView.bottomAnchor)) {
                $0.constant = Sizes.textViewTop
            },
            tap(textView.bottomAnchor.constraint(equalTo: bottomAnchor)) {
                $0.constant = -Sizes.textViewBottom
            },

            // rightButton constraints

            tap(rightButton.trailingAnchor.constraint(equalTo: trailingAnchor)) {
                $0.constant = -Sizes.rightButtonTrailing
            },
            tap(rightButton.bottomAnchor.constraint(equalTo: bottomAnchor)) {
                $0.constant = -Sizes.rightButtonBottom
            }
        ])
    }

    /**
     Update composer height
     */
    func updateHeight() {
        let newHeight = textView.contentSize.height + Sizes.textViewTop + Sizes.textViewBottom
        UIView.animate(withDuration: 0.2, animations: {
            let addonContainerHeight = self.currentDelegate.composerHeightForAddonView(self)
            self.heightConstraint.constant = min(newHeight, self.currentDelegate.composerViewMaximumHeight(self)) + addonContainerHeight
            self.addonContainerHeightConstraint.constant = addonContainerHeight
        }, completion: { _ in
            self.textView.setContentOffset(.zero, animated: true)
        })
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateHeight()
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)

        leftButton.setBackgroundImage(currentDelegate.composerView(self, buttonForSlot: .leftSlot)?.image.raw, for: .normal)
        rightButton.setBackgroundImage(currentDelegate.composerView(self, buttonForSlot: .rightSlot)?.image.raw, for: .normal)

        if let addon = currentDelegate.composerCurrentAddon(self) {
            let addonView: UIView

            if let cachedAddonView = addonCache[addon] {
                addonView = cachedAddonView
            } else {
                addonView = addon.viewType.init()
                addonCache.updateValue(addonView, forKey: addon)
            }

            addonView.frame = addonContainerView.frame
            addonContainerView.addSubview(addonView)

            NSLayoutConstraint.activate([
                addonView.centerXAnchor.constraint(equalTo: addonContainerView.centerXAnchor),
                addonView.centerYAnchor.constraint(equalTo: addonContainerView.centerYAnchor),
                addonView.widthAnchor.constraint(equalTo: addonContainerView.widthAnchor),
                addonView.heightAnchor.constraint(equalTo: addonContainerView.heightAnchor)
            ])

            currentDelegate.composer(self, didUpdateCurrentAddonView: addonView)
        } else {
            currentDelegate.composer(self, didUpdateCurrentAddonView: nil)
        }
    }
}

// MARK: Observers & Actions

extension RCComposerView {
    /**
     Called when the content size of the text view changes and adjusts the composer height constraint.
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as AnyObject? === textView && keyPath == "contentSize" {
            updateHeight()
        }
    }

    /**
     Called when a touch up inside happens in one of the buttons.
     */
    @objc func touchUpInside(button: UIButton) {
        switch button {
        case leftButton:
            currentDelegate.composer(self, didTapButtonInSlot: .leftSlot)
        case rightButton:
            currentDelegate.composer(self, didTapButtonInSlot: .rightSlot)
        default:
            break
        }
    }
}

// MARK: Sizes

private extension RCComposerView {
    /**
     Constants for sizes and margins in the composer view.
     */
    private struct Sizes {
        static var composerHeight: CGFloat = 54
        static var fontSize: CGFloat = 17

        static var topSeparatorViewHeight: CGFloat = 0.5

        static var leftButtonWidth: CGFloat = 24
        static var leftButtonHeight: CGFloat = 24
        static var leftButtonLeading: CGFloat = 20
        static var leftButtonBottom: CGFloat = 16

        static var textViewLeading: CGFloat = 12
        static var textViewTrailing: CGFloat = 12
        static var textViewTop: CGFloat = 8
        static var textViewBottom: CGFloat = 8

        static var rightButtonWidth: CGFloat = 24
        static var rightButtonHeight: CGFloat = 24
        static var rightButtonTrailing: CGFloat = 20
        static var rightButtonBottom: CGFloat = 16
    }
}
