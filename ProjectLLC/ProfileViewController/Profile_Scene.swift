//
//  Profile_Scene.swift
//  ProjectLLC
//
//  Created by Pike on 4/26/18.
//  Copyright © 2018 Minh. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Profile_Scene: UIViewController,  UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var userCoverPicture: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var coverPictureImageView: UIImageView!
    
    @IBOutlet weak var userInfoCollectionView: UIView!
    private var updatePicture: Int!
  

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTapGesture(v: self.profilePictureImageView)
        self.addTapGesture(v: self.coverPictureImageView)
        self.initializeViewContents()
        self.fetchUserData()
    }
    
    
    @IBAction func logoutIsClicked(_ sender: Any) {
        if Auth.auth().currentUser != nil
        {
            let alert = UIAlertController(title: "Logout", message: "Are you sure that you want to logout?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cacnel", style: UIAlertActionStyle.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(action) in
                self.signoutUser()
                self.performSegue(withIdentifier: "Logout", sender: self)
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert,animated: true,completion: nil)
        }
    }
    
    @objc func tapHandler(sender: UITapGestureRecognizer)
    {
        if(sender.view!.restorationIdentifier == "profile")
        {
            self.updatePicture = 1
        }
        else if(sender.view!.restorationIdentifier == "cover")
        {
            self.updatePicture = 2
        }
        self.handleImageChange()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage
        {
           
            self.updateUserImageInDB(image: image)
             self.setImage(image: image)
        }
        else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            self.updateUserImageInDB(image: image)
            self.setImage(image: image)
        }

        self.dismiss(animated: true, completion: nil)
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
    
    
    private func setImage(image: UIImage)
    {
        if(self.updatePicture == 1)
        {
            self.profilePictureImageView.image = image
        }
        else if(self.updatePicture == 2)
        {
            self.coverPictureImageView.image = image
        }
    }
    
    private func updateUserImageInDB(image: UIImage)
    {
        let storageRef = Storage.storage().reference()
        if let uploadData = UIImagePNGRepresentation(image)
        {
            if let uid = (Auth.auth().currentUser?.uid)
            {
                if self.updatePicture == 1
                {
                    storageRef.child("Users").child("Images").child(uid).child(NSUUID().uuidString).putData(uploadData, metadata: nil, completion: {
                        (metadata, error) in
                        if error != nil{
                            self.popUpError(data: (error?.localizedDescription)!)
                            return
                        }
                        if let url = metadata?.downloadURL()?.absoluteString
                        {
                            self.updateUserChildValue(values: ["profileImageURL" : url])
                        }
                       
                    })
                }
                else if self.updatePicture == 2
                {
                    storageRef.child("Users").child("Images").child(uid).child(NSUUID().uuidString).putData(uploadData, metadata: nil, completion: {
                        (metadata, error) in
                        if error != nil{
                            self.popUpError(data: (error?.localizedDescription)!)
                            return
                        }
                        if let url = metadata?.downloadURL()?.absoluteString
                        {
                            self.updateUserChildValue(values: ["coverImageURL" : url])
                        }
                    })
                }
            }
        }
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
    
    private func popUpError(data: String)
    {
        let alert = UIAlertController(title: "Error", message: data, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert,animated: true,completion: nil)
    }
    
    private func addTapGesture(v : UIImageView)
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapHandler(sender:)))
        v.addGestureRecognizer(tap)
    }
    private func handleImageChange()
    {
        if Auth.auth().currentUser != nil
        {
            let alert = UIAlertController(title: "ProjectLLC", message: "Get picture from?", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: {(action) in
                let image = UIImagePickerController()
                image.delegate = self
                image.sourceType = .camera
                image.allowsEditing = true
                self.present(image,animated: true)
                {
                    
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Photo Libary", style: UIAlertActionStyle.default, handler: {(action) in
                let image = UIImagePickerController()
                image.delegate = self
                image.sourceType = .photoLibrary
                image.allowsEditing = true
                self.present(image,animated: true)
                {
                    
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func initializeViewContents()
    {
        self.username.alpha = 0
        self.userInfoCollectionView.alpha = 0
        self.logoutButton.alpha = 0

    }
    
    private func fetchUserData()
    {
        if Auth.auth().currentUser?.uid != nil
        {
            Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: {
                (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    self.username.text = (dictionary["firstname"] as? String)! + " " + (dictionary["lastname"] as? String)!
                    if (dictionary["profileImageURL"] as? String) != ""
                    {
                        self.downloadAndSetImage(url: (dictionary["profileImageURL"] as? String)!, image: self.profilePictureImageView)
                        
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            self.animateViewContents()
                        }
                    }
                    if (dictionary["coverImageURL"] as? String) != ""
                    {
                        self.downloadAndSetImage(url: (dictionary["coverImageURL"] as? String)!, image: self.coverPictureImageView)
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            self.animateViewContents()
                        }
                    }
                    
                }

                
            })
        }
    }
    
    private func downloadAndSetImage(url: String, image: UIImageView)
    {
        if let url = URL(string: url)
        {
            URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
                if error != nil
                {
                    self.popUpError(data: (error?.localizedDescription)!)
                    return
                }
                DispatchQueue.main.async {
                    image.image = UIImage(data: data!)
                    self.animateViewContents()
                }
            }).resume()
        }
    }
    
    private func animateViewContents()
    {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.username.alpha = 1
            self.userInfoCollectionView.alpha = 1
            self.logoutButton.alpha = 1
        }, completion: nil)
    }
}
