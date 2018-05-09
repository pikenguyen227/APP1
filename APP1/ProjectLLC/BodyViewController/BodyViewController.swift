//
//  BodyViewController.swift
//  ProjectLLC
//
//  Created by Pike on 4/27/18.
//  Copyright © 2018 Minh. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class BodyViewController: UIViewController, UIScrollViewDelegate
{
    
    @IBOutlet var bodyPartButtons: [UIButton]!
    @IBOutlet weak var bodyImageFront: UIImageView!
    @IBOutlet weak var bodyImageBack: UIImageView!
    @IBOutlet weak var bodyPartsButtonScrollView: UIScrollView!
    @IBOutlet weak var bodyPartsButtonScrollViewBack: UIScrollView!
    @IBOutlet weak var exercisesInfomationView: UIView!
    @IBOutlet weak var helpMessageViewConroller: UIView!
    @IBOutlet weak var frontAndBackScrollView: UIScrollView!
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var currentFocusingPart:Int!
    private var currentPage:Int!
    private var selectedButton: UIButton!
    private var currentGender: String!

   
    
    override func viewDidDisappear(_ animated: Bool) {
         self.comeBackToInitialState()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.initializingButtons()
        self.animateInButtons()
        self.animateInBodyImage()
        self.fetchUserData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.stopActivityIndicator(notification:)), name: NSNotification.Name(rawValue: "Stop_AI"), object: nil)
       
      
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (context) in
            if self.currentPage  == 1
            {
                self.frontView.alpha = 1
                self.backView.alpha = 0
                self.currentPage = 1
                self.frontAndBackScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
            else
            {
                self.frontView.alpha = 0
                self.backView.alpha = 1
                self.currentPage = 2
                 self.frontAndBackScrollView.setContentOffset(CGPoint(x: self.view.frame.width, y: 0), animated: true)
            }
            if self.selectedButton != nil
            {
                if self.currentPage == 1
                {
                     self.bodyPartsButtonScrollView.setContentOffset(CGPoint(x:0,y:CGFloat(self.selectedButton.tag * 56)), animated: true)
                }
                else
                {
                     self.bodyPartsButtonScrollViewBack.setContentOffset(CGPoint(x:0,y:CGFloat((self.selectedButton.tag - 7) * 56)), animated: true)
                }
            }
        }, completion: nil)    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.currentPage == 1
        {
            if self.frontAndBackScrollView.contentOffset.x > 0
            {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.frontView.alpha = 0
                    self.backView.alpha = 1
                }, completion: nil)
                self.currentPage = 2
                bodyPartsButtonScrollViewBack.setContentOffset(CGPoint(x:0,y:0), animated: false)
            }
        }
        else
        {
            if self.frontAndBackScrollView.contentOffset.x == 0
            {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.frontView.alpha = 1
                    self.backView.alpha = 0
                }, completion: nil)
                self.currentPage = 1
                bodyPartsButtonScrollView.setContentOffset(CGPoint(x:0,y:0), animated: false)
                
            }
        }
        self.moveButtonBackToInitialState()
    }
    
    @IBAction func aPartIsClicked(_ sender: Any) {
        if self.currentFocusingPart == nil
        {
            self.animateAndFocusOnAPart(obj: (sender as! UIButton))
            self.selectedButton = (sender as! UIButton)
            self.frontAndBackScrollView.isScrollEnabled = false
            self.activityIndicator.startAnimating();
            self.changeHumanPicture(number: self.selectedButton.tag)
        }
        else
        {
            self.comeBackToInitialState()
            self.selectedButton = nil
            self.frontAndBackScrollView.isScrollEnabled = true
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Clean_Up"), object: nil)
            }
            if self.currentPage == 1
            {
                self.changeHumanPicture(number: 1000)
            }
            else if self.currentPage == 2
            {
                self.changeHumanPicture(number: 1001)
            }
           
        }
        
    }
    
    @objc func stopActivityIndicator(notification: NSNotification)
    {
        self.activityIndicator.stopAnimating()
    }
    
    private func changeHumanPicture(number: Int)
    {
        if number == 0
        {
            self.bodyImageFront.image = UIImage(named: self.currentGender + "UpperArm.png")
        }
        else if number == 1
        {
            self.bodyImageFront.image = UIImage(named: self.currentGender + "Chest.png")
        }
        else if number == 2
        {
            self.bodyImageFront.image = UIImage(named: self.currentGender + "Forearm.png")
        }
        else if number == 3
        {
           self.bodyImageFront.image = UIImage(named: self.currentGender + "Abs.png")
        }
        else if number == 4
        {
           self.bodyImageFront.image = UIImage(named: self.currentGender + "SideAbs.png")
        }
        else if number == 5
        {
           self.bodyImageFront.image = UIImage(named: self.currentGender + "UpperLeg.png")
        }
        else if number == 6
        {
           self.bodyImageFront.image = UIImage(named: self.currentGender + "LowerLeg.png")
        }
        else if number == 7
        {
            self.bodyImageBack.image = UIImage(named: self.currentGender + "UpperArmBack.png")
        }
        else if number == 8
        {
            self.bodyImageBack.image = UIImage(named: self.currentGender + "UpperBack.png")
        }
        else if number == 9
        {
            self.bodyImageBack.image = UIImage(named: self.currentGender + "ForearmBack.png")
        }
        else if number == 10
        {
            self.bodyImageBack.image = UIImage(named: self.currentGender + "LowerBack.png")
        }
        else if number == 11
        {
            self.bodyImageBack.image = UIImage(named: self.currentGender + "GlutesBack.png")
        }
        else if number == 12
        {
            self.bodyImageBack.image = UIImage(named: self.currentGender + "UpperLegBack.png")
        }
        else if number == 13
        {
            self.bodyImageBack.image = UIImage(named: self.currentGender + "LowerLegBack.png")
        }
        else if number == 1000
        {
            self.bodyImageFront.image = UIImage(named: self.currentGender + "Default.png")
        }
        else if number == 1001
        {
            self.bodyImageBack.image = UIImage(named: self.currentGender + "DefaultBack.png")
        }
    }
    
    private func sentID()
    {
        let DataDict:[String: Int] = ["id": self.selectedButton.tag + 1]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Parsing_JSON"), object: nil, userInfo: DataDict)
    }
    
    private func animateAndFocusOnAPart(obj: UIButton)
    {
        for item in bodyPartButtons
        {
            if self.currentPage == 1 && item.tag < 7
            {
                if item.tag == obj.tag
                {
                    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        item.transform = CGAffineTransform(translationX: 20, y: 0)
                    }, completion: {(finished: Bool) in
                        self.sentID()
                    })
                }
                else
                {
                    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        item.alpha = 0
                        item.transform = CGAffineTransform(translationX: -20, y: 0)
                        self.exercisesInfomationView.alpha = 1
                        self.helpMessageViewConroller.alpha = 0
                    }, completion: { (finished: Bool) in
                        
                    })
                    item.isEnabled = false
                }
                self.bodyPartsButtonScrollView.setContentOffset(CGPoint(x:0,y:CGFloat(obj.tag * 56)), animated: true)
                self.currentFocusingPart = obj.tag
                self.bodyPartsButtonScrollView.isScrollEnabled = false
                self.exercisesInfomationView.isUserInteractionEnabled = true
            }
   
            else
            {
                if item.tag == obj.tag
                {
                    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        item.transform = CGAffineTransform(translationX: -20, y: 0)
                    }, completion: {(finished: Bool) in
                        self.sentID()
                    })
                }
                else
                {
                    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        item.alpha = 0
                        item.transform = CGAffineTransform(translationX: 20, y: 0)
                        self.exercisesInfomationView.alpha = 1
                        self.helpMessageViewConroller.alpha = 0
                    }, completion: { (finished: Bool) in
                        
                    })
                    item.isEnabled = false
                }
                self.bodyPartsButtonScrollViewBack.setContentOffset(CGPoint(x:0,y:CGFloat((obj.tag - 7) * 56)), animated: true)
                self.currentFocusingPart = obj.tag
                self.bodyPartsButtonScrollView.isScrollEnabled = false
                self.exercisesInfomationView.isUserInteractionEnabled = true
            }
        }
        
    }

    private func comeBackToInitialState()
    {
        self.moveButtonBackToInitialState()
        self.bodyPartsButtonScrollView.setContentOffset(CGPoint(x:0,y:0), animated: true)
        self.bodyPartsButtonScrollViewBack.setContentOffset(CGPoint(x:0,y:0), animated: true)
        self.currentFocusingPart = nil
        self.bodyPartsButtonScrollView.isScrollEnabled = true
        self.bodyPartsButtonScrollViewBack.isScrollEnabled = true
        self.exercisesInfomationView.isUserInteractionEnabled = false
        self.helpMessageViewConroller.alpha = 1
    }
    
    private func moveButtonBackToInitialState()
    {
        for item in bodyPartButtons
        {
            if self.currentPage == 1 && item.tag < 7
            {
            
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    item.alpha = 1
                    self.exercisesInfomationView.alpha = 0
                }, completion: nil)
                item.isEnabled = true
                item.transform = CGAffineTransform(translationX: 10, y: 0)
            }
            else
            {
                
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                   item.alpha = 1
                    self.exercisesInfomationView.alpha = 0
                }, completion: nil)
                item.isEnabled = true
                item.transform = CGAffineTransform(translationX: -10, y: 0)
            }
        }
    }
    
    private func initializingButtons()
    {
        for item in bodyPartButtons
        {
            item.alpha = 0;
        }
        self.bodyImageFront.alpha = 0
        self.exercisesInfomationView.alpha = 0
        self.exercisesInfomationView.isUserInteractionEnabled = false
        self.currentPage = 1
        self.backView.alpha = 0
    }
    
    private func animateInButtons()
    {
        var delay = 0.5
        for item in bodyPartButtons
        {
            if (item.tag < 7)
            {
                UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    item.alpha = 1
                    item.transform = CGAffineTransform(translationX: 10, y: 0)
                }, completion: nil)
            }
            else
            {
                item.transform = CGAffineTransform(translationX: -10, y: 0)
            }
            delay = delay + 0.2
        }
    }
    
    private func animateInBodyImage()
    {
        UIView.animate(withDuration: 1.4, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.bodyImageFront.alpha = 1
            self.bodyImageFront.transform = CGAffineTransform(translationX: -20, y: 0)
        }, completion: nil)
    }
    
    private func fetchUserData()
    {
        if Auth.auth().currentUser?.uid != nil
        {
        Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: {
                (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                     self.currentGender =  (dictionary["gender"] as? String)!
                     self.bodyImageFront.image = UIImage(named: (dictionary["gender"] as? String)! + "Default.png")
                     self.bodyImageBack.image = UIImage(named: (dictionary["gender"] as? String)! + "DefaultBack.png")
                }
            })
        }
    }
}
