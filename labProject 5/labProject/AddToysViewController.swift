//
//  AddToysViewController.swift
//  labProject
//
//  Created by prk on 05/12/23.
//

import UIKit
import CoreData
class AddToysViewController: UIViewController {
    @IBOutlet weak var toynameTF: UITextField!
    
    @IBOutlet weak var toydescTF: UITextField!
    
    @IBOutlet weak var toycategoryPUB: UIButton!
    
    @IBOutlet weak var toypriceTF: UITextField!
    
    @IBOutlet weak var toysmenu: UIMenu!
    var context: NSManagedObjectContext!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        initbutton()
    }
    func initbutton(){
        toycategoryPUB.changesSelectionAsPrimaryAction = true
        toycategoryPUB.showsMenuAsPrimaryAction = true
    }
    
    @IBAction func menuAction(_ sender: Any) {
        // sekadar untuk menu item
    }
    
    @IBAction func onPopUpClick(_ sender: UIButton) {
        
    }
    
    func sendAlert(message:String){
        let alert = UIAlertController(title: "Error", message: "\(message)", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    @IBAction func onBack(_ sender: Any) {
        performSegue(withIdentifier: "AddtoHome", sender: nil)
    }
    
    
    @IBAction func onAddToy(_ sender: Any) {
        let toyname = toynameTF.text!
        let toydesc = toydescTF.text!
        let toyprice = toypriceTF.text!
        let toycategory = toycategoryPUB.currentTitle!
        var newtoyprice: String?
        if toyname.isEmpty || toydesc.isEmpty || toyprice.isEmpty{
            sendAlert(message: "All fields must be filled")
        }else if try! (toyprice.contains(Regex("[^0-9]"))){
            sendAlert(message: "Price must be numeric")
            return
        }else {
            if !(toyprice.hasPrefix("Rp.")){
                newtoyprice = "Rp." + toyprice
            }else{
                newtoyprice = toyprice
            }
            // add to core data
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Toys")
            let predicate = NSPredicate(format: "title==%@", toyname)
            do{
                request.predicate = predicate
                let result = try context.fetch(request) as! [NSManagedObject]
                if !(result.isEmpty){
                    sendAlert(message: "Toy name already taken")
                }
                
            }catch{
                sendAlert(message: "No such data")
            }
            let entity = NSEntityDescription.entity(forEntityName: "Toys", in: context)
            let newToy = NSManagedObject(entity: entity!, insertInto: context)
            newToy.setValue(toycategory, forKey: "category")
            newToy.setValue(toydesc, forKey: "desc")
            newToy.setValue(newtoyprice, forKey: "price")
            newToy.setValue(toyname, forKey: "title")
            do{
                try context.save()
            }catch{
                print("Register failed!")
            }
            performSegue(withIdentifier: "AddtoHome", sender: nil)
        }
    }
    
}
