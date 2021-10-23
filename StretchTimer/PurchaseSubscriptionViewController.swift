//
//  PurchaseSubscriptionViewController.swift
//  StretchTimer
//
//  Created by Joseph Simeone on 7/7/21.
//

import UIKit
import Alamofire

class PurchaseSubscriptionViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var purchaseButton: UIButton!
    
    //MARK: Variables
    //MARK: IAP
    public static let purchaseID = "com.simeone.StretchTimer.basicCoachingMonthly"
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if nameTextField.text != nil && emailTextField.text != nil && passwordTextField.text != nil {
            purchaseButton.isEnabled = true
        } else {
            purchaseButton.isEnabled = false
        }
        return true
    }
    
    //MARK: Attempt Purchase
    //Attempt to purchase subscription. If this is successful, use Alamofire to send the signup details to server
    @IBAction func purchaseSubscriptionButton(_ sender: UIButton) {
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
