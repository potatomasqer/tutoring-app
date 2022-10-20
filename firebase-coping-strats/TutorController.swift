//
//  ViewController.swift
//  firebase-coping-strats
//
//  Created by Andrew Deleanu on 9/22/22.
//

//apple
import UIKit
import CoreLocation
import CoreLocationUI

//firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase
import FirebaseAppCheck

class TutorController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var CurrentTime: UITextView!
    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var AuthButton: UIButton!
    @IBOutlet weak var SignLabel: UILabel!
    @IBOutlet weak var StudentIDField: UITextField!
    @IBOutlet weak var StateLabel: UILabel!
    
    let defaults = UserDefaults.standard
    var startTime = "Time signed in today"
    var startDate:String = ""
    var CurentDate:String = ""
    var State = "signed out"
    let locationManager = CLLocationManager()
    var localData: [String] = []

    func updateTime(){
        let userCalendar = Calendar.current
        let currentDateTime = Date()
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second
        ]
        let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
        var time = ""
        if dateTimeComponents.minute! >= 10{
         time = String(dateTimeComponents.hour!) + ":" + String(dateTimeComponents.minute!)
        }
        else{time = String(dateTimeComponents.hour!) + ":0" + String(dateTimeComponents.minute!)}
        
        CurrentTime.text = time
        CurentDate = String(dateTimeComponents.month!) + "/" + String(dateTimeComponents.day!) + ", " + time
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

        //ref = Database.database().reference()
        
    }
    
    @IBAction func SignIn(_ sender: UIButton) {
        updateTime()
        let name = NameField.text!
        defaults.set(name, forKey: "Name")
        let id = StudentIDField.text!
        defaults.set(id, forKey: "StudentID")
        
        StudentIDField.resignFirstResponder()
        NameField.resignFirstResponder()
        
        //location stuff
        let location = locationManager.location
        let cords = String(location?.coordinate.latitude ?? 42.07986484) + ", " + String(location?.coordinate.longitude ?? -87.95008105)
        if State == "signed out"{
            //sign in
            State = "signed in"
            AuthButton.setTitle("Sign out", for: .normal)
            
            localData.append(String(State + ", " + CurentDate + "; " + name + ", " + id))
            
            print(localData)

            defaults.set(State, forKey: "Statekey")
            defaults.set("Sign out", forKey: "signIn")
            updateTime()
            
            let ref = Database.database().reference()
            ref.childByAutoId().setValue(["name":name, "studentid":id, "time":CurentDate, "state":State,"location":cords])
            
            StateLabel.text = "You are currently " + State + "."
            
        }else if State == "signed in" { //state = signed in
            State = "signed out"
            AuthButton.setTitle("Sign in", for: .normal)
            
            localData.append(String(State + ", " + CurentDate + "; " + name + ", " + id))
            
            print(localData)
            
            defaults.set(State, forKey: "Statekey")
            defaults.set("Sign in", forKey: "signIn")

            updateTime()
            
            let ref = Database.database().reference()
            ref.childByAutoId().setValue(["name":name, "studentid":id, "time":CurentDate, "state":State,"location":cords])
            
            StateLabel.text = "You are currently " + State + "."
            
        }
        //print(State)

        }
        
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if locations.first != nil {
            //print("location:: (location)")
            _ = 1+1 //here so it dont print anything anoying
        }
    }
}

