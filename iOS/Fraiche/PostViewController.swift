//
//  PostViewController.swift
//  Fraiche
//
//  Created by Milad  on 11/22/16.
//  Copyright © 2016 Milad . All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    
    @IBOutlet weak var postDescriptionTextView: UITextView!
    @IBOutlet weak var postNameTextField: UITextField!
    
    var alert : UIAlertController!
    var loadingView : UIView!
    
    var editMode : Bool = false
    var editPost : Post? = nil
    
    override func loadView() {
        super.loadView()
        self.loadingView = UIView()
        loadingView!.frame = CGRect(x: 0,y: 0, width: 100, height: 80)
        loadingView?.center = view.center
        loadingView?.alpha = 0.6
        loadingView?.backgroundColor = UIColor.black
        loadingView.layer.cornerRadius = 10
        loadingView.isHidden = true
        
        if (editMode && editPost != nil) {
            self.postNameTextField.text = editPost!.cTitle
            self.postDescriptionTextView.text = editPost!.cDescription
            self.navigationItem.title = "Edit Post"
        } else {
            self.navigationItem.title = "Post Item"
        }
        self.view.addSubview(loadingView)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alert = UIAlertController(title: "Post Status", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default) { (_) in
            self.navigationController?.dismiss(animated: true, completion: nil)
        })
        
        self.postDescriptionTextView.layer.borderColor = UIColor.black.cgColor
        self.postDescriptionTextView.layer.borderWidth = 1.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createPostButtonTouched(_ sender: AnyObject) {
        
        let actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0, width: 150, height: 150)) as UIActivityIndicatorView
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        view.addSubview(actInd)
        
        
        actInd.startAnimating()
        self.loadingView.isHidden = false
        
        if (editMode && editPost != nil) {
    
            editPost!.cTitle = postNameTextField.text
            editPost!.cDescription = postDescriptionTextView.text
            PostsManager.updatePost(editPost!, withHandler: {
                (success, post) -> () in
                
                DispatchQueue.main.async(execute: {
                    () -> Void in
                
                    actInd.stopAnimating()
                    if success {
                    self.alert.message = "Edit was succesful"
                    } else {
                    self.alert.message = "Edit was not succesful"
                    }
                    
                    self.present(self.alert, animated: true, completion: nil)
                    self.loadingView.isHidden = true
                
                })
            })
        } else {
            let post : Post = Post()
            post.cUserId = UsersManager.currentUser.cId
            post.cTitle = postNameTextField.text
            post.cDescription = postDescriptionTextView.text
            PostsManager.createPost(post, withHandler: {
                (success, post) -> () in
                
                DispatchQueue.main.async(execute: {
                    () -> Void in
                    
                    actInd.stopAnimating()
                    if success {
                        self.alert.message = "Post was succesful"
                    } else {
                        self.alert.message = "Post was not succesful"
                    }
                    
                    self.present(self.alert, animated: true, completion: nil)
                    self.loadingView.isHidden = true
                    
                })
            })
        }
    }

}
