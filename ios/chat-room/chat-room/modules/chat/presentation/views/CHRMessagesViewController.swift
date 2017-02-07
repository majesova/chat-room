//
//  CHRMessagesViewController.swift
//  chat-room
//
//  Created by Plenumsoft on 01/02/17.
//  Copyright © 2017 com.majesova. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SDWebImage

class CHRMessagesViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    static var channelOpened = false
    
    var imagePicker : UIImagePickerController!
    
    var messageInteractor = CHRMessageInteractor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 88.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate  = self
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
        messageInteractor.fillMessages(uid: CHRFirebaseManager.currentUserId) { (result) in
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
                let lastIndex = IndexPath(item: self.messageInteractor.messages.count - 1  , section: 0)
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
        messageInteractor.sendMessage(username: username,
                                         text: self.txtMessage.text!,
                                         from: (CHRFirebaseManager.currentUser?.uid)!)
        
        txtMessage.text = ""
    }
    
    @IBAction func btnAddImageAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Cargar imagen", message: "Escoja una imagen", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Imagen desde carrete", style: .default, handler: { (action) in
            
            self.openAlbumForSelection()
        }))
        alert.addAction(UIAlertAction(title: "Imagen desde cámara", style: .default, handler: { (action) in
            self.openCamaraForSelection()
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: { (action) in
            
        }))
        self.present(alert, animated: true) {
            //code to execute once the alert is showing
            //self.alertShown = true
        }
    }
    
    @IBAction func btnSalirAction(_ sender: Any) {
        CHRMessagesViewController.channelOpened = false
        dismiss(animated: true, completion: nil)
    }
    
    func openAlbumForSelection() {
        if UIImagePickerController.isSourceTypeAvailable( UIImagePickerControllerSourceType.camera) {
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openCamaraForSelection() {
        if UIImagePickerController.isSourceTypeAvailable( UIImagePickerControllerSourceType.camera) {
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageInteractor.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let message = messageInteractor.messages[indexPath.row]
        if message.imageUrl == "" {
            //print("Con imagen")
            let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell")
            cell?.textLabel?.text = message.text!
            cell?.detailTextLabel?.text = message.username!
            return cell!
        }else{
            //print("Sin imagen")
            let cell = tableView.dequeueReusableCell(withIdentifier: "messageCellImage")
            let imageView = cell?.viewWithTag(100) as! UIImageView
            let label = cell?.viewWithTag(200) as! UILabel
            imageView.sd_setImage(with: URL(string: message.imageUrl!))
            label.text  = message.username!
            
            /*if let url = NSURL(string: message.imageUrl!){
                if let data = NSData(contentsOf: url as URL){
                    imageView.image = UIImage(data: data as Data)!                }
            }*/
            cell?.textLabel?.text = message.text!
            cell?.detailTextLabel?.text = message.username!
            return cell!
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = messageInteractor.messages[indexPath.row]
        if message.imageUrl != "" {
            return 100
        }
        return 75
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
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let username = CHRProfileInteractor.getCurrentUser(uid: CHRFirebaseManager.currentUserId)!.username
        messageInteractor.sendMessageWithImage(username: username,
                                               text: self.txtMessage.text!,
                                               from: (CHRFirebaseManager.currentUser?.uid)!, image: chosenImage)
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
