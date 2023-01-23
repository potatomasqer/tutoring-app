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
import SwiftUI

//firebase

class TutorController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate,UITableViewDelegate {
    
    @IBOutlet weak var CurrentTime: UITextView!
    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var AuthButton: UIButton!
    @IBOutlet weak var SignLabel: UILabel!
    @IBOutlet weak var StudentIDField: UITextField!
    @IBOutlet weak var StateLabel: UILabel!
    
    
    var FireBase = FBC()
    let SOC = SignOutCheck()
    
    
    let defaults = UserDefaults.standard
    var startTime = "Time signed in today"
    var startDate:String = ""
    var CurentDate:String = ""
    var State = "signed out"
    var locationManager = CLLocationManager()
    var localData: [String] = []
    
    var authorized = false

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
        
        overrideUserInterfaceStyle = .light
        
        AuthButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
        
        
        StudentIDField.text = defaults.string(forKey: "StudentID")
        let SBName = defaults.string(forKey: "signIn")
        if SBName == "Sign out"{
            AuthButton.setTitle(SBName, for: .application)
        }
        
        if defaults.string(forKey: "Statekey") == "signed in"{
            State = defaults.string(forKey: "Statekey") ?? State
        }
        
        updateTime()
        
        AuthButton.updateConfiguration()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.requestLocation()
        
    }
    
    
    @IBAction func SignIn(_ sender: UIButton){
        updateTime()
        let id = StudentIDField.text!
        defaults.set(id, forKey: "StudentID")
        
        
        
        authorized = defaults.bool(forKey: "authorized")
        if !authorized{
            locationManager.requestWhenInUseAuthorization()
        }
        
        //location stuff
        let location = locationManager.location
        locationManager.requestLocation()
        let cords = String(location?.coordinate.latitude ?? 42.07986484) + ", " + String(location?.coordinate.longitude ?? -87.95008105)
        if State == "signed out"{
            //sign in
            State = "signed in"
            AuthButton.setTitle("Sign Out", for: .normal)

            localData.append(String(State + ", " + CurentDate + "; "  + ", " + id))
            
            
            SOC.start()
            defaults.set(State, forKey: "Statekey")
            defaults.set("Sign out", forKey: "signIn")
            updateTime()
            
            FireBase.Push(Data: ["studentid":id, "time":CurentDate, "state":State,"location":cords], User: id)
            
            StateLabel.text = "You are currently " + State + "."
            
        }else if State == "signed in" { //state = signed in
            State = "signed out"
            AuthButton.setTitle("Sign In", for: .normal)
            
            SOC.Exit()
            
            authorized = defaults.bool(forKey: "authorized")
            if !authorized{
                locationManager.requestAlwaysAuthorization()
            }
            localData.append(String(State + ", " + CurentDate + "; " + ", " + id))
            
            
            
            defaults.set(State, forKey: "Statekey")
            defaults.set("Sign in", forKey: "signIn")

            updateTime()
            FireBase.Push(Data: ["studentid":id, "time":CurentDate, "state":State,"location":cords], User: id)
            
            StateLabel.text = "You are currently " + State + "."
            
            
            
        }
        //print(State)

        }
        
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways{
            locationManager.requestLocation()
            authorized = true
        }else{
            authorized = false
        }
        defaults.set(authorized, forKey: "authorized")
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        _ = 1+1
    }
    func updateButton(){
        let SBName = defaults.string(forKey: "signIn")
        if SBName == "Sign out"{
            AuthButton.setTitle(SBName, for: .application)
        }
        AuthButton.updateConfiguration()
    }
}

