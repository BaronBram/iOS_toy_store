//
//  UpdateToysViewController.swift
//  labProject
//
//  Created by prk on 12/14/23.
//

import UIKit

class UpdateToysViewController: UIViewController {

    @IBOutlet weak var toyNameTF: UITextField!
    @IBOutlet weak var toyDescTF: UITextField!
    @IBOutlet weak var toyCategory: UIButton!
    @IBOutlet weak var toyPriceTF: UITextField!
    
    @IBOutlet weak var updateLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onUpdate(_ sender: Any) {
    }
    
    @IBAction func onMain(_ sender: Any) {
    }
}
