//
//  dropDownButton.swift
//  ProjectLLC
//
//  Created by Pike on 4/13/18.
//  Copyright © 2018 Minh. All rights reserved.
//

import Foundation
import UIKit

class dropDownButton: UIButton, dropDownProtocol
{
    
    func dropDownClicked(s: String) {
        self.setTitle(s, for: .normal)
        self.collapse()
    }
    
    
    var dropView: dropDownView!
    private var height = NSLayoutConstraint()
    private var isOpen = false
    private var currentLanguage:String!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.dropView  = dropDownView.init(frame: .init(x: 0, y: 0, width: 0, height: 0))
        self.dropView.backgroundColor = defaultVariables.dropDownBackgroundColor
        self.dropView.delegate = self
    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropView)
        self.superview?.bringSubview(toFront: dropView)
        self.dropView.anchor(top: self.bottomAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        self.dropView.anchorCenter(x: self.centerXAnchor, y: nil)
        self.dropView.anchorWidthHeight(width: self.widthAnchor, height: nil)
        self.height =  self.dropView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([self.height])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !self.isOpen
        {
            expand()
            currentLanguage = self.titleLabel?.text
            self.setTitle("Cancel", for: .normal)
        }
        else
        {
            collapse()
            self.setTitle(currentLanguage, for: .normal)
        }
    }
    
    func expand()
    {
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = CGFloat(50 * defaultVariables.numberOfDropDownItem)
        NSLayoutConstraint.activate([self.height])
        self.isOpen = true
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.dropView.layoutIfNeeded()
            self.dropView.center.y += (self.dropView.frame.height/2)
        }, completion: nil)
        
        
        self.superview?.viewWithTag(10000)?.alpha = 0
        
    }
    func collapse()
    {
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        self.isOpen = false
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.dropView.center.y -= (self.dropView.frame.height/2)
            self.dropView.layoutIfNeeded()
        }, completion: nil)
        
       
        self.superview?.viewWithTag(10000)?.alpha = 1
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
