//
//  UploadViewController.swift
//  PhotoSharingApp
//
//  Created by Hamza Oban on 2.10.2022.
//

import UIKit
import FirebaseStorage
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var textFieldDescription: UITextField!
    
    @IBOutlet weak var uploadImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pickImage))
        uploadImageView.addGestureRecognizer(gestureRecognizer)

        // Do any additional setup after loading the view.
    }
    @objc func pickImage(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true,completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        uploadImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    @IBAction func upload(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        if let data = uploadImageView.image?.jpegData(compressionQuality: 0.5){
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(data) { StorageMetadata, error in
                if error != nil {
                    self.errorMessageShow(title: "Error", message: error?.localizedDescription ?? "you got an error please try again")
                }
                else {
                    imageReference.downloadURL { [self] url, error in
                        if error == nil {
                            let imageURL = url?.absoluteString
                            if let imageURL = imageURL{
                                let firestoreDatabase = Firestore.firestore()
                                let email : String = Auth.auth().currentUser?.email ?? ""
                                let firestorePost = ["gorselUrl" : imageURL,
                                                     "comment" : self.textFieldDescription.text!,
                                                     "email" : email,
                                                     "date" : FieldValue.serverTimestamp() ] as! [String : Any]
                                firestoreDatabase.collection("Post").addDocument(data: firestorePost) { error in
                                    if error != nil{
                                        self.errorMessageShow(title: "Error", message: "you got an error please try again")
                                    }else{
                                        
                                        self.uploadImageView.image = UIImage(named: "icloud.and.arrow.down")
                                        self.textFieldDescription.text = ""
                                        self.tabBarController?.selectedIndex = 0
                                    }
                                }
                            }
                           
                        }
                    }
                }
            }
        }
        
        
    }
    func errorMessageShow(title : String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction()
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }

}
