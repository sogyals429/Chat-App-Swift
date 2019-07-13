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
        let email = emailTextfield.text!
        let pass = passwordTextfield.text!
        
        if(validateDetails(email: email, password: pass)){
            //TODO: Set up a new user on our Firbase database
            Auth.auth().createUser(withEmail: email, password: pass) { (user, err) in
                if err != nil{
                    print(err!)
                }else{
                    //success
                    print("Registration Success")
                    self.performSegue(withIdentifier: "goToChat", sender: self)
                }
            }
        }
    }
    
    private func validateDetails(email:String,password:String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format: "Self Matches %@", emailRegEx)
        
        let passRegex = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
        let passPred = NSPredicate(format: "Self Matches %@", passRegex)
        
        return emailPred.evaluate(with: email) && passPred.evaluate(with: password)
    }

}
