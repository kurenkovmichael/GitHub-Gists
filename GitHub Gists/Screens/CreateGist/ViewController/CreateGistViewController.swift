//
//  CreateGistViewController.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 20.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import UIKit

class CreateGistViewController: UIViewController,
    CreateGistModelObserver,
    UITextFieldDelegate {

    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var isPublicLabel: UILabel!
    @IBOutlet weak var isPublicSwitch: UISwitch!
    @IBOutlet weak var fileNameTextField: UITextField!

    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var activityIndicatorContainer: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var router: Rourer!
    var model: CreateGistModel! {
        willSet {
            if (model != nil) {
                model.observer = nil
            }
        }
        didSet {
            model.observer = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        title = NSLocalizedString("createGistScreen.title", comment: "")
        
        descriptionTextField.placeholder = NSLocalizedString("createGist.descriptionPlaceholder", comment: "")
        
        isPublicLabel.text =  NSLocalizedString("createGist.public", comment: "")
        isPublicSwitch.tintColor = .darkGray
        
        fileNameTextField.placeholder = NSLocalizedString("createGist.filenamePlaceholder", comment: "")
        
        createButton.configureUI()
        createButton.setTitle(NSLocalizedString("createGist.createButton", comment: ""), for: .normal)
    }
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
        activityIndicatorContainer.isHidden = false
        activityIndicator.startAnimating()
        
        let gistDescription = descriptionTextField.text ?? ""
        let isPublic = isPublicSwitch.isOn
        let files = [ fileNameTextField.text ?? "" : fileNameTextField.text ?? "" ]
        model.createGist(description: gistDescription, public: isPublic, files: files)
    }

    // MARK: CreateGistModelObserver
    
    func finishCreateingGist(successful: Bool, withError error: GistsError?) {
        activityIndicator.stopAnimating()
        activityIndicatorContainer.isHidden = true
        
        if successful {
            router.hideCurrentScreen()
        } else if error?.isUnauthorized ?? false {
            
            // TODO: Need to implement a session restore.
            router.showAlert(withError: error) {
                self.router.showStartScreen()
            }
        } else {
            router.showAlert(withError: .unknownError(error: nil))
        }
    }
        
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case descriptionTextField:
            fileNameTextField.becomeFirstResponder()
            return true
            
        case fileNameTextField:
            fileNameTextField.resignFirstResponder()
            return true
            
        default:
            return false
        }
    }
}
