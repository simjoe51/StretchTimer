//
//  OnboardingViewController.swift
//  StretchTimer
//
//  Created by Joseph Simeone on 3/10/21.
//

import UIKit
import Alamofire
import CoreData

class OnboardingViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var coachTextField: UITextField!
    @IBOutlet weak var circleImageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameTextField.delegate = self
        coachTextField.delegate = self
        
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        coachTextField.attributedPlaceholder = NSAttributedString(string: "Coach ID (ask your coach...)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        self.view.sendSubviewToBack(circleImageView)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    //MARK: Continue Button Tapped
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        //performSegue(withIdentifier: "setupCompleteSegue", sender: self)
        if nameTextField.text != nil && coachTextField.text != nil {
            completeSetup()
        } else { //user didn't fill out one of the onboarding fields.
            let ac = UIAlertController(title: "Hold on a minute!", message: "It looks like you haven't filled out both of the fields!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    //MARK: Send Credentials to the Cloud
    func completeSetup() {
        //do some more shit
        //MARK: Create account without notification privileges
        AF.request("http://192.168.1.14:8080/createathlete", method: .post, parameters: ["name": nameTextField.text, "coachID": coachTextField.text], encoder: JSONParameterEncoder.default).response { [self] response in
            
            //Something sketchy happened. Handle error and present anything relevant to the user.
            if response.data == nil {
                print("Request to vapor returned nil unexpectedly. Internet error?")
                //MARK: ADD alert here
                let ac = UIAlertController(title: "Hm...", message: "We must've gotten confused. Setting up your account failed. Please try again later or contact support at SUPPORT EMAIL HERE", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(ac, animated: true)
            } else {
                print("Reached server. Returned reponse: ", String(data: response.data!, encoding: String.Encoding.utf8)!)
                //MARK: Add a selection statement to check whether or not the response was an error. If not, continue to the home screen
                
                //Save AthleteAccount to CoreData
              //  saveAthlete(name: "Joseph Simeone", id: , coachID: <#T##String#>)
              
                /*
                //set persistent values for profile data for use later
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
                let managedContext = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "Account", in: managedContext)
                let person = NSManagedObject(entity: entity!, insertInto: managedContext)
                
                person.setValue(fullName, forKeyPath: "fullName")
                person.setValue(phoneNumber, forKeyPath: "phoneNumber")
                person.setValue(age, forKeyPath: "age")
                person.setValue(UUID(uuidString: String(data: response.data!, encoding: .utf8)!), forKeyPath: "id")
                defaults.set(response.data, forKey: "UUID")
                defaults.set(true, forKey: "isSetup")
                
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                } */
                                
                performSegue(withIdentifier: "setupCompleteSegue", sender: self)
            }
        }
    }
    
    //MARK: CoreData Stuffs
    //Save athlete to coredata and all that jazz
   /* func saveAthlete(name: String, id: UUID, coachID: String) async throws {
        let context = CoreDataManager.shared.backgroundContext()
        await context.perform {
            let entity = AthleteAccount.entity()
            let athleteAccount = AthleteAccount(entity: entity, insertInto: context)
            athleteAccount.name = name
            athleteAccount.id = id
            athleteAccount.coachID = coachID
            try context.save()
        }
    } */
    
    @IBAction func coachSetupButton(_ sender: UIButton) {
        performSegue(withIdentifier: "coachSetupSegue", sender: self)
    }
    
    //MARK: Intent
    /*
     This button turns the green circle above into a camera view. Athlete can scan coach's QR code
     */
    @IBAction func scanCodeButtonPressed(_ sender: Any) {
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
