//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import Firebase


class RegisterViewController: UIViewController {

    
    //Pre-linked IBOutlets

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
    @IBAction func registerPressed(_ sender: AnyObject) {
        

        FIRAuth.auth()?.createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!, completion: { (user, error) in
            
            if error != nil {
                print(error!)
            } else {
                print("Registration Succesful")
                let userDB = FIRDatabase.database().reference().child("Users")
                let userDirectory = ["User":FIRAuth.auth()?.currentUser?.email, "Name":"Jon Snow"]
                userDB.childByAutoId().setValue(userDirectory) {
                    (error, reference) in
                    if error != nil {
                        print(error!)
                    } else {
                        print("User addedd succesfully")
                        
                        self.performSegue(withIdentifier: "goToChat", sender: self)
                    }//else
                    
                }//userDB
            }//else
            
        })//
        
        
        

        
        
    }//registerPressed
    
    
}
