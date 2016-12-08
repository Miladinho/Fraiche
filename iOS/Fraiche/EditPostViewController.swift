//
//  EditPostViewController.swift
//  Fraiche
//
//  Created by Milad  on 12/7/16.
//  Copyright © 2016 Milad . All rights reserved.
//

import UIKit

class EditPostViewController: UIViewController {

    @IBOutlet weak var postDescriptionTextView: UITextView!
    @IBOutlet weak var postNameTextField: UITextField!
    
    var alert : UIAlertController!
    var loadingView : UIView!
    
    override func loadView() {
        super.loadView()
        self.loadingView = UIView()
        loadingView!.frame = CGRect(x: 0,y: 0, width: 100, height: 80)
        loadingView?.center = view.center
        loadingView?.alpha = 0.6
        loadingView?.backgroundColor = UIColor.black
        loadingView.layer.cornerRadius = 10
        loadingView.isHidden = true
        
        self.view.addSubview(loadingView)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alert = UIAlertController(title: "Post Status", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default) { (_) in
            self.dismiss(animated: true, completion: nil)
        })
        
        self.navigationItem.title = "Post Item"
        self.postDescriptionTextView.layer.borderColor = UIColor.black.cgColor
        self.postDescriptionTextView.layer.borderWidth = 1.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
