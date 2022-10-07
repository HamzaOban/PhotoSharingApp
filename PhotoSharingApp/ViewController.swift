//
//  ViewController.swift
//  PhotoSharingApp
//
//  Created by Hamza Oban on 1.10.2022.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var sifreTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func login(_ sender: Any) {
    }
    
    @IBAction func register(_ sender: Any) {
        if sifreTextField.text != "" && emailTextField.text != "" {
            //registration procedures
            //asnyc
            Auth.auth().createUser(withEmail: emailTextField.text!, password: sifreTextField.text!) { authdataresult, error in
                if error != nil{
                    self.errorMessage(titleInput: "Error!", messageInput: error?.localizedDescription ?? "You got an error, try again")
                }
                else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }
        else{
            //Error message
            errorMessage(titleInput: "Error", messageInput: "Enter username and password.")
        }
    }
   

    func errorMessage(titleInput : String, messageInput : String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default,handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true,completion: nil)
    }
}

