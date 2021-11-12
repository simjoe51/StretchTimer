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

    override func viewDidLoad() {
        super.viewDidLoad()

        //Text delegate things
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        //Add notification observer for completing purchases
        NotificationCenter.default.addObserver(self, selector: #selector(PurchaseSubscriptionViewController.handlePurchaseNotification(_:)), name: .IAPHelperPurchaseNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PurchaseSubscriptionViewController.handlePurchaseDidFailNotification(_:)), name: NSNotification.Name(rawValue: "IAPHelperPurchaseDidFailNotification"), object: nil)
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
        //Fetch previously purchased products before attempting to purchase new ones.
        TeamSetProducts.store.restorePurchases()
        
        //Make the spinny thing
        let child = SpinnerViewController()

        TeamSetProducts.store.requestProducts { [weak self] success, products in
            guard let self = self else { return }
            if success {
                self.products = products!
                let firstProduct = products![0]
                print("First product in returned list: \(firstProduct)")
                if TeamSetProducts.store.isProductPurchased(firstProduct.productIdentifier) {
                    //The product has already been purchased. Notify user and prompt them to login.
                    DispatchQueue.main.async {
                        let ac = UIAlertController(title: "You've already purchased this!", message: "Paying me twice would be appreciated, but I think you just want to log in...", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Ok", style: .default))
                        self.present(ac, animated: true) {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                } else {
                    //Proceed with buying the product
                    TeamSetProducts.store.buyProduct(firstProduct)
                    //Activate the spinny thing
                    self.addChild(child)
                    child.view.frame = self.view.frame
                    self.view.addSubview(child.view)
                    child.didMove(toParent: self)
                    
                }
                //MARK: Note
                //After the above line is run, start an activity indicator with a timer that will send the user a timeout warning after a certain time if the success notification doesnt' come back.
            } else {
                //MARK: ADD ERROR HANDLING
                print("Failed to request products. This needs proper error handling later")
                let ac = UIAlertController(title: "Hmmm...", message: "Something went wrong finding subscriptions. Please check back later, this isn't your fault!!", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(ac, animated: true)
            }
        }
    }
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
        //This stuff might not be useful to me. Just use this to continue account creation.
       /* print("The purchase thingy worked")
        guard let productID = notification.object as? String, let index = products.firstIndex(where: { product -> Bool in
            product.productIdentifier == productID
        })
        else { return }
        print("ProductID: \(productID)") */
        createAccount()

    }
    
    //Handle a failed purchase
    @objc func handlePurchaseDidFailNotification(_ notification: Notification) {
        guard let errorDescription = notification.object as? String else { return }
        let ac = UIAlertController(title: "Whoops!", message: "Something went wrong: \(errorDescription)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        DispatchQueue.main.async {
            self.present(ac, animated: true)
        }
    }
    
    //Called after purchase completed. Should talk to server and actually create the account.
    private func createAccount() {
        
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

class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .large)
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
