//
//  NisumNetworkAlert.swift
//  GS-CodingChallenge
//
//  Created by Manish on 25/03/22.
//

import Foundation
import UIKit

/// enum type that defines the Alert states
private enum AlertState {
    case showing, hidden, gone
}

/// Alert is a dropdown notification view that presents above the main view controller
class GSNetworkAlert: UIView {
    @objc class func topWindow() -> UIWindow? {
        for window in UIApplication.shared.windows.reversed() {
            if window.windowLevel == UIWindow.Level.normal && window.isKeyWindow && window.frame != CGRect.zero { return window }
        }
        return nil
    }
    
    private let contentView = UIView()
    private let labelView = UIView()
    private let backgroundView = UIView()
    
    @objc open var animationDuration: TimeInterval = 0.4
    
    /// The height of the alert.
    @objc open var minimumHeight: CGFloat = 80
    
    override open var backgroundColor: UIColor? {
        get { return backgroundView.backgroundColor }
        set { backgroundView.backgroundColor = newValue }
    }
    
    override open var alpha: CGFloat {
        get { return backgroundView.alpha }
        set { backgroundView.alpha = newValue }
    }
    
    /// A block to call when the uer taps on the alert.
    @objc open var didTapBlock: (() -> ())?
    
    /// A block to call after the alert has finished dismissing and is off screen.
    @objc open var didDismissBlock: (() -> ())?
    
    /// Whether or not the alert should dismiss itself when the user taps. Defaults to `true`.
    @objc open var dismissesOnTap = true
    
    /// Whether or not the alert should dismiss itself when the user swipes up. Defaults to `true`.
    @objc open var dismissesOnSwipe = true
    
    /// The label that displays the alert's title.
    @objc public let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// The label that displays the alert's subtitle.
    @objc public let detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// The image on the left of the alert.
    @objc let image: UIImage?
    
    /// The image view that displays the `image`.
    @objc public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var alertState = AlertState.hidden {
        didSet {
            if alertState != oldValue {
                forceUpdates()
            }
        }
    }
    
    /// A Alert with the provided `title`, `subtitle`, and optional `image`.
    @objc public required init(title: String? = nil, subtitle: String? = nil, image: UIImage? = nil, didTapBlock: (() -> ())? = nil) {
        self.didTapBlock = didTapBlock
        self.image = image
        super.init(frame: CGRect.zero)
        addGestureRecognizers()
        initializeSubviews()
        imageView.image = image
        titleLabel.text = title
        titleLabel.textColor = UIColor.white
        detailLabel.text = subtitle
        detailLabel.textColor = UIColor.white
        backgroundView.backgroundColor = UIColor.red
        backgroundView.alpha = 0.95
    }
    
    private func forceUpdates() {
        guard let superview = superview, let showingConstraint = showingConstraint, let hiddenConstraint = hiddenConstraint else { return }
        switch alertState {
        case .hidden:
            superview.removeConstraint(showingConstraint)
            superview.addConstraint(hiddenConstraint)
        case .showing:
            superview.removeConstraint(hiddenConstraint)
            superview.addConstraint(showingConstraint)
        case .gone:
            superview.removeConstraint(hiddenConstraint)
            superview.removeConstraint(showingConstraint)
            superview.removeConstraints(commonConstraints)
        }
        setNeedsLayout()
        setNeedsUpdateConstraints()
        if #available(iOS 10.0, *) {
            superview.layoutIfNeeded()
        } else {
            layoutIfNeeded()
        }
        updateConstraintsIfNeeded()
    }
    
    @objc internal func didTap(_ recognizer: UITapGestureRecognizer) {
        if dismissesOnTap {
            dismiss()
        }
        didTapBlock?()
    }
    
    @objc internal func didSwipe(_ recognizer: UISwipeGestureRecognizer) {
        if dismissesOnSwipe {
            dismiss()
        }
    }
    
    private func addGestureRecognizers() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(GSNetworkAlert.didTap(_:))))
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(GSNetworkAlert.didSwipe(_:)))
        swipe.direction = .up
        addGestureRecognizer(swipe)
    }
    
    private var contentTopOffsetConstraint: NSLayoutConstraint!
    private var contentBottomOffsetConstraint: NSLayoutConstraint!
    private var minimumHeightConstraint: NSLayoutConstraint!
    
    private func initializeSubviews() {
        let views = [
            "backgroundView": backgroundView,
            "contentView": contentView,
            "imageView": imageView,
            "labelView": labelView,
            "titleLabel": titleLabel,
            "detailLabel": detailLabel
        ]
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        minimumHeightConstraint = backgroundView.constraintWithAttribute(.height, .greaterThanOrEqual, to: minimumHeight)
        addConstraint(minimumHeightConstraint) // Arbitrary, but looks nice.
        addConstraints(backgroundView.constraintsEqualToSuperview())
        backgroundView.backgroundColor = backgroundColor
        backgroundView.addSubview(contentView)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelView)
        labelView.addSubview(titleLabel)
        labelView.addSubview(detailLabel)
        backgroundView.addConstraints(NSLayoutConstraint.defaultConstraintsWithVisualFormat("H:|[contentView]|", views: views))
        contentTopOffsetConstraint = contentView.constraintWithAttribute(.top, .equal, to: .top, of: backgroundView)
        contentBottomOffsetConstraint = contentView.constraintWithAttribute(.bottom, .equal, to: .bottom, of: backgroundView)
        backgroundView.addConstraint(contentTopOffsetConstraint)
        backgroundView.addConstraint(contentBottomOffsetConstraint)
        let leftConstraintText: String
        if image == nil {
            leftConstraintText = "|"
        } else {
            contentView.addSubview(imageView)
            contentView.addConstraint(imageView.constraintWithAttribute(.leading, .equal, to: contentView, constant: 15.0))
            contentView.addConstraint(imageView.constraintWithAttribute(.centerY, .equal, to: contentView))
            imageView.addConstraint(imageView.constraintWithAttribute(.width, .equal, to: 25.0))
            imageView.addConstraint(imageView.constraintWithAttribute(.height, .equal, to: .width))
            leftConstraintText = "[imageView]"
        }
        let constraintFormat = "H:\(leftConstraintText)-(15)-[labelView]-(8)-|"
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints(NSLayoutConstraint.defaultConstraintsWithVisualFormat(constraintFormat, views: views))
        contentView.addConstraints(NSLayoutConstraint.defaultConstraintsWithVisualFormat("V:|-(>=1)-[labelView]-(>=1)-|", views: views))
        backgroundView.addConstraints(NSLayoutConstraint.defaultConstraintsWithVisualFormat("H:|[contentView]-(<=1)-[labelView]", options: .alignAllCenterY, views: views))
        
        for view in [titleLabel, detailLabel] {
            let constraintFormat = "H:|[label]-(8)-|"
            contentView.addConstraints(NSLayoutConstraint.defaultConstraintsWithVisualFormat(constraintFormat, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["label": view]))
        }
        labelView.addConstraints(NSLayoutConstraint.defaultConstraintsWithVisualFormat("V:|-(10)-[titleLabel][detailLabel]-(10)-|", views: views))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var showingConstraint: NSLayoutConstraint?
    private var hiddenConstraint: NSLayoutConstraint?
    private var commonConstraints = [NSLayoutConstraint]()
    
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let superview = superview, alertState != .gone else { return }
        commonConstraints = self.constraintsWithAttributes([.width], .equal, to: superview)
        superview.addConstraints(commonConstraints)
        showingConstraint = self.constraintWithAttribute(.top, .equal, to: .top, of: superview)
        let yOffset: CGFloat = -7.0
        hiddenConstraint = self.constraintWithAttribute(.bottom, .equal, to: .top, of: superview, constant: yOffset)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        adjustHeightOffset()
        layoutIfNeeded()
    }
    private func adjustHeightOffset() {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        guard let statusBarSize = window?.windowScene?.statusBarManager?.statusBarFrame.size else {
            return
        }
        let heightOffset = min(statusBarSize.height, statusBarSize.width)
        contentTopOffsetConstraint.constant = heightOffset
        contentBottomOffsetConstraint.constant = 0
        minimumHeightConstraint.constant = statusBarSize.height > 0 ? minimumHeight : 40
    }
    
    /// Shows the alert. If a view is specified, the alert will be displayed at the top of that view, otherwise at top of the top window.
    open func show(_ view: UIView? = nil, duration: TimeInterval? = nil) {
        let viewToUse = view ?? GSNetworkAlert.topWindow()
        guard let view = viewToUse else {
            print("[Alert]: Could not find view. Aborting.")
            return
        }
        view.addSubview(self)
        forceUpdates()
        UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.5, options: .allowUserInteraction, animations: {
            self.alertState = .showing
        }, completion: { finished in
            guard let duration = duration else { return }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(1000.0 * duration))) {
                self.dismiss()
            }
        })
    }
    
    /// Dismisses the alert.
    open func dismiss() {
        guard alertState == .showing else { return }
        UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.5, options: .allowUserInteraction, animations: {
            self.alertState = .hidden
        }, completion: { finished in
            self.alertState = .gone
            self.removeFromSuperview()
            self.didDismissBlock?()
        })
    }
}

extension NSLayoutConstraint {
    @objc class func defaultConstraintsWithVisualFormat(_ format: String, options: NSLayoutConstraint.FormatOptions = NSLayoutConstraint.FormatOptions(), metrics: [String: AnyObject]? = nil, views: [String: AnyObject] = [:]) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(withVisualFormat: format, options: options, metrics: metrics, views: views)
    }
}

extension UIView {
    @objc func constraintsEqualToSuperview(_ edgeInsets: UIEdgeInsets = UIEdgeInsets.zero) -> [NSLayoutConstraint] {
        self.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        if let superview = self.superview {
            constraints.append(self.constraintWithAttribute(.leading, .equal, to: superview, constant: edgeInsets.left))
            constraints.append(self.constraintWithAttribute(.trailing, .equal, to: superview, constant: edgeInsets.right))
            constraints.append(self.constraintWithAttribute(.top, .equal, to: superview, constant: edgeInsets.top))
            constraints.append(self.constraintWithAttribute(.bottom, .equal, to: superview, constant: edgeInsets.bottom))
        }
        return constraints
    }
    
    @objc func constraintWithAttribute(_ attribute: NSLayoutConstraint.Attribute, _ relation: NSLayoutConstraint.Relation, to constant: CGFloat, multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        return NSLayoutConstraint(item: self, attribute: attribute, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: multiplier, constant: constant)
    }
    
    @objc func constraintWithAttribute(_ attribute: NSLayoutConstraint.Attribute, _ relation: NSLayoutConstraint.Relation, to otherAttribute: NSLayoutConstraint.Attribute, of item: AnyObject? = nil, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        return NSLayoutConstraint(item: self, attribute: attribute, relatedBy: relation, toItem: item ?? self, attribute: otherAttribute, multiplier: multiplier, constant: constant)
    }
    
    @objc func constraintWithAttribute(_ attribute: NSLayoutConstraint.Attribute, _ relation: NSLayoutConstraint.Relation, to item: AnyObject, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        return NSLayoutConstraint(item: self, attribute: attribute, relatedBy: relation, toItem: item, attribute: attribute, multiplier: multiplier, constant: constant)
    }
    
    func constraintsWithAttributes(_ attributes: [NSLayoutConstraint.Attribute], _ relation: NSLayoutConstraint.Relation, to item: AnyObject, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) -> [NSLayoutConstraint] {
        return attributes.map { self.constraintWithAttribute($0, relation, to: item, multiplier: multiplier, constant: constant) }
    }
}
