//
//  CHRMessagesViewController.swift
//  chat-room
//
//  Created by Plenumsoft on 01/02/17.
//  Copyright © 2017 com.majesova. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class CHRMessagesViewController: UIViewController, UITableViewDataSource {
    static var channelOpened = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var txtMessage: UITextField!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        if CHRMessagesViewController.channelOpened == false {
        CHRMessageInteractor.fillMessages(uid: CHRFirebaseManager.currentUserId) { (result) in
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
                let lastIndex = IndexPath(item: CHRMessageInteractor.messages.count - 1  , section: 0)
                self.tableView?.scrollToRow(at: lastIndex, at: UITableViewScrollPosition.none, animated: true)
            }
            
        }
        }
        CHRMessagesViewController.channelOpened = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //CHRMessageInteractor.messages = []
    }
    
    @IBAction func btnEnviarAction(_ sender: Any) {
        if txtMessage.text == "" {
            return
        }
        let username = CHRProfileInteractor.getCurrentUser(uid: CHRFirebaseManager.currentUserId)!.username
        CHRMessageInteractor.sendMessage(username: username,
                                         text: self.txtMessage.text!,
                                         from: (CHRFirebaseManager.currentUser?.uid)!)
        txtMessage.text = ""
     
    }
    
    
    @IBAction func btnSalirAction(_ sender: Any) {
        CHRMessagesViewController.channelOpened = false
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CHRMessageInteractor.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell")
        let message = CHRMessageInteractor.messages[indexPath.row]
        cell?.textLabel?.text = message.text!
        cell?.detailTextLabel?.text = message.username!
        return cell!
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showSettings" {
            
            let viewController = segue.destination as! CHRSettingsViewController
            viewController.selectedUser = CHRProfileInteractor.getCurrentUser(uid: CHRFirebaseManager.currentUserId)
        }
    }


}


extension CHRMessagesViewController:UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let currentOffset = tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        tableView.setContentOffset(currentOffset, animated: false)
    }
}
