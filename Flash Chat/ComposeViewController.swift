//
//  ComposeViewController.swift
//  Flash Chat
//
//  Created by Raman Singh on 2018-05-02.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import Firebase


class ComposeViewController: UIViewController {
@IBOutlet var tableView: UITableView!
    var usersArray = [String]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
        
    }//load
    
    
    func fetchUsers() {
        let usersDB = FIRDatabase.database().reference().child("Users")
        usersDB.observe(.childAdded) { (snapshot) in
            let snapValue = snapshot.value as! Dictionary<String, String>
            print(snapValue.count)
            
            for name in snapValue {
                
                var thisUser = User()
                thisUser.name = snapValue["Name"]!
                thisUser.email = snapValue["User"]!
                
                if (!self.usersArray.contains(snapValue["Name"]!)) {
                    
                    self.usersArray.append(snapValue["Name"]!)
                    self.users.append(thisUser)
                }
            }
            print(self.usersArray.count)
            self.tableView.reloadData()
            
            
            
            
            
        }//observe
    }//fetchUsers
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = users[indexPath.row].name
        
        return cell
    }
    

}//end
