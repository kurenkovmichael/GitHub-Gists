//
//  ChoseGistsSourseViewController.swift
//  GitHub Gists
//
//  Created by Михаил Куренков on 12.09.2018.
//  Copyright © 2018 Михаил Куренков. All rights reserved.
//

import UIKit

class ChoseGistsSourseViewController: UIViewController {
    
    var model: ChoseGistsModel!
    var rourer: Rourer!
    
    @IBOutlet weak var choseUserNameTitleLabel: UILabel!
    @IBOutlet weak var choseUserNameTextField: UITextField!
    @IBOutlet weak var choseUsernameButton: UIButton!
    
    @IBOutlet weak var loginTitleLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: UIViewControlle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startToObserveKeyboardFrameChanges()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        choseUserNameTextField.text = model.previousChosedUsername
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        model.logout()
        updateChoseUsernameButtonEnabled()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        choseUsernameButton.isEnabled = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopToObserveKeyboardFrameChanges()
    }
    
    // MARK: Actions

    @IBAction func userNameChanged(_ sender: UITextField) {
        updateChoseUsernameButtonEnabled()
    }
    
    @IBAction func choseUsernameButtonPressed(_ sender: UIButton) {
        guard let username = choseUserNameTextField.text else {
            return;
        }
        
        model.choseUsername(username)
        rourer.showGistsList(withUserName: username)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        self.view.isUserInteractionEnabled = false
        model.loginToGitHub(on: self) { result in
            self.view.isUserInteractionEnabled = true
            switch result {
            case .success(let username):
                self.rourer.showGistsList(withUserName: username)
            default:
                break
            }
        }
    }
    
    // MARK: UI
    
    func configureUI() {
        choseUserNameTitleLabel.text = NSLocalizedString("choseUsername.title", comment: "")
        choseUserNameTextField.placeholder = NSLocalizedString("choseUsername.placeholder", comment: "")
        choseUsernameButton.setTitle(NSLocalizedString("choseUsername.button", comment: ""), for: .normal)
        
        loginTitleLabel.text = NSLocalizedString("login.title", comment: "")
        loginButton.setTitle(NSLocalizedString("login.button", comment: ""), for: .normal)
    }
    
    func updateChoseUsernameButtonEnabled() {
        let username = choseUserNameTextField.text
        let existsUsername = username != nil && !(username!.isEmpty)
        choseUsernameButton.isEnabled = existsUsername
    }
    
    func updateContentPosition(forKeyboardFrame keyboardFrame: CGRect, duration: TimeInterval) {
        let buttomOffset = view.bounds.height - keyboardFrame.minY
        bottomConstraint.constant = buttomOffset
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: Keyboard

    func startToObserveKeyboardFrameChanges() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardShown),
                                               name:.UIKeyboardWillChangeFrame,
                                               object: nil)
    }
    
    func stopToObserveKeyboardFrameChanges() {
        NotificationCenter.default.removeObserver(self,
                                                  name:.UIKeyboardWillChangeFrame,
                                                  object: nil)
    }
    
    @objc func keyboardShown(notification: NSNotification) {
        guard let info = notification.userInfo,
              let frameEndValue = info[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
                return
        }
        
        let keyboardFrame = view.convert(frameEndValue.cgRectValue, from: nil)
        let duration = info[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval
        updateContentPosition(forKeyboardFrame: keyboardFrame, duration: duration ?? 0.25)
    }
}
