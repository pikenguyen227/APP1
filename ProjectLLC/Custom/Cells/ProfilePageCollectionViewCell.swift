//
//  ProfilePageCollectionViewCell.swift
//  ProjectLLC
//
//  Created by Pike on 4/26/18.
//  Copyright © 2018 Minh. All rights reserved.
//

import UIKit
import Firebase

class ProfilePageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTextView: UITextView!
    
    public func fetchUserData(type: String)
    {
        if Auth.auth().currentUser?.uid != nil
        {
            Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: {
                (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    if (type == "Default")
                    {
                        self.cellImage.image = UIImage(named: (dictionary["gender"] as? String)! + "None.png")
                        self.cellTextView.text = "\nHeight:  " + (NSString(format: "%.1f", (dictionary["height"] as? Float)!) as String) + "ft" + "\n\nWeight: " + (NSString(format: "%.1f", (dictionary["weight"] as? Float)!) as String) + "lb"  + "\n\nAbout me:\n\n" + (dictionary["about"] as? String)!
                    }
                    else
                    {
                        self.cellImage.image = UIImage(named: "goal.png")
                        self.cellTextView.text = "\nMy Goals:\n\n" + (dictionary["goals"] as? String)!
                    }
                }
            })
        }
    }
}
