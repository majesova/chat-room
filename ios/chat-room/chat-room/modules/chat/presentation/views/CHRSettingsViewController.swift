//
//  CHRSettingsViewController.swift
//  chat-room
//
//  Created by Plenumsoft on 31/01/17.
//  Copyright © 2017 com.majesova. All rights reserved.
//

import UIKit

class CHRSettingsViewController: UIViewController, UIPopoverPresentationControllerDelegate, UIImagePickerControllerDelegate , UINavigationControllerDelegate{

    var selectedUser : User?
    
    var imagePicker : UIImagePickerController!
    
    var imageSelected : UIImage?
    
    var workingMessage = PLWorkingMessageBuilder()
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    
    @IBAction func TakePictureAction(_ sender: Any) {
        
        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "chooseSourceImage") as! CHRChooseSourceImageViewController
        popoverContent.openAlbumCallback = self.openAlbumForSelection
        popoverContent.openCameraCallback = self.openCamaraForSelection
        popoverContent.modalPresentationStyle = .popover
        popoverContent.preferredContentSize = CGSize(width: 200, height: 200)
        
        
        let popoverPresentationViewController = popoverContent.popoverPresentationController
        popoverPresentationViewController?.permittedArrowDirections = UIPopoverArrowDirection.any
        
        let button = sender as! UIButton
        popoverPresentationViewController?.sourceView = button
        popoverPresentationViewController?.sourceRect = button.bounds
        popoverPresentationViewController?.delegate = self
        
        self.present(popoverContent, animated: true, completion: nil)
    }
   
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    @IBAction func btnUpdatePictureAction(_ sender: Any) {
        if imageSelected != nil {
            let indicator = workingMessage.showModalSpinnerIndicator(view: self.view)
            selectedUser?.uploadProfilePhoto(profileImage: imageSelected!, callback: {
                self.workingMessage.hideModalSpinnerIndicator(indicator: indicator)
            })
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedUser !=  nil{
            if selectedUser?.profileImageUrl != "" {
                imageView.image = selectedUser?.getProfileImage()
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        imageView.contentMode = .scaleAspectFit
        imageView.image = chosenImage //4
        imageSelected = chosenImage
        picker.dismiss(animated:true, completion: nil) //5
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
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
