//
//  ViewController.swift
//  firebase-coping-strats
//
//  Created by Andrew Deleanu on 9/28/22.
//

import UIKit
import SafariServices
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    
    var teacherPass = "phs.d214.org"
    var retrievedURL: URL!
    var locationManager = CLLocationManager()
    let defaults = UserDefaults.standard
    var FireBase = FBC()
    
    @IBOutlet weak var TestLabel: UILabel!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        getUserLocation()
        
    }
    
    
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
        

        

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.allowsBackgroundLocationUpdates = true
        manager.startUpdatingLocation()
        
        if locations.first != nil {
            //pick the closest location
            let d = 999999999.0
            var loc:CLLocation = CLLocation(latitude: 99.9, longitude: 99.9)
            let target = CLLocation(latitude: 42.07978319, longitude: -87.95002423)
            for L in locations{
                if  (L.distance(from: target).binade < d){
                    loc = L
                }
            }
            
            
            print(loc.distance(from: target))
            //do things
            let state = defaults.string(forKey: "signIn")
            
            if ((loc.distance(from: target).binade) > 31.55511715 && state != "signed out"){
                print((loc.distance(from: target).binade))
                
                let name = defaults.string(forKey: "Name")
                
                let id = defaults.string(forKey: "StudentID")
                
                let cords = String(loc.coordinate.latitude) + ", " + String(loc.coordinate.longitude)
                
                
                let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
                
                let CurentDate = String(dateTimeComponents.month!) + "/" + String(dateTimeComponents.day!) + ", " + time
                time = String(dateTimeComponents.hour!) + ":" + String(dateTimeComponents.minute!)

                FireBase.Push(Data: ["name":name!, "studentid":id!, "time":CurentDate, "state":state,"location":cords], User: name!+id!)
                
                
            }
        }
    }
    
    func getUserLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
}
