//
//  CartViewController.swift
//  labProject
//
//  Created by prk on 12/15/23.
//

import UIKit
import CoreData
class CartViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var tabelView: UITableView!
    
    @IBOutlet weak var totalpriceLabel: UILabel!
    var cartList: [transaction]=[]
    var context: NSManagedObjectContext!
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        tabelView.delegate = self
        tabelView.dataSource = self
        initData()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CartTableViewCell
        cell.name.text = cartList[indexPath.row].toy?.title
        cell.quantity.text = "Quantity: \(cartList[indexPath.row].quantity!)"
        var temp = cartList[indexPath.row].toy?.price
        cell.price.text = "Price per unit: \(temp!)"
        var price = Int((cartList[indexPath.row].toy?.price.replacingOccurrences(of: "Rp.", with: ""))!)!
        var totalprice = price * cartList[indexPath.row].quantity!
        cell.totalprice.text = "Total Price: Rp.\(totalprice)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 179
    }
    
    func initData(){
        var totalprice: Int = 0
        var temp: Int = 0
        cartList.removeAll()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
        let predicate = NSPredicate(format: "userdata.userName == %@", ViewController.newusername.userName!)
        do{
            request.predicate = predicate
            let result = try context.fetch(request) as! [NSManagedObject]
            
            for data in result {
                let quantity = data.value(forKey: "quantity") as! Int
                if let toy = data.value(forKey: "toysdata") as? Toys {
                                let toyName = toy.title ?? "DefaultTitle"
                                let toyPrice = toy.price ?? "DefaultPrice"
                                let toyDesc = toy.desc ?? "DefaultDesc"
                                let toyCat = toy.category ?? "DefaultCategory"

                                cartList.append(transaction(quantity: quantity, toy: toyItem(title: toyName, description: toyDesc, Category: toyCat, price: toyPrice)))
                    temp = quantity * Int(toyPrice.replacingOccurrences(of: "Rp.", with: ""))!
                            }
                totalprice = totalprice + temp
                
            }
            tabelView.reloadData()
            totalpriceLabel.text = "Total Price: Rp.\(totalprice)"
        }catch{
            
        }
    }
}
