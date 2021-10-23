//
//  CoachOnboardingViewController.swift
//  StretchTimer
//
//  Created by Joseph Simeone on 7/7/21.
//

import UIKit

class CoachOnboardingViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var loginCodeTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButton(_ sender: Any) {
        //Login and all that jazz here
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        //Push user to new screen where they fill out their information and complete the in app purchase
        performSegue(withIdentifier: "createCoachAccountSegue", sender: self)
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
