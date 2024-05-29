//
//  HomeViewController.swift
//  labProject
//
//  Created by Baron Bram on 16/11/23.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var toyList: [toyItem]=[]
    var context: NSManagedObjectContext!
    @IBOutlet weak var greetingsLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toyList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 179
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ToyTableViewCell
        cell.toyName.text = toyList[indexPath.row].title
        cell.toyDesc.text = toyList[indexPath.row].description
        cell.toyPrice.text = toyList[indexPath.row].price
        cell.toyCategory.text = toyList[indexPath.row].Category
        cell.updateButton.addTarget(self, action: #selector(updateTapped(_:)), for: .touchUpInside)

        return cell
    }
    
    func sendAlert(message:String){
        let alert = UIAlertController(title: "Error", message: "\(message)", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func initData(){
        toyList.removeAll()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Toys")
        do{
            let result = try context.fetch(request) as! [NSManagedObject]
            for data in result {
                let toyname = data.value(forKey: "title") as! String
                let toydesc = data.value(forKey: "desc") as! String
                let toyprice = data.value(forKey: "price") as! String
                let toycategory = data.value(forKey: "category") as! String
                let newtoy = toyItem(title: toyname, description: toydesc, Category: toycategory, price: toyprice)
                toyList.append(newtoy)
            }
            tableView.reloadData()
        }catch{
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        tableView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self
        greetingsLabel.text = "Greetings, \(ViewController.newusername.userName!)"
        initData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onAdd(_ sender: Any) {
        performSegue(withIdentifier: "HometoAdd", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            deletedata(indexPath: indexPath)
        }
            
    }
    
    func deletedata(indexPath: IndexPath){
        let olddata = toyList[indexPath.row]
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Toys")
        let predicate = NSPredicate(format: "title==%@", olddata.title!)
        do{
            request.predicate = predicate
            let result = try context.fetch(request) as! [NSManagedObject]
            
            for data in result{
                context.delete(data)
            }
            try context.save()
            initData()
        }catch{
            
        }
    }
    
    
    @IBAction func onLogout(_ sender: Any) {
        performSegue(withIdentifier: "HometoLogin", sender: nil)
    }
    
    @objc func updateTapped(_ sender: UIButton){
        if let cell = sender.superview?.superview as? ToyTableViewCell, let indexPath = tableView.indexPath(for: cell){
            let alert = UIAlertController(title: "Update Toy", message: "Please enter updated values", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addTextField{textField in textField.placeholder = "Name"}
            alert.addTextField{textField in textField.placeholder = "Description"}
            alert.addTextField{textField in textField.placeholder = "Price"}
            let add = UIAlertAction(title: "Update", style: .default) { _ in
                var toyName = alert.textFields?[0].text
                var toyDesc = alert.textFields?[1].text
                var toyPrice = alert.textFields?[2].text
                if toyName!.isEmpty {
                    toyName = self.toyList[indexPath.row].title
                }
                if toyDesc!.isEmpty {
                    toyDesc = self.toyList[indexPath.row].description
                }
                if toyPrice!.isEmpty {
                    toyPrice = self.toyList[indexPath.row].price
                }
                if try! (toyPrice!.contains(Regex("[^0-9]"))){
                    self.sendAlert(message: "Price must be numeric")
                    return
                }
                toyPrice = "Rp.\(toyPrice!)"
                let olddata = self.toyList[indexPath.row]
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Toys")
                let predicate = NSPredicate(format: "title==%@", olddata.title!)
                do{
                    request.predicate = predicate
                    let result = try self.context.fetch(request) as! [NSManagedObject]
                    for data in result{
                        data.setValue(toyName!, forKey: "title")
                        data.setValue(toyDesc!, forKey: "desc")
                        data.setValue(toyPrice!, forKey: "price")
                    }
                    try self.context.save()
                    self.initData()
                }catch{
                    print("Error with updating data")
                }
            }
            alert.addAction(add)
            alert.addAction(action1)
            present(alert, animated: true)
        }
    }
}
