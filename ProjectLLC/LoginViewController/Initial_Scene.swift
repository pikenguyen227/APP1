//
//  ViewController.swift
//  ProjectLLC
//
//  Created by Pike on 4/12/18.
//  Copyright © 2018 Minh. All rights reserved.
//

import UIKit
import Firebase

class Initial_Scene: UIViewController {

    @IBOutlet weak var appLogoUIImage: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.setupScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    private func setupScreen()
    {
        self.appLogoUIImage.image = defaultVariables.appLogoImage
        self.view.backgroundColor = defaultVariables.backgroundColor
 
    }
    
    /*
     * Preventing status to be hidden in landscape mode for Iphone.
     */
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    /*
     * Dismissing Keyboard.
     */
    @objc private func dismissKeyboard()
    {
        self.view.endEditing(true)
    }

}

