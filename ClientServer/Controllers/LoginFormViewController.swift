//
//  LoginFormViewController.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 17.08.2021.
//

import UIKit

class LoginFormViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var yellowPoint: UIView!
    @IBOutlet weak var bluePoint: UIView!
    @IBOutlet weak var orangePoint: UIView!
    
    let loginService = LoginService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        scrollView?.addGestureRecognizer(hideKeyboardGesture)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.alpha = 0
        indicatorView.alpha = 1
        showIndicateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
    }
    
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let login = loginTextField.text, let password = passwordTextField.text else { return false }
        let checkResult = loginService.checkUserData(login: login, password: password)
        
        if !checkResult {
            showLoginError()
        }
        
        return checkResult
    }
    
    func showLoginError() {
        let alert = UIAlertController(title: "Ошибка", message: "Введены неверные данные пользователя", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showIndicateView() {
        UIView.animate(
            withDuration: 0.5,
            animations: { [weak self] in
                self?.yellowPoint.alpha = 0
                self?.orangePoint.alpha = 1
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.5,
                    animations: { [weak self] in
                        self?.yellowPoint.alpha = 1
                        self?.bluePoint.alpha = 0
                    },
                    completion: { _ in
                        UIView.animate(
                            withDuration: 0.5,
                            animations: { [weak self] in
                                self?.bluePoint.alpha = 1
                                self?.orangePoint.alpha = 0
                            },
                            completion: { [weak self] _ in
                                self?.orangePoint.alpha = 1
                                self?.indicatorView.alpha = 0
                                self?.scrollView.alpha = 1
                            }
                        )
                    }
                )
            }
        )
    }
}
