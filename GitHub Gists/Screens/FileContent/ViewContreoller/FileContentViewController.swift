//
//  FileContentViewController.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 15.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import UIKit
import CoreData

class FileContentViewController: UIViewController, FileContentModelObserver {

    var model: FileContentModel! {
        willSet {
            if let model = model {
                model.observer = nil
                updateContent()
            }
        }
        didSet {
            model.observer = self
        }
    }

    @IBOutlet weak var contentTextView: UITextView!

    weak var placeholder: Placeholder!

    override func viewDidLoad() {
        super.viewDidLoad()

        placeholder = Placeholder.fromNib()
        placeholder.add(on: view, animated: false)
        placeholder.buttonTitle = NSLocalizedString("placeholder.reloadButton", comment: "")
        placeholder.buttonPressed = { [weak self] in
            self?.placeholder.loading = true
            self?.model.reloadContent()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTitle()
        updateContent()
    }

    private func updateTitle() {
        title = model.filename
    }

    private func updateContent() {
        guard isViewLoaded else {
            return
        }

        if let file = model.obtainFileEntity(),
            let content = file.content {
            contentTextView.text = content
        } else {
            if placeholder.error == nil {
                placeholder.error = .noFileContent
            }
            placeholder.show()
            contentTextView.text = nil
        }
    }

    // MARK: FileContentModelObserver

    func finishLoading(successful: Bool, withError error: GistsError?) {
        placeholder.loading = false
        placeholder.error = error
        updateContent()
    }

}
