//
//  CHRChooseSourceImage.swift
//  chat-room
//
//  Created by Plenumsoft on 01/02/17.
//  Copyright © 2017 com.majesova. All rights reserved.
//

import UIKit

class CHRChooseSourceImageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    var openCameraCallback : (()->Void)?
    var openAlbumCallback :(()-> Void)?
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func openCameraAction(_ sender: Any) {
       dismiss(animated: true, completion: nil)
        openCameraCallback!()
    }
    
    
    @IBAction func openAlbumAction(_ sender: Any) {
       
        dismiss(animated: true, completion: nil)
         openAlbumCallback!()
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
