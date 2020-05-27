//
//  LoginViewController.swift
//  ToDo.FireBase
//
//  Created by Aleksandr Kurdiukov on 25.05.20.
//  Copyright © 2020 Zizlak. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var warnLabel: UILabel!
    
    @IBOutlet weak var eMailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBAction func lofinTapped(_ sender: Any) {
    }
    
    @IBAction func registerTapped(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector (kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector (kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)

    }
    
    @objc func kbDidShow(notification: Notification){
        guard let userInfo = notification.userInfo else {return}
        let kbFrameSize =
            (userInfo[UIResponder.keyboardFrameEndUserInfoKey]
            as! NSValue).cgRectValue
        
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height + kbFrameSize.height)
        
    }
    
    @objc func kbDidHide(){
        
    }


}
