//
//  WelcomeViewController.swift
//  Flash Chat
//
//  This is the welcome view controller - the first thign the user sees
//

import UIKit
import Firebase
import GoogleSignIn
import SVProgressHUD
import os.log
import ProgressHUD

class WelcomeViewController: UIViewController,GIDSignInDelegate,GIDSignInUIDelegate {
    
    @IBOutlet weak var googleButton: GIDSignInButton!
    var log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "system")
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().clientID = "132001957215-qhvl0kde2non8u1cj0jpghlopkcqbuit.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        googleButton.colorScheme = .dark
        googleButton.style = .wide
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            os_log("Google Sign in Failed:",log:log)
            let alert = UIAlertController(title: "Failed", message: "Sign in Failed", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert,animated: true,completion: nil)
            return
        } else {
            guard let authentication = user.authentication else {return}
            let cred = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            SVProgressHUD.show()
            Auth.auth().signIn(with: cred) { (user, err) in
                if err != nil{
                    print("Error: \(err)")
                    SVProgressHUD.dismiss()
                }else{
                    let user = Auth.auth().currentUser!
                    os_log("Google Sign in Success:",log:self.log)
                    SVProgressHUD.dismiss()
                    ProgressHUD.showSuccess("Welcome \(user.displayName!)")
                    self.printDetails(user:user)
                    self.performSegue(withIdentifier: "goToChat", sender: self)
                }
            }
        }
    }
    
    //Get User Details from Google
    private func printDetails(user: User){
        
        if user != nil{
            let uid = user.uid
            let email = user.email
            let fullName = user.displayName
            
            print("User ID: \(uid), Email: \(String(email!)), fullNAme = \(String(fullName!))")
        }
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
    }
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
}
