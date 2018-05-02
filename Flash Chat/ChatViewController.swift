//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
var messageArray:[Message] = [Message]()
    
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.register(UINib(nibName:"MessageCell", bundle:nil), forCellReuseIdentifier: "customMessageCell")
        configureTableView()
        
        
        messageTextfield.delegate = self
        retriveMessages()
        
        //Experimenting with Tap gesture
        view.addGestureRecognizer(UITapGestureRecognizer(target:self,action:#selector(tapGestureSent)))
       
        
    }//load
    
    
    @objc func tapGestureSent() {
        let chatLogController = ChatLogController()
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        
        
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        return cell
    }
    
    
    func configureTableView() {
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 1) {
            self.heightConstraint.constant = 328
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 1) {
            self.heightConstraint.constant = 258
            self.view.layoutIfNeeded()
        }
    }
    

    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        
        messageTextfield.endEditing(true)
        UIView.animate(withDuration: 1) {
            self.heightConstraint.constant = 258
            self.view.layoutIfNeeded()
        }
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        let messageDB = FIRDatabase.database().reference().child("Messages")
        
        let messageDictionary = ["Sender":FIRAuth.auth()?.currentUser?.email, "MessageBody":messageTextfield.text!]
        
        messageDB.childByAutoId().setValue(messageDictionary) {
            (error, reference) in
            if error != nil {
                print(error)
            } else {
                print("Message saved succesfully")
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
            }
            
        }
        
    }//sendPressed
    
    func retriveMessages() {
        let messageDB = FIRDatabase.database().reference().child("Messages")
        messageDB.observe(.childAdded) { (snapshot) in
            let snapValue = snapshot.value as! Dictionary<String, String>
            let text = snapValue["MessageBody"]!
            let sender = snapValue["Sender"]!
            
            let message = Message()
            message.messageBody = text
            message.sender = sender
            
            self.messageArray.append(message)
            self.configureTableView()
            self.messageTableView.reloadData()
            
        }//observe
    }//retriveMessages
    
    

    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        do {
            try FIRAuth.auth()?.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let error {
            print(error)
        }
    }//logOut
    


}
