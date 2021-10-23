//
//  PurchaseSubscriptionViewController.swift
//  StretchTimer
//
//  Created by Joseph Simeone on 7/7/21.
//

import UIKit
import Alamofire
import StoreKit

class PurchaseSubscriptionViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var purchaseButton: UIButton!
    
    //MARK: Variables
    var products: [SKProduct] = []
    //MARK: IAP
    //Below moved into IAPHelper.swift
    //public static let purchaseID = "com.simeone.StretchTimer.basicCoachingMonthly"
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //Text delegate things
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        //Add notification observer for completing purchases
        NotificationCenter.default.addObserver(self, selector: #selector(PurchaseSubscriptionViewController.handlePurchaseNotification(_:)), name: .IAPHelperPurchaseNotification, object: nil)
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
        TeamSetProducts.store.requestProducts { [weak self] success, products in
            guard let self = self else { return }
            if success {
                self.products = products!
                let firstProduct = products![0]
                print("First product in returned list: \(firstProduct)")
                TeamSetProducts.store.buyProduct(firstProduct)
                //MARK: Note
                //After the above line is run, start an activity indicator with a timer that will send the user a timeout warning after a certain time if the success notification doesnt' come back.
            } else {
                //MARK: ADD ERROR HANDLING
                print("Failed to request products. This needs proper error handling later")
            }
        }
    }
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
        //This stuff might not be useful to me. Just use this to continue account creation.
        print("The purchase thingy worked")
        guard let productID = notification.object as? String, let index = products.firstIndex(where: { product -> Bool in
            product.productIdentifier == productID
        })
        else { return }
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
