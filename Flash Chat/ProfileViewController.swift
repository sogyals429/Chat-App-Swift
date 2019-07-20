//
//  ProfileViewController.swift
//  Flash Chat
//
//  Created by Sogyal Thundup Sherpa on 15/7/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class ProfileViewController: UIViewController {
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var pointsLabel: UILabel!
    @IBOutlet var emailTxtLabel: UILabel!
    @IBOutlet var pointsTxtLabel: UILabel!
    
    @IBOutlet var bannerView: GADBannerView!
    var interstitial: GADInterstitial!

    
    let user = Auth.auth().currentUser!
    override func viewDidLoad() {
        super.viewDidLoad()
//        bannerView.adUnitID = "ca-app-pub-2972234919483485/7078595935"
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        updateUI()
    }
    
    
    
    func updateUI(){
        if(user.displayName != nil || user.photoURL != nil){
            self.navigationItem.title = (user.displayName!) + "'s profile"
            profileImage.dowloadFromServer(link: "\(user.photoURL!)", contentMode: .scaleAspectFill)
        }else{
            self.navigationItem.title = user.email! + "'s profile"
            profileImage.dowloadFromServer(link: "https://image.flaticon.com/icons/png/512/97/97895.png")
        }
        
        emailTxtLabel.text = user.email!
        pointsTxtLabel.text = "\(300)"
        profileImage.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: 100, height: 100))
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        
      
    }
    
    
    /////////////////////
    //MARK:- Google Ads
    
}





/////////////////////

//MARK:- UIImageView Extension for downlading image
extension UIImageView {
    func dowloadFromServer(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    
    func dowloadFromServer(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        dowloadFromServer(url: url, contentMode: mode)
    }
}
