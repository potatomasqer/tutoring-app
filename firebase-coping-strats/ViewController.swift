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
    
    
    @IBOutlet weak var TestLabel: UILabel!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        locationManager.delegate = self
        
    }
    
    
    @IBAction func onTeacherButtonTapped(_ sender: UIButton) {
        let savedURL = "https://docs.google.com/spreadsheets/d/13oghwACaw0yW_oj-w_ujZSyg_UkaYXKxNV0I3tTceic/edit?usp=sharing"
        self.retrievedURL = URL(string: savedURL)
        let svc = SFSafariViewController(url: self.retrievedURL)
        self.present(svc, animated: true, completion: nil)
    }
}

class SignOutCheck: Thread,CLLocationManagerDelegate{
    override func start() {
        super.start()
    }
    override func main() { // Thread's starting point
        let defaults = UserDefaults.standard
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()
        let FireBase = FBC()
        while true{ //runs until app turned off
            SignOutCheck.sleep(forTimeInterval: 3)
            //check signin value
            var signin = defaults.string(forKey: "Statekey") ?? ""
            print(signin)
            if signin == "signed in"{
                //update location
                locationManager.requestLocation()
                // get current cords
                let cords = String(locationManager.location?.coordinate.latitude ?? 42.07986484) + ", " + String(locationManager.location?.coordinate.longitude ?? -87.95008105)
                //get target
                let target = CLLocation(latitude: 42.07978319, longitude: -87.95002423)
                //distence in meters
                let distence = locationManager.location?.distance(from: target)
                if distence!.binade > 39.5{
                    print(distence!.binade)
                    //outside of the zone
                    signin = "signed out"
                    defaults.setValue(signin, forKey: "Statekey")
                    defaults.setValue("Sign out", forKey: "signIn")
                    let time = updateTime()
                    FireBase.Push(Data: ["studentid":defaults.string(forKey: "StudentID")!, "time":time, "state":signin,"location":cords], User: defaults.string(forKey: "StudentID")!)
                    //threads job is done
                    self.Exit()
                }
                
            }else{
                self.Exit() //no use for thread
            }
            
        }
    }
    func Exit(){
        Thread.exit()
    }
    
    
    
    func updateTime() -> String{
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
        
        
        return String(dateTimeComponents.month!) + "/" + String(dateTimeComponents.day!) + ", " + time
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        _ = 1+1
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        _ = 1+1
    }
}
