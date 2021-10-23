//
//  InitialViewController.swift
//  StretchTimer
//
//  Created by Joseph Simeone on 3/9/21.
//

import UIKit

let defaults = UserDefaults.standard

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //MARK: Check Setup
        //MARK: Add functionality to check app version number against supported versions in cloudkit
        if defaults.bool(forKey: "isSetup") {
            //MARK: Send the user home when created
           // performSegue(withIdentifier: , sender: )
        } else {
            performSegue(withIdentifier: "setupSegue", sender: self)
        }
        //performSegue(withIdentifier: "coachHomeSegue", sender: self)
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
