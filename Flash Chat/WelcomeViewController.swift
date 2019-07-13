//
//  WelcomeViewController.swift
//  Flash Chat
//
//  This is the welcome view controller - the first thign the user sees
//

import UIKit
import Firebase
import GoogleSignIn


class WelcomeViewController: UIViewController,GIDSignInUIDelegate {

   
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func gSignInButton(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signIn()
    }
}
