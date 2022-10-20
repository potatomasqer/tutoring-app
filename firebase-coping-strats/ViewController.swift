//
//  ViewController.swift
//  firebase-coping-strats
//
//  Created by Andrew Deleanu on 9/28/22.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
    
    
    var teacherPass = "phs.d214.org"
    var retrievedURL: URL!

    @IBOutlet weak var TestLabel: UILabel!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
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
        
        }
        


