//
//  ViewController.swift
//  tutoring app
//
//  Created by Aaron K. Brey on 9/7/22.
//

//apple stuff
import UIKit
import CoreLocation
import CoreLocationUI

//firebase stuff
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase
import FirebaseAppCheck
class ViewController: UIViewController,UITextFieldDelegate, CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var CurrentTime: UITextView!
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var StudentID: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let defults = UserDefaults.standard
    var startTime = "Time signed in today"
    var startDate:String = ""
    var CurentDate:String = ""
    var State = "Signed out"
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
         time = String(dateTimeComponents.hour!) + ": " + String(dateTimeComponents.minute!)
        }
        else{time = String(dateTimeComponents.hour!) + ": 0" + String(dateTimeComponents.minute!)}
        
        CurrentTime.text = time
        CurentDate = String(dateTimeComponents.month!) + "/" + String(dateTimeComponents.day!) + ", " + time
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NameTextField.text = defults.string(forKey: "Name")
        StudentID.text = defults.string(forKey: "StudentID")
        let SBName = defults.string(forKey: "signIn")
        if SBName == "Sign out"{
            signInButton.setTitle(SBName, for: .normal)
        }
        
        if defults.string(forKey: "Statekey") == "Signed in"{
            State = defults.string(forKey: "Statekey") ?? State
        }
        
        updateTime()
        
        signInButton.updateConfiguration()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        //firebase set up
        let firebase = FirebaseApp.app()
        firebase.configure()
        var ref: DatabaseReference!

        ref = Database.database().reference()
        
    }
    

    @IBAction func SignIn(_ sender: UIButton) {
        updateTime()
        let name = NameTextField.text!
        defults.set(name, forKey: "Name")
        let id = StudentID.text!
        defults.set(id, forKey: "StudentID")
        
        StudentID.resignFirstResponder()
        NameTextField.resignFirstResponder()
        
        //location stuff
        if State == "Signed out"{
            //sign in
            let location = locationManager.location
            //print((String(location!.coordinate.latitude) + ", " + String(location!.coordinate.longitude)) )
            State = "Signed in"
            signInButton.setTitle("Sign out", for: .normal)
            
            localData.append(String(State + ", " + CurentDate + "; " + name + ", " + id))
            
            tableView.reloadData()
            print(localData)

            defults.set(State, forKey: "Statekey")
            defults.set("Sign out", forKey: "signIn")
            
        }else if State == "Signed in" { //state = signed in
            State = "Signed out"
            signInButton.setTitle("Sign in", for: .normal)
            
            localData.append(String(State + ", " + CurentDate + "; " + name + ", " + id))
            
            tableView.reloadData()
            print(localData)
            
            defults.set(State, forKey: "Statekey")
            defults.set("Sign in", forKey: "signIn")
            
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel!.text = localData[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localData.count
    }
}

