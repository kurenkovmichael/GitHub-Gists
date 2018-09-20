//
//  GistsTableViewCell.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 14.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import UIKit

class GistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var filesLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = nil
        filesLabel.text = "0"
        createdDateLabel.text = nil
    }
    
    private lazy var dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter;
    }()
    
    public func configure(with gist: GistEntity) {
        var name = gist.gistsDescription
        if name?.isEmpty ?? true {
            let filenames = gist.files.compactMap { ($0 as? GistFileEntity)?.filename }
            name = filenames.joined(separator: "\n")
        }
        nameLabel.text = name
        filesLabel.text = "\(gist.files.count)"
        if let createdAt = gist.createdAt {
            createdDateLabel.text = dateFormatter.string(from: createdAt)
        } else {
            createdDateLabel.text = nil
        }
    }
    
}
