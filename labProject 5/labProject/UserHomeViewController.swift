//
//  UserHomeViewController.swift
//  labProject
//
//  Created by prk on 12/14/23.
//

import UIKit
import CoreData
class UserHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var toyList: [toyItem] = []
    var context: NSManagedObjectContext!
    @IBOutlet weak var greetingsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        greetingsLabel.text = "Greetings, \(ViewController.newusername.userName!)"
        initData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 256
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        toyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UserToyTableViewCell
        cell.toyName.text = toyList[indexPath.row].title
        cell.toyPrice.text = toyList[indexPath.row].price
        cell.toyDesc.text = toyList[indexPath.row].description
        cell.toyCategory.text = toyList[indexPath.row].Category
        cell.quantityLabel.text = "Quantity: 0"
        cell.qtyStepper.addTarget(self, action: #selector(stepperButton(_:)), for: .touchUpInside)
        cell.addToCartButton.addTarget(self, action: #selector(addToCartButton(_:)), for: .touchUpInside)
        cell.addToCartButton.isHidden = true
        return cell
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
    
    
    @objc func stepperButton(_ sender: UIStepper){
        if let cell = sender.superview?.superview as? UserToyTableViewCell{
            sender.minimumValue = 0
            cell.quantityLabel.text = "Quantity: \(Int(sender.value))"
            if sender.value == 0 {
                cell.addToCartButton.isHidden = true
            }else{
                cell.addToCartButton.isHidden = false
            }
        }
    }
    
    @objc func addToCartButton(_ sender: UIButton){
        if let cell = sender.superview?.superview as? UserToyTableViewCell, let indexPath = tableView.indexPath(for: cell){
            let quantity = cell.quantityLabel.text?.replacingOccurrences(of: "Quantity: ", with: "")
            var currentUser : NSManagedObject? = nil
            var currentToy : NSManagedObject? = nil
            let currentuser = ViewController.newusername
            let entity = NSEntityDescription.entity(forEntityName: "Transaction", in: context)
            let newTransaction = NSManagedObject(entity: entity!, insertInto: context)
            newTransaction.setValue(Int16(quantity!), forKey: "quantity")
            
//          ambil data toy
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Toys")
            let predicate = NSPredicate(format: "title==%@", toyList[indexPath.row].title)
            do{
                request.predicate = predicate
                let result = try context.fetch(request) as! [NSManagedObject]
                for data in result {
                    currentToy = data
                }
            }catch{
                
            }
            
//          ambil data user
            let request1 = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            let predicate1 = NSPredicate(format: "userName==%@", currentuser.userName!)
            do{
                request1.predicate = predicate1
                let result = try context.fetch(request1) as! [NSManagedObject]
                for data in result {
                    currentUser = data
                }
            }catch{
                
            }
            newTransaction.setValue(currentUser!, forKey: "userdata")
            newTransaction.setValue(currentToy!, forKey: "toysdata")
            do{
                try context.save()
                print("Added!")
            }catch{
                
            }
        }
    }
    @IBAction func onLogout(_ sender: Any) {
        performSegue(withIdentifier: "HometoLogin", sender: nil)
    }
}
