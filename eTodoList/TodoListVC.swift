//
//  TodoListVC.swift
//  eTodoList
//
//  Created by Na Wu on 2016-12-04.
//  Copyright © 2016 Na Wu. All rights reserved.
//

import UIKit
import CoreData

class TodoListVC: UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func displayAll(_ sender: Any) {
    }

    @IBAction func addItem(_ sender: Any) {
        
        // Alert window. Create new To Do Item
        let alertController = UIAlertController(title: "Add To Do", message: "", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: ({
            (_) in
<<<<<<< HEAD
            if let field = (alertController.textFields?[0]) {
=======
            if let field = alertController.textFields![0] as? UITextField {
>>>>>>> 1e7088f30bcfdb2495037e354e76473d5d0deb35
                self.saveItem(itemToSave: field.text!)
                self.tableView.reloadData()
            }
            }
        ))
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        alertController.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
                textField.placeholder = "To do item description"
        })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func saveItem(itemToSave: String){
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "TodoItemEntity", in: managedContext)
        let item = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        
        item.setValue(itemToSave, forKey: "title")
        item.setValue(Date(), forKey: "createdDate")
        item.setValue(false, forKeyPath: "isCompleted")
        
        do {
            try managedContext.save()
            appDelegate.TodoItems.append(item)
        }
        catch {
            print ("Save failed!")
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoItemEntity")
        
        // Display uncompleted todo items
        fetchRequest.predicate = NSPredicate(format: "isCompleted == false", "isCompleted")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            appDelegate.TodoItems = results as! [NSManagedObject]
        }
        catch {
            print ("Fetch error!")
        }
        
        self.tableView.reloadData()        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        title = "To Do List"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return appDelegate.TodoItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)

        // Configure the cell...
        let item = appDelegate.TodoItems[indexPath.row]
        cell.textLabel?.text = item.value(forKey: "title") as! String?

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    // 
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let btnCompleted = UITableViewRowAction(style: .normal, title: "Done") { action, index in
            print ("Done")
            self.completeItem(index: indexPath.row)
            self.tableView.reloadData()
            self.viewWillAppear(true)
            
        }
        let btnDelete = UITableViewRowAction(style: .default, title: "Delete") { action, index in
            print ("Delete")
            self.deleteItem(index: indexPath.row)
            self.tableView.reloadData()
        }
        // btnCompleted.backgroundColor = UIColor.green
        return [btnDelete, btnCompleted]
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //
            deleteItem(index: indexPath.row)
            self.tableView.reloadData()
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "EditVC") {
            let target = segue.destination as! EditVC
            target.editingItemIndex = self.tableView.indexPathForSelectedRow!.row           
            
        }
    }
    
    func deleteItem (index: Int) {
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(appDelegate.TodoItems[index])
        appDelegate.saveContext()
        
        appDelegate.TodoItems.remove(at: index)
    }
    
    func completeItem (index: Int) {
        let item = appDelegate.TodoItems[index]
        let managedContext = appDelegate.persistentContainer.viewContext
        let object = managedContext.object(with: item.objectID)
        
        object.setValue(true, forKeyPath: "isCompleted")
        object.setValue(Date(), forKeyPath: "completedDate")

        do {
            try managedContext.save()
        } catch {
            print ("Save editing failed")
        }
        
    }
    
}
