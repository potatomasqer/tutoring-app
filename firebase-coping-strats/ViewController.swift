//
//  ViewController.swift
//  firebase-coping-strats
//
//  Created by Andrew Deleanu on 9/28/22.
//

import UIKit
import SafariServices

<<<<<<< Updated upstream
class ViewController: UIViewController {
    
    
    var teacherPass = "phs.d214.org"
    var retrievedURL: URL!
=======
//firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase
import FirebaseAppCheck

class ViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var CurrentTime: UITextView!
    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var AuthButton: UIButton!
    @IBOutlet weak var SignLabel: UILabel!
    @IBOutlet weak var StudentIDField: UITextField!
    @IBOutlet weak var StateLabel: UITextView!
    
    
    let defaults = UserDefaults.standard
    var startTime = "Time signed in today"
    var startDate:String = ""
    var CurentDate:String = ""
    var State = "signed out"
    let locationManager = CLLocationManager()
    var localData: [String] = []
>>>>>>> Stashed changes

    @IBOutlet weak var TestLabel: UILabel!
    
    
    override func viewDidLoad() {
        
<<<<<<< Updated upstream
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
=======
        NameField.text = defaults.string(forKey: "Name")
        StudentIDField.text = defaults.string(forKey: "StudentID")
        let SBName = defaults.string(forKey: "signIn")
        if SBName == "Sign out"{
            AuthButton.setTitle(SBName, for: .normal)
        }
        
        if defaults.string(forKey: "Statekey") == "signed in"{
            State = defaults.string(forKey: "Statekey") ?? State
        }
        
        updateTime()
        
        AuthButton.updateConfiguration()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        //firebase set up
        //let firebase = FirebaseApp.app()
        //firebase.configure()
        //var ref: DatabaseReference!
>>>>>>> Stashed changes

    }
    
<<<<<<< Updated upstream
    
    @IBAction func onTeacherButtonTapped(_ sender: UIButton) {
        TestLabel.text = "https://docs.google.com/spreadsheets/d/13oghwACaw0yW_oj-w_ujZSyg_UkaYXKxNV0I3tTceic/edit?usp=sharing"
        let alert = UIAlertController(title: "Enter Password", message: "Please enter the teacher password.", preferredStyle: .alert)
        alert.addTextField { (passwordField) in
            passwordField.textAlignment = .center
            passwordField.placeholder = "Password"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Enter", style: .default, handler: { [weak alert] (_) in
            let passwordField = alert?.textFields![0]
            
            if passwordField?.text == "phs.d214.org" {
                
                let savedURL = "https://docs.google.com/spreadsheets/d/13oghwACaw0yW_oj-w_ujZSyg_UkaYXKxNV0I3tTceic/edit?usp=sharing"
                self.retrievedURL = URL(string: savedURL)
                let svc = SFSafariViewController(url: self.retrievedURL)
                self.present(svc, animated: true, completion: nil)
            } else {
                let otherAlert = UIAlertController(title: "Try Again", message: "Please enter the correct teacher password.", preferredStyle: .alert)
                otherAlert.addAction(UIAlertAction(title: "Okay", style: .default))
                self.present(otherAlert, animated: true, completion: nil)
            }
            
        }))
        self.present(alert, animated: true, completion: nil)
        
=======
    @IBAction func SignIn(_ sender: UIButton) {
        updateTime()
        let name = NameField.text!
        defaults.set(name, forKey: "Name")
        let id = StudentIDField.text!
        defaults.set(id, forKey: "StudentID")
        
        StudentIDField.resignFirstResponder()
        NameField.resignFirstResponder()
        
        //location stuff
        if State == "signed out"{
            //sign in
            let location = locationManager.location
            //print((String(location!.coordinate.latitude) + ", " + String(location!.coordinate.longitude)) )
            State = "signed in"
            AuthButton.setTitle("Sign out", for: .normal)
            
            localData.append(String(State + ", " + CurentDate + "; " + name + ", " + id))
            
            StateLabel.text = "You are currently " + State + "."
            
            print(localData)

            defaults.set(State, forKey: "Statekey")
            defaults.set("Sign out", forKey: "signIn")
            updateTime()
            
            let ref = Database.database().reference()
            ref.childByAutoId().setValue(["name":name, "studentid":id, "time":CurentDate, "state":State])
            
        }else if State == "signed in" { //state = signed in
            State = "signed out"
            AuthButton.setTitle("Sign in", for: .normal)
            
            localData.append(String(State + ", " + CurentDate + "; " + name + ", " + id))
            
            print(localData)
            
            defaults.set(State, forKey: "Statekey")
            defaults.set("Sign in", forKey: "signIn")

            NameField.text = ""
            StudentIDField.text = ""
            StateLabel.text = "You are currently " + State + "."

            
            
            updateTime()
            
            let ref = Database.database().reference()
            ref.childByAutoId().setValue(["name":name, "studentid":id, "time":CurentDate, "state":State])
        }
        //print(State)
>>>>>>> Stashed changes

        

        }
        
        }
<<<<<<< Updated upstream
        

=======
    }
    

}
>>>>>>> Stashed changes

