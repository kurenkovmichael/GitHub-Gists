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

    @IBOutlet weak var loginTitleFerstLabel: UILabel!
    @IBOutlet weak var loginTitleSecondLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!

    @IBOutlet weak var contentCenterConstraint: NSLayoutConstraint!

    @IBOutlet weak var activityIndicatorContainer: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

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
        if !loginInProgress {
            model.logout()
        }
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
            return
        }

        model.logout()
        model.choseUsername(username)
        rourer.showGistsList(withUserName: username)
    }

    var loginInProgress = false
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        activityIndicatorContainer.isHidden = false
        activityIndicator.startAnimating()
        loginInProgress = true

        model.loginToGitHub(on: self) { result in
            self.activityIndicatorContainer.isHidden = true
            self.activityIndicator.stopAnimating()
            self.loginInProgress = false

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
        choseUsernameButton.configureUI()

        loginTitleFerstLabel.text = NSLocalizedString("login.titleFirst", comment: "")
        loginTitleSecondLabel.text = NSLocalizedString("login.titleSecond", comment: "")
        loginButton.setTitle(NSLocalizedString("login.button", comment: ""), for: .normal)
        loginButton.configureUI()
    }

    func updateChoseUsernameButtonEnabled() {
        let username = choseUserNameTextField.text
        let existsUsername = username != nil && !(username!.isEmpty)
        choseUsernameButton.isEnabled = existsUsername
    }

    func updateContentPosition(forKeyboardFrame keyboardFrame: CGRect, duration: TimeInterval) {
        let buttomOffset = view.bounds.height - keyboardFrame.minY
        contentCenterConstraint.constant = buttomOffset / 2

        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }

    // MARK: Keyboard

    func startToObserveKeyboardFrameChanges() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardShown),
                                               name: .UIKeyboardWillChangeFrame,
                                               object: nil)
    }

    func stopToObserveKeyboardFrameChanges() {
        NotificationCenter.default.removeObserver(self,
                                                  name: .UIKeyboardWillChangeFrame,
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
