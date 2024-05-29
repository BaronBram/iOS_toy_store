//
//  ViewController.swift
//  labProject
//
//  Created by Baron Bram on 28/10/23.
//

import UIKit
import CoreData
class ViewController: UIViewController{
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    var context: NSManagedObjectContext!
    static var newusername : userdata = userdata()
    override func viewDidLoad() {
        super.viewDidLoad()
        var appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        // Do any additional setup after loading the view.
        
    }
    
    func sendAlert(message:String){
        let alert = UIAlertController(title: "Error", message: "\(message)", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    @IBAction func onLogin(_ sender: Any) {
        let username = usernameTF!.text
        let password = passwordTF!.text
        if username!.isEmpty || password!.isEmpty{
            sendAlert(message: "All fields must be filled")
        }else if username!.count <= 5{
            sendAlert(message: "Username must be at least 6 characters long")
        }else{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            let predicate = NSPredicate(format: "userName==%@", username!)
            do{
                request.predicate = predicate
                let result = try context.fetch(request) as! [NSManagedObject]
                if result.isEmpty{
                    sendAlert(message: "No such data")
                }
                for data in result{
                    if password != data.value(forKey: "password") as? String{
                        sendAlert(message: "Wrong Password!")
                        return
                    }
                    else{
                        if (data.value(forKey: "isAdmin") as! Int==1){
                            ViewController.newusername.userName = data.value(forKey: "userName") as? String
                            ViewController.newusername.password = data.value(forKey: "password") as? String
                            ViewController.newusername.userEmail = data.value(forKey: "userEmail") as? String
                            ViewController.newusername.isAdmin = data.value(forKey: "isAdmin") as? Bool
                            performSegue(withIdentifier: "LogintoAdminHome", sender: nil)
                            
                        }else{
                            ViewController.newusername.userName = data.value(forKey: "userName") as? String
                            ViewController.newusername.password = data.value(forKey: "password") as? String
                            ViewController.newusername.userEmail = data.value(forKey: "userEmail") as? String
                            ViewController.newusername.isAdmin = data.value(forKey: "isAdmin") as? Bool
                            performSegue(withIdentifier: "LogintoUserHome", sender: nil)
                            
                        }
                        
                    }
                }
            }catch{
                sendAlert(message: "No such data")
            }
            

            
        }
    }
    
    @IBAction func onRegister(_ sender: Any) {
        performSegue(withIdentifier: "LogintoRegister", sender: nil)
    }
}



