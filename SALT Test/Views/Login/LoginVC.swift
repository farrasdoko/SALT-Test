//
//  LoginVC.swift
//  SALT Test
//
//  Created by Farras Doko on 20/09/22.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    var loginVM: LoginVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let client = HTTPClientHelper()
        let helper = LoginHelper(client: client)
        loginVM = LoginVM(loginHelper: helper)
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardNotifications()
    }
    
    private func setupView() {
        emailTxt.delegate = self
        passwordTxt.delegate = self
    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        guard let loginVM = loginVM else {print("login view model not found");return}
        sender.isEnabled = false
        
        loginVM.login(email: emailTxt.text, password: passwordTxt.text) { [weak self] result in
            guard let self = self else {return}
            sender.isEnabled = true
            
            switch result {
            case .success(_):
                self.goToUserDetail()
            case .failed(let msg):
                self.showAlert(msg: msg)
            case .otherError:
                self.showAlert(msg: "Unknown error occured. Please try again later")
            }
        }
    }
    
    private func goToUserDetail() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "UserDetailVC") as! UserDetailVC
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func showAlert(msg: String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }

    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification:NSNotification) {

        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTxt {
            passwordTxt.becomeFirstResponder()
        } else if textField == passwordTxt {
            textField.endEditing(false)
        }
        return true
    }
}

