//
//  UIViewExtensions.swift
//  ProjectLLC
//
//  Created by Pike on 4/12/18.
//  Copyright © 2018 Minh. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero)
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top,constant: padding.top).isActive = true
        }
        if let leading = leading {
             self.leadingAnchor.constraint(equalTo: leading,constant: padding.left).isActive = true
        }
        if let bottom = bottom {
             self.bottomAnchor.constraint(equalTo: bottom,constant: -padding.bottom).isActive = true
        }
        if let trailing = trailing {
             self.trailingAnchor.constraint(equalTo: trailing,constant: -padding.right).isActive = true
        }
    
        if size.width !=  0
        {
            self.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0
        {
            self.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func anchorCenter(x: NSLayoutXAxisAnchor?,y: NSLayoutYAxisAnchor?)
    {
         if let x = x {
            self.centerXAnchor.constraint(equalTo: x).isActive = true
        }
        if let y = y {
            self.centerYAnchor.constraint(equalTo: y).isActive = true
        }
    }
    
    func anchorWidthHeight(width: NSLayoutDimension?, height: NSLayoutDimension?)
    {
        if let width = width
        {
            self.widthAnchor.constraint(equalTo: width).isActive = true
        }
        if let height = height
        {
            self.heightAnchor.constraint(equalTo: height).isActive = true
        }
    }
    
    func anchorWidthHeight(width: CGFloat?, height: CGFloat?)
    {
        if let width = width
        {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height
        {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
