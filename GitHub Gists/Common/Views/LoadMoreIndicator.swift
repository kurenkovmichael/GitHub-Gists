//
//  LoadMoreIndicator.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 14.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import UIKit

class LoadMoreIndicator: UIView {

    static let defaultSize = 61
    static let defaultShift = 12
    
    // MARK: UIView
    
    convenience init() {
        let size = LoadMoreIndicator.defaultSize
        self.init(frame: CGRect.init(x: 0, y: 0, width: size, height: size))
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // MARK: Public
    
    func startAnimating() {
        spiner.startAnimating()
        UIView.animate(withDuration: 0.3) {
            self.spiner.alpha = 1
        }
    }
    
    func stopAnimating() {
        UIView.animate(withDuration: 0.3, animations: {
            self.spiner.alpha = 0
        }, completion: { _ in
            self.spiner.stopAnimating()
        })
    }
    
    // MARK: Private
    
    var spiner: UIActivityIndicatorView!
    
    private func setup() {
        let shift = LoadMoreIndicator.defaultShift
        
        spiner = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        spiner.translatesAutoresizingMaskIntoConstraints = false
        spiner.hidesWhenStopped = true
        spiner.alpha = 0
        
        addSubview(spiner)
        centerXAnchor.constraint(equalTo: spiner.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: spiner.centerYAnchor, constant: CGFloat(shift)).isActive = true
    }
}
