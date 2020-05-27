//
//  TasksViewController.swift
//  ToDo.FireBase
//
//  Created by Aleksandr Kurdiukov on 25.05.20.
//  Copyright © 2020 Zizlak. All rights reserved.
//

import UIKit

class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func add(_ sender: UIBarButtonItem) {
    }
    
    @IBOutlet var tableView: UITableView?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "This is cell § \(indexPath.row)"
        cell.textLabel?.textColor = .white
        return cell
        
    }
    
    override func viewDidLoad() {
        tableView?.tableFooterView = UIView()
    }
    
}
