//
//  LoginViewController.swift
//  ToDo.FireBase
//
//  Created by Aleksandr Kurdiukov on 25.05.20.
//  Copyright © 2020 Zizlak. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    var ref: DatabaseReference!

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var warnLabel: UILabel!
    
    @IBOutlet weak var eMailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    
// MARK: Login Tapped:
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = eMailTF.text, let password = passwordTF.text, email != "", password != "" else {
            displayWarning(withText: "Incorrect Info")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) {[weak self] (user, error) in
            if error != nil {
                self?.displayWarning(withText: "Error occured")
                return
            }
            if user != nil {
                self?.performSegue(withIdentifier: "tasksSeque", sender: nil)
                return
            }
            self?.displayWarning(withText: "User not found")
        }
        
    }
    
// MARK: Register Tapped:
    @IBAction func registerTapped(_ sender: Any) {
        guard let email = eMailTF.text, let password = passwordTF.text, email != "", password != "" else {
            displayWarning(withText: "Incorrect Info")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            
            guard error == nil, user != nil else {
                print(error!.localizedDescription)
                return
            }
            
            let userRef = self?.ref.child((user?.user.uid)!)
            userRef?.setValue(["email": user?.user.email])
  
            
            
        }
    }
    
    
// MARK: ViewDidLoad:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference(withPath: "users")
        
        NotificationCenter.default.addObserver(self, selector: #selector (kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector (kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        warnLabel.alpha = 0
        passwordTF.text = ""
        eMailTF.text = ""
        
        Auth.auth().addStateDidChangeListener {[weak self] (auth, user) in
            if user != nil {
                self?.performSegue(withIdentifier: "tasksSeque", sender: nil)
            }
        }

    }
    
// MARK: ViewWillAppear:
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eMailTF.text = ""
        passwordTF.text = ""
    }
    
    @objc func kbDidShow(notification: Notification){
        guard let userInfo = notification.userInfo else {return}
        let kbFrameSize =
            (userInfo[UIResponder.keyboardFrameEndUserInfoKey]
            as! NSValue).cgRectValue
        
        self.scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height + kbFrameSize.height)
        
        self.scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbFrameSize.height, right: 0)
        
    }
    
    @objc func kbDidHide(){
        
        self.scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        
    }
    
    
    func displayWarning(withText text: String){
        warnLabel.text = text
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut], animations: {[weak self] in
            self?.warnLabel.alpha = 1
        })
        {[weak self] complete in
            self?.warnLabel.alpha = 0
        }
    }

}
