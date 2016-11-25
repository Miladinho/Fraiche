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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
