//
//  ContentsBelowVideoTableView.swift
//  ProjectLLC
//
//  Created by Pike on 4/28/18.
//  Copyright © 2018 Minh. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

struct aCell {
    var cell : Int!
    var name : String!
    var rating: String!
    var description : String!
    var URL : String!
}

class ContentsBelowVideoTableView : UITableViewController
{
    var arrayOfCell = [aCell]()
    private var exercisesList = [Exercise]()
    private var imageList = [UIImage]()
    public var selectedCell: Int!
    public var selectedCellImage: UIImage!
    private var firstCellIndexPath: IndexPath!
    private var secondCellIndexPath: IndexPath!
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cleanUpTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(self.clean(notification:)), name: NSNotification.Name(rawValue: "Clean_Up"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.parse(notification:)), name: NSNotification.Name(rawValue: "Parsing_JSON"), object: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCell.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrayOfCell[indexPath.row].cell == 0
        {
            let cell = Bundle.main.loadNibNamed("TableViewCellType1", owner: self, options: nil)?.first as! TableViewCellType1
            cell.contentView.backgroundColor = UIColor.clear
            if arrayOfCell.count > 2
            {
                if selectedCell == nil
                {
                    selectedCell = 2
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Display_Video"), object: nil, userInfo:  ["image": self.imageList[0], "url" : self.exercisesList[0].URL])
                }
                cell.name.text =  arrayOfCell[selectedCell].name
                cell.rating.text = "Rating: " + arrayOfCell[selectedCell].rating
            }
            self.firstCellIndexPath = indexPath
            return cell
        }
        else  if arrayOfCell[indexPath.row].cell == 1
        {
            let cell = Bundle.main.loadNibNamed("TableViewCellType2", owner: self, options: nil)?.first as! TableViewCellType2
            cell.contentView.backgroundColor = UIColor.clear
           
            if arrayOfCell.count > 2
            {
                if selectedCell == nil
                {
                    selectedCell = 2
                }
                cell.descriptionDataTextView.text = arrayOfCell[selectedCell].description
            }
            self.secondCellIndexPath = indexPath
            return cell
        }
        else
        {
            let cell = Bundle.main.loadNibNamed("TableViewCellType3", owner: self, options: nil)?.first as! TableViewCellType3
            cell.contentView.backgroundColor = UIColor.clear
            cell.exerciseName.text = arrayOfCell[indexPath.row].name
            cell.exerciseRating.text = "Rating: " + arrayOfCell[indexPath.row].rating
            cell.exerciseThumbnail.image = imageList[indexPath.row - 2]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 && indexPath.row != 1
        {
            DispatchQueue.main.async {
                self.selectedCell = indexPath.row
                self.tableView.deselectRow(at: indexPath, animated: true)
                 self.tableView.setContentOffset(CGPoint(x: 0, y: self.tableView.rectForRow(at: self.firstCellIndexPath).height + self.tableView.rectForRow(at: self.secondCellIndexPath).height), animated: false)
         
                UIView.animate(withDuration: 0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.tableView.alpha = 0
                   
                }, completion: {(action) in
                    self.tableView.setContentOffset(CGPoint(x: 0, y:0), animated: false)
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.tableView.alpha = 1
                    })})
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Display_Video"), object: nil, userInfo: ["image": self.imageList[indexPath.row - 2], "url" : self.exercisesList[indexPath.row - 2].URL])
            }
        }
    }
    
    @objc private func clean(notification: Notification)
    {
        self.cleanUpTableView()
    }
    
    @objc private func parse(notification: Notification)
    {
        if let dict = notification.userInfo as NSDictionary? {
            if let id = dict["id"] as? Int{
                parseJson(type: id)
            }
        }
    }
    
    private func parseJson(type: Int)
    {
        let jsonURLString = "https://firebasestorage.googleapis.com/v0/b/testserver-45f46.appspot.com/o/System%2FExercises%2Fexercises.json?alt=media&token=c26172ed-2fac-4bb5-9625-eec03d70f856"
        URLSession.shared.dataTask(with: URL(string: jsonURLString)!, completionHandler: {(data,response,err) in
            guard let data = data else {return}
            print(data)
            
            do {
                let ex = try JSONDecoder().decode([Exercise].self, from: data)
                for item in ex
                {
                    if item.type == type
                    {
                        self.exercisesList.append(item)
                        self.arrayOfCell.append(aCell(cell: 3, name: item.name, rating: NSString(format: "%.1f", item.rating) as String?, description: item.description, URL: item.URL))
                    }
                }
                DispatchQueue.main.async {
                    if self.exercisesList.count != 0
                    {
                        for item in self.exercisesList
                        {
                            self.imageList.append(self.thumbnailImageForFileUrl(fileUrl: URL(string: item.URL)!)!)
                        }
                        self.tableView.reloadData()
                    }
                    else
                    {
                        (self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TableViewCellType1).name.text = "Eror 404"
                        (self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! TableViewCellType2).descriptionDataTextView.text = "Files Not Found"
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Stop_AI"), object: nil)
                    }
                }
            } catch let jsonErr{
                print(jsonErr)
            }
        }).resume()
    }
    
    public func cleanUpTableView()
    {
        self.arrayOfCell.removeAll()
        self.arrayOfCell = [aCell(cell: 0, name: "", rating: "", description: "", URL: ""), aCell(cell: 1, name: "", rating: "", description: "", URL: "")]
        self.exercisesList.removeAll()
        self.imageList.removeAll()
        self.selectedCell = nil
        self.tableView.reloadData()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Remove_Video_Thumb"), object: nil)
    }
    
    private func popUpError(data: String)
    {
        let alert = UIAlertController(title: "Error", message: data, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert,animated: true,completion: nil)
    }
    
    private func thumbnailImageForFileUrl(fileUrl: URL) -> UIImage?
    {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        }
        catch let err {
            self.popUpError(data: err.localizedDescription)
        }
        return nil
    }
    
}
