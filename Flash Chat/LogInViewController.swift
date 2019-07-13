//
//  LogInViewController.swift
//  Flash Chat
//
//  This is the view controller where users login


import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func logInPressed(_ sender: AnyObject) {
        let email = emailTextfield.text!
        let pass = passwordTextfield.text!
        
        //TODO: Log in the user
        Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
            if error != nil{
                let alert = UIAlertController(title: "Error", message: "Invalid Username/Password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                self.present(alert,animated: true,completion: nil)
            }else{
                print("Sign in Success")
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }
    }
}  
