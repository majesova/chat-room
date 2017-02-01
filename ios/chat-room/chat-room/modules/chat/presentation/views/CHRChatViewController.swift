//
//  CHRChatViewController.swift
//  chat-room
//
//  Created by Plenumsoft on 31/01/17.
//  Copyright © 2017 com.majesova. All rights reserved.
//

import UIKit

class CHRChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var selectedUser : User?
    var cellHeight = 44
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var txtMessage: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.estimatedRowHeight = 88.0
        //tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        CHRPostInteractor.fillPosts(uid: CHRFirebaseManager.currentUser?.uid,
                                    toId: (selectedUser?.uid)!) { (result:String) in
                                        DispatchQueue.main.async {
                                            self.tableView.reloadData()
                                        }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        CHRPostInteractor.posts = []
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CHRPostInteractor.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! CHRChatTableViewCell
        let messageText = cell.messageText!
        messageText.delegate = self
        let post = CHRPostInteractor.posts[indexPath.row]
        cell.messageText.text = post.text
        return cell
    }
    
    @IBAction func postMessage(_ sender: Any) {
        
        //Solo verificando vacío por demostración
        if txtMessage.text! != "" {
            CHRPostInteractor.addPost(username: (selectedUser?.username)!,
                                      text: txtMessage.text!,
                                      toId: (selectedUser?.uid)!,
                                      fromId: ((CHRFirebaseManager.currentUser?.uid)!))
            txtMessage.text = ""
            
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CHRChatViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let currentOffset = tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        tableView.setContentOffset(currentOffset, animated: false)
    }
}

class CHRChatTableViewCell : UITableViewCell{

    
    @IBOutlet weak var messageText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
