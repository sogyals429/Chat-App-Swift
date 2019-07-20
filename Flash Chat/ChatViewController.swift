//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework
import ProgressHUD

class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    // Declare instance variables here
    var messageArray : [Message] = [Message]()
    lazy var refreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    @IBOutlet var profileBarBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        //TODO: Set yourself as the delegate of the text field here:
        messageTextfield.delegate = self
        
        messageTableView.addSubview(self.refreshControl)
        //TODO: Set the tapGesture here:
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        
        messageTableView.addGestureRecognizer(tapGesture)
        
        //TODO: Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        configureTableView()
        retrieveMessages()
        
        messageTableView.separatorStyle = .none
        messageTableView.allowsSelection = false
        self.navigationItem.setHidesBackButton(true, animated: true)
        
//        profileBarBtn.setBackgroundImage(<#T##backgroundImage: UIImage?##UIImage?#>, for: <#T##UIControl.State#>, barMetrics: <#T##UIBarMetrics#>)
//        profileBarBtn = UIBarButtonItem(image: UIImage(named: "user"), style: .plain, target: self, action: nil)
        
    }
    
    ///////////////////////////////////////////
    
    //MARK: - Navigation Bar
    @IBAction func profileBtnClicked(_ sender: UIBarButtonItem) {
//        performSegue(withIdentifier: "goToProfile", sender: self)
    }
    
    
    
    
    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.setImage(UIImage(named: "egg"), for: .normal)
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String? {
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        }else{
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        return cell
    }
    
    
    
    //TODO: Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    
    //TODO: Declare tableViewTapped here:
    @objc private func tableViewTapped(){
        messageTextfield.endEditing(true)
    }
    
    
    //TODO: Declare configureTableView here:
    func configureTableView(){
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120.0
        
    }
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    
    
    
    //TODO: Declare textFieldDidBeginEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    
    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        //TODO: Send the message to Firebase and save it in our database
        tableViewTapped()
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        let messagesDb = Database.database().reference().child("Messages")
        
        let messageDictionary = ["Sender":Auth.auth().currentUser?.email, "Message Body":messageTextfield.text!]
        
        messagesDb.childByAutoId().setValue(messageDictionary){
            (error,ref) in
            if error != nil{
                print(error!)
            }else{
                print("Message Sent")
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = "" 
            }
        }
        
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        messageTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    //TODO: Create the retrieveMessages method here:
    
    func retrieveMessages(){
        
        let messageDB = Database.database().reference().child("Messages")
        
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let text = snapshotValue["Message Body"]!
            let sender = snapshotValue["Sender"]!
            
            let message = Message()
            message.messageBody = text
            message.sender = sender
            
            self.messageArray.append(message)
            self.configureTableView()
            self.messageTableView.reloadData()
        }
        
    }
    
    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        let user = Auth.auth().currentUser?.providerData[0]
        
        if(user?.providerID != nil){
            Auth.auth().currentUser?.unlink(fromProvider: user!.providerID, completion: { (user, err) in
                if err != nil{
                    print(err!)
                }else{
                    print("Account Unlinked")
                    ProgressHUD.showSuccess()
                    self.navigationController?.popToRootViewController(animated: true)
                }
            })
        }else{
            let auth = Auth.auth()
            //TODO: Log out the user and send them back to WelcomeViewController
            do {
                try auth.signOut()
                navigationController?.popToRootViewController(animated: true)
            } catch let err as NSError {
                print("Error signing out: %@", err)
            }
        }
    }
    
}
