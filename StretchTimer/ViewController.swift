//
//  ViewController.swift
//  StretchTimer
//
//  Purpose: Timer funcionality with rollover and announced stretches.
//
//  Created by Joseph Simeone on 3/8/21.
//

import UIKit
import AVKit
import Alamofire

class ViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var timerButtonLabel: UILabel!
    @IBOutlet weak var modeSelectorButton: UIButton!
    @IBOutlet var timerButtonLongPressRecognizer: UILongPressGestureRecognizer!
    @IBOutlet var hideViewTapped: UITapGestureRecognizer!
    @IBOutlet weak var outerRing: UIImageView!
    
    
    
    //MARK: Variables
    var workoutMode:Bool = true //true denotes a double rotation while false denotes a single
    var stretchStarted:Bool = false //is a workout in progress?
    var formattedTimerCount = 0 //only goes up to 30. Times how long stuff is going on
    var routineProgress = 0 //how far along in routine
    let feedbackGenerator = UINotificationFeedbackGenerator() //generate haptic feedback on event
    let buttonFeedback = UIImpactFeedbackGenerator()
    var timerShouldRun:Bool = false
    var timer: Timer?
    var isActive:Bool = false
    var speechSynth: AVSpeechSynthesizer!
    var audioSession: AVAudioSession!


    
    //MARK: Stretch Routine Storage
    //MARK: Add capability for a coach to put their own stretches here. Store in the cloud
    //Array storage for the two different workout cycles. I realize this prob isn't the best so don't come for me it's probably more efficient than using a shit ton of selection. Come at me bitch...
    let singleRotationRoutine:[String] = ["both legs out", "left leg out", "right leg out", "butterflies", "hollywoods", "other leg", "spider", "youngs", "other leg", "forward", "other leg"]
    let doubleRotationRoutine:[String] = ["both legs out", "left leg out", "right leg out", "butterflies", "both legs out", "left leg out", "right leg out", "butterflies", "hollywoods", "other leg", "spider", "hollywoods", "other leg", "spider", "youngs", "other leg", "forward", "other leg", "youngs", "other leg", "forward", "other leg"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        modeSelectorButton.addPadding(17)
        timerButtonLongPressRecognizer.isEnabled = false
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true) //timer element
        speechSynth = AVSpeechSynthesizer()
        speechSynth.delegate = self
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = false //MARK: ?
    }

    //Method that speaks whatever text is input
    func speakText(text: String) {
        audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(AVAudioSession.Category.playback, options: [.duckOthers, .interruptSpokenAudioAndMixWithOthers])
        let utterance: AVSpeechUtterance = AVSpeechUtterance(string: text)
        utterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.5
        speechSynth.speak(utterance)
    }
    
    //Make volume louder on background music after synth is done speaking :)
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        try? audioSession.setCategory(AVAudioSession.Category.playback, options: .mixWithOthers)
    }
    
    
    //Main method that is called whenever the user presses big button :)
    @IBAction func toggleStretch(_ sender: UIButton) {
        //Test for whether or not a stretch has been initiated. REMEMBER TO RESET THIS WHEN THE USER HOLDS DOWN TO CANCEL
        buttonFeedback.impactOccurred()
        if !stretchStarted { //REMEMBER disable the rotation switch button while a stretch is in progress
            timerShouldRun = true
            modeSelectorButton.isEnabled = false
            modeSelectorButton.backgroundColor = .systemGray
            timerButtonLongPressRecognizer.isEnabled = true
            stretchStarted = true
            isActive = true
            hideViewTapped.isEnabled = false
        } else if isActive {
                timerShouldRun = false
                isActive = false
        } else {
                timerShouldRun = true
                isActive = true
            }
        }
    
    //Hold down to cancel
    @IBAction func longPressRecognizer(_ sender: UILongPressGestureRecognizer) {
        feedbackGenerator.notificationOccurred(.error)
        stopStretch(canceled: true)
    }
    
    //Button to switch between double and single rotation
    @IBAction func modeSwitchButton(_ sender: UIButton) {
        buttonFeedback.impactOccurred()
        if workoutMode {
            workoutMode = false
            modeSelectorButton.setTitle("Single Rotation", for: .normal)
        } else {
            workoutMode = true
            modeSelectorButton.setTitle("Double Rotation", for: .normal)
        }
    }
    
    //Runs every time the timer is executed
    @objc func fireTimer() {
        //print("Timer fired!")
        if timerShouldRun {
           // print("Timer should run and fired")
            formattedTimerCount += 1 //increment timer value each time it fires
            timerButtonLabel.text = String(30 - formattedTimerCount)
            
            //MARK: Doesn't Work
            //animateRing()
            
            if (workoutMode && routineProgress >= doubleRotationRoutine.count - 1) || (!workoutMode && routineProgress >= singleRotationRoutine.count - 1) {
               // print("Shouldrun is now FALSE!!")
                stopStretch(canceled: false)

            }
            
            if formattedTimerCount >= 30 { //test whether or not a segment is over
                feedbackGenerator.prepare()
                routineProgress += 1 //increment routine progress
                feedbackGenerator.notificationOccurred(.success)
                formattedTimerCount = 0 //reset timer count
                if workoutMode { //if this is a double rotation
                    speakText(text: "Switch! \(doubleRotationRoutine[routineProgress])") //speak the apropriate instructions
                } else { //single rotation
                    speakText(text: "Switch! \(singleRotationRoutine[routineProgress])")
                } //end loop
            }
        }
    }//end fireTimer
    
    //MARK: Stretch Ended
    func stopStretch(canceled: Bool) {
        timerShouldRun = false
        routineProgress = 0
        timerButtonLongPressRecognizer.isEnabled = false
        formattedTimerCount = 0
        timerButtonLabel.text = "Start"
        modeSelectorButton.isEnabled = true
        modeSelectorButton.backgroundColor = UIColor(red: 0.47, green: 0.50, blue: 1.00, alpha: 1.00)
        hideViewTapped.isEnabled = true
        
        if !canceled {
            //MARK: Upload Completion to Web
            //Whenever that happens...
        }
    }
    
    
    /*func animateRing() {
        var animatorIn: UIViewPropertyAnimator!
        animatorIn = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) { [outerRing] in
            outerRing?.alpha = 0
        }
        var animatorOut: UIViewPropertyAnimator!
        animatorOut = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) { [outerRing] in
            outerRing?.alpha = 1
        }
        animatorIn.startAnimation()
        animatorOut.startAnimation()
    } */
    
    //MARK:Prepare to pop back to main screen
    //Put back the tab bar to avoid constraint issues
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
}

extension UIButton {
    func addPadding(_ padding: CGFloat) {
        titleEdgeInsets = UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
        contentEdgeInsets = UIEdgeInsets(top: 8, left: padding, bottom: 8, right: padding)
    }
}

