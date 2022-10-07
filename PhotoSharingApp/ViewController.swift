//
//  ViewController.swift
//  PhotoSharingApp
//
//  Created by Hamza Oban on 1.10.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var sifreTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func kayitOlOnClick(_ sender: Any) {
        performSegue(withIdentifier: "toFeedVC", sender: nil)
    }
    
    @IBAction func girisYapOnClick(_ sender: Any) {
    }
}

