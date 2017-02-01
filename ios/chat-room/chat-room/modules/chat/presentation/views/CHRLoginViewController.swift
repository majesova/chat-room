//
//  LoginViewController.swift
//  chat-room
//
//  Created by Plenumsoft on 31/01/17.
//  Copyright © 2017 com.majesova. All rights reserved.
//

import UIKit

class CHRLoginViewController: UIViewController {

    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButton_click(_ sender: Any) {
        //let email = "majesova@gmail.com"
        //let pass = "2perros"
        CHRFirebaseManager.Login(email: txtEmail.text!, password: txtPassword.text!) { (success: Bool) in
            if success {
                  self.performSegue(withIdentifier: "showProfile", sender: sender)
            }
        }
    }

    @IBAction func createAccountButton_Click(_ sender: Any) {
        CHRFirebaseManager.CreateAccount(email: txtEmail.text!, password: txtPassword.text!, username: txtUsername.text!){
            (result:String) in
            DispatchQueue.main.async{
                self.performSegue(withIdentifier: "showProfile", sender: sender)
            }
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
