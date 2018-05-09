//
//  UIViewControllerExtensions.swift
//  ProjectLLC
//
//  Created by Pike on 4/27/18.
//  Copyright © 2018 Minh. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    @objc func swipeActionOnBodyView(swipe: UISwipeGestureRecognizer)
    {
        switch swipe.direction.rawValue {
            /*
        case 1:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
                self.view.viewWithTag(0)?.alpha = 1
                self.view.viewWithTag(1)?.alpha = 0
            }, completion: nil)
 */
        case 2:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
                self.view.alpha = 0
                
            }, completion: nil)
        default:
            break
        }
    }
}
