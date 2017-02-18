//
//  LoginViewController.swift
//  StatTracker-Basketball
//
//  Created by Ray Paragas on 18/2/17.
//  Copyright © 2017 Ray Paragas. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            print("We tried signing in and got")
            print("Using: \(self.emailTextField.text!)")
            if error != nil {
                print("Error")
            } else {
                print("Success !")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        })
    }
    

}
