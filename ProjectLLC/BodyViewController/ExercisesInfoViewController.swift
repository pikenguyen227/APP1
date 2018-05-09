
//
//  exercisesInfoViewController.swift
//  ProjectLLC
//
//  Created by Pike on 4/27/18.
//  Copyright © 2018 Minh. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


class ExercisesInfoViewController:UIViewController
{
    /*
    let playButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "play.png"), for: UIControlState.normal)
        
        button.addTarget(self, action: #selector(playIsClicked), for: UIControlEvents.touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()
    */
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    @IBOutlet weak var thumbnailVideoImageView: UIImageView!
    
    private var URL:String!
    private var isPlaying: Bool!
    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?
    private var backupImage: UIImage!
    
    @IBOutlet weak var viewBoundsForLandscape: UIView!
    @IBOutlet weak var infoAndPlayList: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializingComponents()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadVideo(notification:)), name: NSNotification.Name(rawValue: "Display_Video"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.clean(notification:)), name: NSNotification.Name(rawValue: "Remove_Video_Thumb"), object: nil)
      
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        thumbnailVideoImageView.addGestureRecognizer(tapGestureRecognizer)
        
        self.isPlaying = false
        
        
    }
    
    public func initializingComponents()
    {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
       
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (context) in
            self.playerLayer?.frame = self.thumbnailVideoImageView.layer.frame
            self.playerLayer?.position = CGPoint(x: self.thumbnailVideoImageView.frame.width / 2 , y: self.thumbnailVideoImageView.frame.height / 2)
        }, completion: nil)
        
    }

    @objc func loadVideo(notification: NSNotification)
    {
        if let dict = notification.userInfo as NSDictionary? {
            if let playImage = dict["image"] as? UIImage{
                self.backupImage = playImage
            }
            if let u = dict["url"] as? String{
               self.URL = u
            }
     
            self.player?.pause()
            self.playerLayer?.removeFromSuperlayer()
            self.player = AVPlayer(url: NSURL(string: self.URL)! as URL)
            self.playerLayer = AVPlayerLayer(player: player)
            self.isPlaying = false
           
            self.playerLayer?.frame = self.thumbnailVideoImageView.layer.frame
            self.playerLayer?.position = CGPoint(x: self.thumbnailVideoImageView.frame.width / 2 , y: self.thumbnailVideoImageView.frame.height / 2)
            self.playerLayer?.videoGravity = AVLayerVideoGravity.resize
            self.thumbnailVideoImageView.layer.addSublayer(playerLayer!)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Stop_AI"), object: nil)
      
          //  self.activityIndicatorView.bounds = self.thumbnailVideoImageView.layer.bounds
            //self.activityIndicatorView.layer.position = self.thumbnailVideoImageView.center
 
          //  self.thumbnailVideoImageView.addSubview(self.activityIndicatorView)
       /*
            self.activityIndicatorView.centerXAnchor.constraint(equalTo: self.thumbnailVideoImageView.centerXAnchor).isActive = true
            self.activityIndicatorView.centerYAnchor.constraint(equalTo: self.thumbnailVideoImageView.centerYAnchor).isActive = true
            self.activityIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
            self.activityIndicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true*/
        }
    }
    
    @objc func clean(notification: NSNotification)
    {
        self.player?.pause()
        self.playerLayer?.removeFromSuperlayer()
        self.thumbnailVideoImageView.image = nil
        self.isPlaying = false
    //    self.activityIndicatorView.stopAnimating()
    }

    @objc private func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if !self.isPlaying
        {
            player?.play()
            self.isPlaying = true
       //     self.activityIndicatorView.startAnimating()
     //       self.activityIndicatorView.isHidden = true
        }
        else
        {
            player?.pause()
            self.isPlaying = false
           // self.activityIndicatorView.isHidden = false
        }
    }
    
    private func popUpError(data: String)
    {
        let alert = UIAlertController(title: "Error", message: data, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert,animated: true,completion: nil)
    }
}
