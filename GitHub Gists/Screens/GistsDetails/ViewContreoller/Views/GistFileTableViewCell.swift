//
//  GistFileTableViewCell.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 15.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import UIKit

class GistFileTableViewCell: UITableViewCell {

    @IBOutlet weak var filenameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        filenameLabel.text = nil
        contentLabel.text = nil
        typeLabel.text = nil
        sizeLabel.text = nil
    }
    
    private lazy var byteCountFormatter: ByteCountFormatter = {
        var formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter;
    }()
    

    func configure(file: GistFileEntity) {
        filenameLabel.text = file.filename
        contentLabel.text = file.content
        if !(file.type?.isEmpty ?? true) && !(file.language?.isEmpty ?? true) {
            typeLabel.text = "\(file.type!) / \(file.language!)"
        } else {
            typeLabel.text = file.type ?? file.language
        }
        sizeLabel.text = byteCountFormatter.string(fromByteCount: file.size?.int64Value ?? 0)
    }
    
}
