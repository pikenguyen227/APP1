//
//  CollectionViewProfilePage.swift
//  ProjectLLC
//
//  Created by Pike on 4/26/18.
//  Copyright © 2018 Minh. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewProfilePage: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    @IBOutlet weak var collectionView: UICollectionView!
    private var currentPage = 1
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.currentPage == 1
        {
            if self.collectionView.contentOffset.x > 0
            {
                self.currentPage = 2
            }
        }
        else
        {
            if self.collectionView.contentOffset.x == 0
            {
                self.currentPage = 1
            }
        }
        
    }
    
    let array:[String] = ["Default", "Goals"]
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileInformationCell", for: indexPath) as! ProfilePageCollectionViewCell
        cell.fetchUserData(type: array[indexPath.row])
        
        return cell;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.row == 0)
        {
            self.parent?.performSegue(withIdentifier: "editInfo", sender: self.parent)
        }
        else if(indexPath.row == 1)
        {
            self.parent?.performSegue(withIdentifier: "editGoals", sender: self.parent)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    
        coordinator.animate(alongsideTransition: {
            _ in
            
            if self.currentPage == 1
            {
                self.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            }
            else
            {
                self.collectionView.setContentOffset(CGPoint(x: self.view.frame.width, y: 0), animated: false)
            }
            self.collectionView.reloadData()
        }, completion: nil)
    }

   
}
