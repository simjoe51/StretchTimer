//
//  HomeViewController.swift
//  StretchTimer
//
//  Created by Joseph Simeone on 3/10/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var mileageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var stretchButton: UIButton!
    
    //MARK: Variables
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //Send user to the stretch controller
    @IBAction func stretchButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "stretchSegue", sender: self)
    }
    
    //Send user to check in screen
    @IBAction func checkInButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "checkInSegue", sender: self)
    }
    
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       // print("prepare for segue")
        // Pass the selected object to the new view controller.
    }
}
