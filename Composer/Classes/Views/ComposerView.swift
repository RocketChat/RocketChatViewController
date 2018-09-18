//
//  ComposerView.swift
//  RocketChatViewController Example
//
//  Created by Matheus Cardoso on 9/5/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit
import NotificationCenter

/**
 An enum that represents a place in the composer view where a button is placed.
 */
public enum ComposerButtonSlot {
    case left
    case right
}

/**
 An enum that represents the state of a button in the composer.
 */
public enum ComposerButtonState {
    case normal
    case disabled
    case hidden
}

/**
 A struct that represents a button in the composer.
 */
public struct ComposerButton {
    var state: ComposerButtonState
    var image: ComposerAsset<UIImage>

    func withState(_ state: ComposerButtonState) -> ComposerButton {
        return tap(self) { $0.state = state }
    }
}

public extension ComposerButton {
    /**
     Default add sign button.
     */
    public static var addButton: ComposerButton {
        return ComposerButton(state: .normal, image: .addButton)
    }

    /**
     Default microphone button.
     */
    public static var micButton: ComposerButton {
        return ComposerButton(state: .normal, image: .micButton)
    }

    /**
     Default send button.
     */
    public static var sendButton: ComposerButton {
        return ComposerButton(state: .normal, image: .sendButton)
    }
}

/**
 An enum that represents a place in the composer view where an addon is placed.
 */
public enum ComposerAddonSlot {
    /**
     When the addon represents something in the message (eg. attached media)
     */
    case component

    /**
     When the addon represents a utility to the composer (eg. hint view)
     */
    case utility
}

/*
 A default composer view delegate with fallback behaviors.
 */
private class ComposerViewFallbackDelegate: ComposerViewDelegate { }

// MARK: Initializers
public class ComposerView: UIView {
    /**
     The object that acts as the delegate of the composer.
     */
    public weak var delegate: ComposerViewDelegate? {
        didSet {
            reloadAddons()
        }
    }

    /**
     A fallback delegate for when delegate is nil.
     */
    private var fallbackDelegate = ComposerViewFallbackDelegate()

    /**
     Returns the delegate if set, if not, returns the default delegate.

     Delegate should only be accessed inside this class via this computed property.
     */
    private var currentDelegate: ComposerViewDelegate {
        return delegate ?? fallbackDelegate
    }

    /**
     The button that stays in the left side of the composer.
     */
    public let leftButton = tap(UIButton()) {
        $0.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            $0.widthAnchor.constraint(equalToConstant: Consts.leftButtonWidth),
            $0.heightAnchor.constraint(equalToConstant: Consts.leftButtonHeight)
        ])

        $0.addTarget(self, action: #selector(touchUpInside(button:)), for: .touchUpInside)
    }

    /**
     The button that stays in the right side of the composer.
     */
    public let rightButton = tap(UIButton()) {
        $0.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            $0.widthAnchor.constraint(equalToConstant: Consts.rightButtonWidth),
            $0.heightAnchor.constraint(equalToConstant: Consts.rightButtonHeight)
        ])

        $0.addTarget(self, action: #selector(touchUpInside(button:)), for: .touchUpInside)
    }

    /**
     The text view used to compose the message.
     */
    public let textView = tap(ComposerTextView()) {
        $0.translatesAutoresizingMaskIntoConstraints = false

        $0.placeholderLabel.text = "Type a message"
        $0.placeholderLabel.font = .preferredFont(forTextStyle: .body)
        $0.placeholderLabel.adjustsFontForContentSizeCategory = true

        $0.font = .preferredFont(forTextStyle: .body)
        $0.adjustsFontForContentSizeCategory = true
    }

    /**
     The view that contains component addons on top of the text (eg. attached media)
     */
    public let componentStackView = tap(ComposerAddonStackView()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
    }

    /**
     The separator line on top of the composer
     */
    public let topSeparatorView = tap(UIView()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = #colorLiteral(red: 0.8823529412, green: 0.8980392157, blue: 0.9098039216, alpha: 1)

        NSLayoutConstraint.activate([
            $0.heightAnchor.constraint(equalToConstant: Consts.topSeparatorViewHeight)
        ])
    }

    /**
     The view that contains utility addons on top of the composer (eg. hint view)
     */
    public let utilityStackView = tap(ComposerAddonStackView()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    public override var intrinsicContentSize: CGSize {
        let composerHeight = textView.contentSize.height + Consts.textViewTop + Consts.textViewBottom
        let addonsHeight = componentStackView.frame.height + utilityStackView.frame.height
        let height = min(composerHeight, currentDelegate.maximumHeight(for: self)) + addonsHeight

        return CGSize(width: super.intrinsicContentSize.width, height: height)
    }

    public convenience init() {
        self.init(frame: .zero)
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
    public func commonInit() {
        textView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dynamicTextSizeDidChange),
            name: .UIContentSizeCategoryDidChange, object: nil
        )

        addSubviews()
        setupConstraints()
    }

    /**
     Adds buttons and other UI elements as subviews.
     */
    private func addSubviews() {
        addSubview(leftButton)
        addSubview(rightButton)
        addSubview(textView)
        addSubview(componentStackView)
        addSubview(topSeparatorView)
        addSubview(utilityStackView)
    }

    /**
     Sets up constraints between the UI elements in the composer.
     */
    private func setupConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            // utilityStackView constraints

            utilityStackView.topAnchor.constraint(equalTo: topAnchor),
            utilityStackView.widthAnchor.constraint(equalTo: widthAnchor),

            // topSeparatorView constraints

            topSeparatorView.topAnchor.constraint(equalTo: utilityStackView.bottomAnchor),
            topSeparatorView.widthAnchor.constraint(equalTo: widthAnchor),

            // componentStackView constraints

            componentStackView.widthAnchor.constraint(equalTo: widthAnchor),
            componentStackView.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor),

            // textView constraints

            tap(textView.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor)) {
                $0.constant = Consts.textViewLeading
            },
            tap(textView.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor)) {
                $0.constant = -Consts.textViewTrailing
            },
            tap(textView.topAnchor.constraint(equalTo: componentStackView.bottomAnchor)) {
                $0.constant = Consts.textViewTop
            },
            tap(textView.bottomAnchor.constraint(equalTo: bottomAnchor)) {
                $0.constant = -Consts.textViewBottom
            },

            // rightButton constraints

            tap(rightButton.trailingAnchor.constraint(equalTo: trailingAnchor)) {
                $0.constant = -Consts.rightButtonTrailing
            },
            tap(rightButton.bottomAnchor.constraint(equalTo: bottomAnchor)) {
                $0.constant = -Consts.rightButtonBottom
            },

            // leftButton constraints

            tap(leftButton.leadingAnchor.constraint(equalTo: leadingAnchor)) {
                $0.constant = Consts.leftButtonLeading
            },
            tap(leftButton.bottomAnchor.constraint(equalTo: bottomAnchor)) {
                $0.constant = -Consts.leftButtonBottom
            }
        ])
    }

    /**
     Update composer height
     */
    public func updateHeight() {
        invalidateIntrinsicContentSize()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        updateHeight()
    }

    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)

        leftButton.setBackgroundImage(currentDelegate.composerView(self, buttonAt: .left)?.image.raw, for: .normal)
        rightButton.setBackgroundImage(currentDelegate.composerView(self, buttonAt: .right)?.image.raw, for: .normal)

        reloadAddons()
    }
}

// MARK: Addons

public extension ComposerView {
    func reloadAddons() {
        [
            (componentStackView, ComposerAddonSlot.component),
            (utilityStackView, ComposerAddonSlot.utility)
        ].forEach { (stackView, slot) in
            stackView.subviews.forEach {
                stackView.removeArrangedSubview($0)
                $0.removeFromSuperview()
            }

            for index in 0..<currentDelegate.numberOfAddons(in: self, at: slot) {
                if let addon = currentDelegate.composerView(self, addonAt: slot, index: index) {
                    let addonView: UIView = addon.viewType.init()
                    addonView.frame = stackView.frame
                    stackView.addArrangedSubview(addonView)

                    currentDelegate.composerView(self, didUpdateAddonView: addonView, at: slot, index: index)
                } else {
                    currentDelegate.composerView(self, didUpdateAddonView: nil, at: slot, index: index)
                }
            }
        }
    }
}

// MARK: Observers & Actions

public extension ComposerView {
    /**
     Called when the content size of the text view changes and adjusts the composer height constraint.
     */
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
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
            currentDelegate.composerView(self, didTapButtonAt: .left)
        case rightButton:
            currentDelegate.composerView(self, didTapButtonAt: .right)
        default:
            break
        }
    }

    /**
     Called when the dynamic text size for the system changes
     */
    @objc func dynamicTextSizeDidChange() {
        /*textView.font = Fonts.textViewFont
        textView.placeholderLabel.font = Fonts.textViewPlaceholderFont

        textView.contentSize*/
    }
}

// MARK: Consts

private extension ComposerView {
    /**
     Constants for sizes and margins in the composer view.
     */
    private struct Consts {
        static var composerHeight: CGFloat = 54

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

    /**
     Dynamic Fonts in the composer view
     */
    private struct Fonts {
        static var textViewFont: UIFont {
            return .preferredFont(forTextStyle: .body)
        }

        static var textViewPlaceholderFont: UIFont {
            return .preferredFont(forTextStyle: .body)
        }
    }
}
