//
//  EditVC.swift
//  eTodoList
//
//  Created by Na Wu on 2016-12-04.
//  Copyright © 2016 Na Wu. All rights reserved.
//

import UIKit
import CoreData

class EditVC: UIViewController {
    
    var editingItemIndex = -1

    @IBOutlet weak var swCompleted: UISwitch!
    @IBOutlet weak var tfTitle: UITextField!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func saveClick(_ sender: Any) {
        let item = appDelegate.TodoItems[editingItemIndex]
        let managedContext = appDelegate.persistentContainer.viewContext
        let object = managedContext.object(with: item.objectID)
        
        object.setValue(tfTitle.text, forKey: "title")
        object.setValue(swCompleted.isOn, forKeyPath: "isCompleted")
        
        if swCompleted.isOn {
            object.setValue(Date(), forKeyPath: "completedDate")
        }
        
        do {
            try managedContext.save()
        } catch {
            print ("Save editing failed")
        }
            
        let _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Do any additional setup after loading the view.
        let appDeletegate = UIApplication.shared.delegate as! AppDelegate
        
        let item = appDeletegate.TodoItems[editingItemIndex]
        tfTitle.text = item.value(forKey: "title") as! String?
        swCompleted.isOn = (item.value(forKeyPath: "isCompleted") as! Bool?)!
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
