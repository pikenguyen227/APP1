//
//  dropDownView.swift
//  ProjectLLC
//
//  Created by Pike on 4/13/18.
//  Copyright © 2018 Minh. All rights reserved.
//

import Foundation
import UIKit

class dropDownView: UIView, UITableViewDelegate, UITableViewDataSource
{
    var dropDownOptions = [String]()
    
    var tableView = UITableView()
    var delegate: dropDownProtocol!
    
    private var currentLanguage : String!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.addSubview(tableView)
        self.tableView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        self.tableView.backgroundColor = defaultVariables.dropDownBackgroundColor
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .white
        cell.backgroundColor = defaultVariables.dropDownCellBackgroundColor
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.darkGray
        cell.selectedBackgroundView = bgColorView
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        tableView.selectRow(at: NSIndexPath(row: 0, section: 0) as IndexPath, animated: false, scrollPosition: UITableViewScrollPosition.none)
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.dropDownClicked(s: dropDownOptions[indexPath.row])
        /* for debuging */
        if (indexPath.row == 0)
        {
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "choose_user1"), object: nil)
        }
        else
        {
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "choose_user2"), object: nil)
        }
    }
    
    
    
    
}
