//
//  FeedViewController.swift
//  PhotoSharingApp
//
//  Created by Hamza Oban on 2.10.2022.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    var postArray = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getData()
        // Do any additional setup after loading the view.
    }
    func getData(){
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("Post").order(by: "date", descending: true)
            .addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            }
            else{
                if snapshot?.isEmpty != true && snapshot != nil {
                    self.postArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents{
                        if let gorselUrl = document.get("gorselUrl") as? String{
                            if let email = document.get("email") as? String{
                                if let comment = document.get("comment") as? String{
                                    let post = Post(email: email, comment: comment, imageURL: gorselUrl)
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.emailLabel.text = postArray[indexPath.row].email
        cell.commentLabel.text = postArray[indexPath.row].comment
        cell.postImageView.sd_setImage(with: URL(string: self.postArray[indexPath.row].imageURL))
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
         
    }
    

}
