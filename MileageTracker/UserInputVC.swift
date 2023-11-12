//
//  UserInputVC.swift
//  MileageTracker
//
//  Created by Brian Nguyen on 6/29/23.
//

import UIKit
import CoreData

class UserInputVC: UIViewController {
    @IBOutlet weak var fromAddressTF: UITextField!
    @IBOutlet weak var toAddressTF: UITextField!
    @IBOutlet weak var dateAndTimeDP: UIDatePicker!

    var NewTracker : TrackerMO!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dateAndTimeDP.datePickerMode = .dateAndTime
        dateAndTimeDP.preferredDatePickerStyle = .compact
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        if let myAppDelegate =
        (UIApplication.shared.delegate as? AppDelegate)
        {
            NewTracker = TrackerMO(context: myAppDelegate.persistentContainer.viewContext)
            NewTracker.fromAddress = fromAddressTF.text!
            NewTracker.toAddress = toAddressTF.text!
            NewTracker.dateAndTime = dateAndTimeDP.date
            
            myAppDelegate.saveContext()
        }
        self.dismiss(animated: true)
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
