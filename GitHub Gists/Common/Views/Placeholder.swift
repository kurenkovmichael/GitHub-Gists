//
//  Placeholder.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 16.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import UIKit

class Placeholder: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var actionsContainer: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: Placeholder
    
    var error: GistsError? = nil {
        didSet {
            updateTexts()
            if (isShown) {
                show()
            }
        }
    }
    
    var buttonPressed: (()->Void)?
    var buttonTitle: String? {
        didSet {
            actionButton.setTitle(buttonTitle, for: .normal)
            updateActions()
        }
    }
    
    var loading: Bool = false {
        didSet {
            updateActions()
        }
    }
    
    private var animating = false
    private func updateActions() {
        let activityShown = self.loading
        let actionsHidden = !loading && (buttonTitle == nil)
        guard !animating &&
            (actionsContainer.isHidden != actionsHidden ||
             activityIndicator.isAnimating != activityShown ||
             actionButton.isHidden != activityShown) else {
                return
        }
        
        animating = true
        if !actionsHidden {
            self.actionsContainer.isHidden = false
        }
        if activityShown {
            activityIndicator.startAnimating()
        } else {
            self.actionButton.alpha = 0
            self.actionButton.isHidden = false
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.actionButton.alpha = activityShown ? 0 : 1
        }) { _ in
            if actionsHidden {
                self.actionsContainer.isHidden = true
            }
            if activityShown {
                self.actionButton.isHidden = true
            } else {
                self.actionButton.alpha = 1
                self.activityIndicator.stopAnimating()
            }
            self.animating = false
            self.updateActions()
        }
    }
    
    class func fromNib() -> Placeholder {
        let nib = UINib(nibName: "Placeholder", bundle: nil)
        let views = nib.instantiate(withOwner: nil, options: nil)
        return views.first as! Placeholder
    }
    
    func add(on view: UIView, animated: Bool) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        view.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        view.bringSubview(toFront: self)
        updateTexts()
    }
    
    private var isShown = false
    private var opacity: Float = 1
    
    private let animationKey = "opacity animation"
    private let animationDuration = 0.3
    
    func show(opacity: Float? = nil) {
        isShown = true
        if let opacity = opacity {
            self.opacity = opacity
        }
        
        let opacityToUse = (error != nil) ? self.opacity : 0
        
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.toValue = opacityToUse
        animation.duration = animationDuration
        layer.add(animation, forKey: animationKey)
        layer.opacity = opacityToUse
    }
    
    func hide() {
        isShown = false
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.toValue = 0
        animation.duration = animationDuration
        layer.add(animation, forKey: animationKey)
        layer.opacity = 0
    }
    
    // MARK: UiView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = nil
        subtitleLabel.text = nil
        actionButton.configureUI()
        hide()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let convertedPoint = actionButton.convert(point, from: self)
        if let hitView = actionButton.hitTest(convertedPoint, with: event) {
            return hitView
        }
        return nil
    }
    
    // MARK: Private
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        if let handler = buttonPressed {
            handler()
        }
    }
    
    private func updateTexts() {
        titleLabel.text = error?.localizedTitle
        subtitleLabel.text = error?.localizedSubtitle
    }

}
