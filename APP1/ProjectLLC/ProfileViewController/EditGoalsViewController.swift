//
//  EditGoalsViewController.swift
//  ProjectLLC
//
//  Created by Pike on 4/26/18.
//  Copyright © 2018 Minh. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class EditGoalsViewController : UIViewController, UITextViewDelegate
{
    @IBOutlet weak var goalTextView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTextView(notification:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTextView(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        self.initializeComponents()
        
    }
    @IBAction func SaveIsClicked(_ sender: Any) {
        if self.goalTextView.text != ""
        {
            if let data = self.goalTextView.text
            {
                self.updateUserChildValue(values: ["goals" : data])
            }
        }
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "backToProfile", sender: self)
        }
    }
    
    @IBAction func doneIsClicked(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @objc func updateTextView(notification: Notification)
    {
        let userInfo = notification.userInfo!
        let keyboardEndFrameScreenCoordinates = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardEndFrame = self.view.convert(keyboardEndFrameScreenCoordinates, to: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide
        {
            self.goalTextView.contentInset = UIEdgeInsets.zero
        }
            
        else if notification.name == Notification.Name.UIKeyboardWillChangeFrame
        {
            self.goalTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardEndFrame.height - 70, right: 0)
            
        }
        self.goalTextView.scrollIndicatorInsets = self.goalTextView.contentInset
        self.goalTextView.scrollRangeToVisible(self.goalTextView.selectedRange)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.doneButton.isEnabled = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.doneButton.alpha = 1
            self.doneButton.transform = CGAffineTransform(translationX: 0, y: -33)
        }, completion: nil)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.doneButton.isEnabled = false
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.doneButton.alpha = 0
            self.doneButton.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
    }
    
    private func initializeComponents()
    {
        self.doneButton.isEnabled = false
        self.doneButton.alpha = 0
    }
    
    private func popUpError(data: String)
    {
        let alert = UIAlertController(title: "Error", message: data, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert,animated: true,completion: nil)
    }
    
    private func updateUserChildValue(values: [String: String])
    {
        if let uid = (Auth.auth().currentUser?.uid)
        {
            let userRef = Database.database().reference().child("Users").child(uid)
            
            userRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if error != nil
                {
                    self.popUpError(data: (error?.localizedDescription)!)
                }
            })
        }
    }
}
