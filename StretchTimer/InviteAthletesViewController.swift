//
//  InviteAthletesViewController.swift
//  StretchTimer
//
//  Created by Joseph Simeone on 11/12/21.
//

import UIKit
import Alamofire

//MARK: Intent
/*
 Use this controller to present a coachID, let a coach share a link, or have athletes scan a QR code in order to join
 */
class InviteAthletesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
    
    //Pop user back to Athletes table after they're done inviting new athletes.
    @IBAction func doneButtonPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
   

}
