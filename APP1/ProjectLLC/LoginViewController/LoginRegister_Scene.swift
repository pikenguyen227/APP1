//
//  loginRegister_Scence.swift
//  ProjectLLC
//
//  Created by Pike on 4/13/18.
//  Copyright © 2018 Minh. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class LoginRegister_Scene: UIViewController, UITextFieldDelegate {
    /* View that is in current view controller */
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var registerView: UIView!
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var loginRegisterScrollView: UIScrollView!
    @IBOutlet weak var loginViewLoginAndRegisterButtons: UIView!
    @IBOutlet weak var userFirstLastnameView: UIView!
    @IBOutlet weak var userEmailView: UIView!
    @IBOutlet weak var userPasswordView: UIView!
    @IBOutlet weak var restOfRegisterView: UIView!
    
    /* Textfields in side the loginView */
    @IBOutlet weak var userLoginEmail: UITextField!
    @IBOutlet weak var userLoginPassword: UITextField!
    
    /* Textfields in side the registerView */
    @IBOutlet weak var userRegisterFirstname: UITextField!
    @IBOutlet weak var userRegisterLastname: UITextField!
    @IBOutlet weak var userRegisterEmail: UITextField!
    @IBOutlet weak var userRegisterPassword: UITextField!
    @IBOutlet weak var userRegisterRetypePassword: UITextField!
    @IBOutlet weak var userGenderSegment: UISegmentedControl!
    
    /* Private variables */
    private var languageButton:dropDownButton!
    private var dropView:dropDownView!
    private var delegate: dropDownProtocol!
    private var isRegistering: Bool!
    private var keyboardHeight: CGFloat!
    private var currentEditingTextfield: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupScreen()

        /* Get keyboard information */
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
        DispatchQueue.main.async {
            if Auth.auth().currentUser != nil
            {
                self.parent?.performSegue(withIdentifier: "Login", sender: self.parent)
            }
        }
        
        /* for debugging */
        NotificationCenter.default.addObserver(self, selector: #selector(self.setEmailUser1(notification:)), name: NSNotification.Name(rawValue: "choose_user1"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(self.setEmailUser2(notification:)), name: NSNotification.Name(rawValue: "choose_user2"), object: nil)
    }

    
    @objc func setEmailUser1(notification: NSNotification)
    {
        userLoginEmail.text = "minh.t.nguyen@wsu.edu"
        userLoginPassword.text = "123456"
    }
    
    @objc func setEmailUser2(notification: NSNotification)
    {
        userLoginEmail.text = "pikenguyen227@gmail.com"
        userLoginPassword.text = "123456"
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: {
            context in
           
            if !self.isRegistering
            {
                self.loginRegisterScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                self.loginView.alpha = 1
                self.registerView.alpha = 0
            }
            else
            {
                self.loginRegisterScrollView.setContentOffset(CGPoint(x: 0, y: self.loginRegisterScrollView.frame.height), animated: false)
                self.loginView.alpha = 0
                self.registerView.alpha = 1
            }
            
        }, completion: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            if !self.isRegistering
            {
                self.loginRegisterScrollView.setContentOffset(CGPoint(x: 0, y: keyboardFrame.cgRectValue.height - self.loginViewLoginAndRegisterButtons.frame.height - CGFloat(defaultVariables.offsetWhenEditingTextfieldInLoginView)), animated: true)
            }
            else
            {
                self.keyboardHeight = keyboardFrame.cgRectValue.height
                self.setOffsetForRegisterView()
            }
        }
    }
    
    private func popUpError(data: String)
    {
        let alert = UIAlertController(title: "Error", message: data, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert,animated: true,completion: nil)
    }
    
    private func setOffsetForRegisterView()
    {
        if self.currentEditingTextfield == 0 || self.currentEditingTextfield == 1
        {
            self.loginRegisterScrollView.setContentOffset(CGPoint(x: 0, y: self.loginRegisterScrollView.frame.height +  (self.keyboardHeight - self.userEmailView.frame.height - self.userPasswordView.frame.height - self.restOfRegisterView.frame.height - CGFloat(defaultVariables.offsetWhenEditingTextfieldInRegisterView))), animated: true)
        }
        else if self.currentEditingTextfield == 2
        {
            self.loginRegisterScrollView.setContentOffset(CGPoint(x: 0, y: self.loginRegisterScrollView.frame.height +  (self.keyboardHeight - self.userPasswordView.frame.height - self.restOfRegisterView.frame.height - CGFloat(defaultVariables.offsetWhenEditingTextfieldInRegisterView - 2))), animated: true)
        }
        else if self.currentEditingTextfield == 3 || self.currentEditingTextfield == 4
        {
            self.loginRegisterScrollView.setContentOffset(CGPoint(x: 0, y: self.loginRegisterScrollView.frame.height +  (self.keyboardHeight - self.restOfRegisterView.frame.height - CGFloat(defaultVariables.offsetWhenEditingTextfieldInRegisterView - 4))), animated: true)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        if !self.isRegistering
        {
            self.loginRegisterScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        else
        {
           self.loginRegisterScrollView.setContentOffset(CGPoint(x: 0, y: self.loginRegisterScrollView.frame.height), animated: true)
        }
    }
    
    private func setupScreen()
    {
        createAndSetupLanguageButton()
        self.registerView.alpha = 0
        self.isRegistering = false
    }
    
    private func createAndSetupLanguageButton()
    {
         // Create a language button, and add to the login view.
         self.languageButton = dropDownButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
         self.languageButton.setTitle("Users", for: .normal)
         self.loginView.addSubview(languageButton)
        
        // Setting anchor.
         self.languageButton.anchor(top: loginView.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 150,height: 50))
         self.languageButton.anchorCenter(x: loginView.safeAreaLayoutGuide.centerXAnchor, y: nil)
         self.languageButton.backgroundColor = UIColor.clear
  
        // Populate the drop view.
        self.languageButton.dropView.dropDownOptions = defaultVariables.supporteduser
        self.loginView.bringSubview(toFront: self.languageButton)
        self.loginView.bringSubview(toFront: self.languageButton.dropView)
    }
    
    private func checkFieldsInLogin() -> Bool
    {
        if self.userLoginEmail.text == ""
        {
            self.popUpError(data: defaultVariables.missingEmail)
            return false
        }
        if self.userLoginPassword.text == ""
        {
            self.popUpError(data: defaultVariables.missingPassword)
            return false
        }
        return true
    }
    
    private func checkFieldsInRegister() -> Bool
    {
        if self.userRegisterFirstname.text == ""
        {
            self.popUpError(data: defaultVariables.missingFirstname)
            return false
        }
        if self.userRegisterLastname.text == ""
        {
            self.popUpError(data: defaultVariables.missingLastname)
            return false
        }
        if self.userRegisterEmail.text == ""
        {
            self.popUpError(data: defaultVariables.missingEmail)
            return false
        }
        if self.userRegisterPassword.text == ""
        {
            self.popUpError(data: defaultVariables.missingPassword)
            return false
        }
        if self.userRegisterRetypePassword.text == ""
        {
            self.popUpError(data: defaultVariables.missingRetypePassword)
            return false
        }
        if self.userRegisterPassword.text != self.userRegisterRetypePassword.text
        {
            self.popUpError(data: defaultVariables.passwordNotMatched)
            return false
        }
        return true
    }
    
    private func handleLogining()
    {
        if Auth.auth().currentUser == nil
        {
            Auth.auth().signIn(withEmail: userLoginEmail.text!, password: userLoginPassword.text!, completion: {
                (user, er) in
                if er != nil
                {
                    self.popUpError(data: (er?.localizedDescription)!)
                    return
                }
                
                if !(user?.isEmailVerified)!
                {
                    let alert = UIAlertController(title: "Verification Required", message: "An email wassent your email. Please click on the link inside the email for verification.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.default, handler: {(action) in
                        self.signoutUser()
                        alert.dismiss(animated: true, completion: nil)
                        }))
                    alert.addAction(UIAlertAction(title: "Resend", style: UIAlertActionStyle.default, handler: {(action) in
                        self.resendingEmail()
                        alert.dismiss(animated: true, completion: nil)
                        }))
                    self.present(alert,animated: true,completion: nil)
                }
                else
                {
                    self.parent?.performSegue(withIdentifier: "Login", sender: self.parent)
                }
            })
        }
/*
        /* For debug */
        else
        {
            self.signoutUser()
        }
        */
    }
    
    private func handleRegistering()
    {
        let firebaseRef = Database.database().reference()
        Auth.auth().createUser(withEmail: self.userRegisterEmail.text!, password: self.userRegisterPassword.text!, completion: {
            (user, er) in
            if er != nil
            {
                self.popUpError(data: (er?.localizedDescription)!)
                return
            }
            
            guard let uid = user?.uid else {
                user?.delete(completion: nil)
                return
            }
            
            let userRef = firebaseRef.child("Users").child((uid))
            if self.userGenderSegment.selectedSegmentIndex == 0
            {
                userRef.setValue(["firstname" : self.userRegisterFirstname.text!,"lastname" : self.userRegisterLastname.text!, "height" : 0, "weight": 0, "about": "","email" : self.userRegisterEmail.text!.uppercased(), "gender" : "Male" , "profileImageURL" : "", "coverImageURL" : "", "goals" : ""])
            }
            else
            {
                 userRef.setValue(["firstname" : self.userRegisterFirstname.text!,"lastname" : self.userRegisterLastname.text!, "height" : 0, "weight": 0, "about": "","email" : self.userRegisterEmail.text!.uppercased(), "gender" : "Female", "profileImageURL" : "", "coverImageURL" : "", "goals" : ""])
            }
            
            Auth.auth().currentUser?.sendEmailVerification { (verificationError) in
                if verificationError != nil
                {
                    user?.delete(completion: nil)
                    self.popUpError(data: (verificationError?.localizedDescription)!)
                    return
                }
                else
                {
                    let alert = UIAlertController(title: "Registation Succeed", message: "An email has been sent your email. Please click on the link inside the email for verification.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.default, handler: {(action) in
                        self.signoutUser()
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    alert.addAction(UIAlertAction(title: "Resend", style: UIAlertActionStyle.default, handler: {(action) in
                        self.resendingEmail()
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert,animated: true,completion: nil)
                    self.scrollToLogin()
                    
                }
            }
        })
    }
    
    private func resendingEmail()
    {
        Auth.auth().currentUser?.sendEmailVerification { (verificationError) in
            if verificationError != nil
            {
                self.popUpError(data: (verificationError?.localizedDescription)!)
                return
            }
            self.signoutUser()
        }
    }
    
    private func signoutUser()
    {
        do
        {
            try Auth.auth().signOut()
        }
        catch let error as NSError
        {
            self.popUpError(data: (error.localizedDescription))
        }
    }
    
    private func scrollToRegister()
    {
        self.loginRegisterScrollView.setContentOffset(CGPoint(x: 0, y: self.loginRegisterScrollView.frame.height), animated: true)
        self.isRegistering = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.loginView.alpha = 0
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.registerView.alpha = 1
        }, completion: nil)
    }
    
    private func scrollToLogin()
    {
        self.loginRegisterScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        self.isRegistering = false
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.loginView.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.registerView.alpha = 0
        }, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.currentEditingTextfield = textField.tag
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.currentEditingTextfield = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0
        {
            if !self.isRegistering
            {
                userLoginPassword.becomeFirstResponder()
            }
            else
            {
                userRegisterLastname.becomeFirstResponder()
            }
        }
        else if textField.tag == 1
        {
            if !self.isRegistering
            {
                self.view.endEditing(true)
            }
            else
            {
                userRegisterEmail.becomeFirstResponder()
                self.setOffsetForRegisterView()
            }
        }
        else if textField.tag == 2
        {
            userRegisterPassword.becomeFirstResponder()
            self.setOffsetForRegisterView()
            
        }
        else if textField.tag == 3
        {
            userRegisterRetypePassword.becomeFirstResponder()
            self.setOffsetForRegisterView()
        }
        else if textField.tag == 4
        {
            self.view.endEditing(true)
        }
        return true
    }
    
    @IBAction func registerIsClicked(_ sender: Any) {
        self.scrollToRegister()
        
    }
    
    @IBAction func cancelIsClicked(_ sender: Any) {
       self.scrollToLogin()
        
    }
    
    @IBAction func loginButtonIsClicked(_ sender: Any) {
        if self.checkFieldsInLogin()
        {
            self.handleLogining()
        }
    }
    
    @IBAction func registerButtonIsClicked(_ sender: Any) {
        if self.checkFieldsInRegister()
        {
            self.handleRegistering()
        }
    }
    
}
