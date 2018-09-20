//
//  GistInfoTableViewCell.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 15.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import UIKit

class GistInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var updatedDateLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse();
        
        descriptionLabel.text = nil
        createdDateLabel.text = nil
        updatedDateLabel.text = nil
    }
    
    private lazy var dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter;
    }()
    
    public func configure(with gist: GistEntity) {
        descriptionLabel.text = gist.gistsDescription
        createdDateLabel.text = nil
        updatedDateLabel.text = nil
        
        if let createdAt = gist.createdAt {
            let title = NSLocalizedString("gist.createdAt", comment: "")
            createdDateLabel.text = "\(title) \(dateFormatter.string(from: createdAt))"
        } else {
            createdDateLabel.text = nil
        }
        
        if let updatedAt = gist.updatedAt {
            let title = NSLocalizedString("gist.updatedAt", comment: "")
            updatedDateLabel.text = "\(title) \(dateFormatter.string(from: updatedAt))"
        } else {
            updatedDateLabel.text = nil
        }
    }
}
