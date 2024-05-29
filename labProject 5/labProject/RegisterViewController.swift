//
//  RegisterViewController.swift
//  labProject
//
//  Created by prk on 05/12/23.
//

import UIKit
import CoreData

class RegisterViewController: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var isAdminButton: UISwitch!
    var context: NSManagedObjectContext!
    override func viewDidLoad() {
        super.viewDidLoad()

        var appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        isAdminButton.isOn = false
        // Do any additional setup after loading the view.
    }
    
    func sendAlert(message:String){
        let alert = UIAlertController(title: "Error", message: "\(message)", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    @IBAction func onRegister(_ sender: Any) {
        let username = usernameTF.text!
        let email = emailTF.text!
        let password = passwordTF.text!
        if username.isEmpty || email.isEmpty || password.isEmpty{
            sendAlert(message: "All fields must be filled")
        }else if username.count <= 5{
            sendAlert(message: "Username must be at least 6 characters long")
        }else{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            let predicate = NSPredicate(format: "userName==%@", username)
            do{
                request.predicate = predicate
                let result = try context.fetch(request) as! [NSManagedObject]
                if !(result.isEmpty){
                    sendAlert(message: "Username already taken")
                }
                
            }catch{
                sendAlert(message: "No such data")
            }
            let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
            let newUser = NSManagedObject(entity: entity!, insertInto: context)
            newUser.setValue(password, forKey: "password")
            newUser.setValue(email, forKey: "userEmail")
            newUser.setValue(username, forKey: "userName")
            newUser.setValue(isAdminButton.isOn, forKey: "isAdmin")
            do{
                try context.save()
            }catch{
                print("Register failed!")
            }
            performSegue(withIdentifier: "RegistertoLogin", sender: nil)
        }
    }
    
    @IBAction func onLogin(_ sender: Any) {
        performSegue(withIdentifier: "RegistertoLogin", sender: nil)
    }
     
}
