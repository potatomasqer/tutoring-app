//
//  GatherController.swift
//  firebase-coping-strats
//
//  Created by Bartosz Czerwiec on 12/13/22.
//

import UIKit

class GatherController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var froshButton: UIButton!
    @IBOutlet weak var sophButton: UIButton!
    @IBOutlet weak var juniorButton: UIButton!
    @IBOutlet weak var seniorButton: UIButton!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var IDTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    var dictionary = [String:Int]()
    var subjectArray = [String]()
    var timeSpent = 0
    let firebase = FBC()
    let defaults = UserDefaults.standard
    var gradelevel = ""
    override func viewDidLoad() {
        overrideUserInterfaceStyle = .light
        super.viewDidLoad()
        subjectTextField.text = ""
        IDTextField.text = ""
        timeTextField.text = ""
        timeSpent = 0
    }
    
    @IBAction func freshman(_ sender: UIButton) {
        textLabel.isHidden = true
        froshButton.isHidden = true
        sophButton.isHidden = true
        juniorButton.isHidden = true
        seniorButton.isHidden = true
        subjectTextField.isHidden = false
        IDTextField.isHidden = false
        timeTextField.isHidden = false
        cancelButton.isHidden = false
        okButton.isHidden = false
        gradelevel = "freshmen"
    }
    
    @IBAction func sophomore(_ sender: UIButton) {
        textLabel.isHidden = true
        froshButton.isHidden = true
        sophButton.isHidden = true
        juniorButton.isHidden = true
        seniorButton.isHidden = true
        subjectTextField.isHidden = false
        IDTextField.isHidden = false
        timeTextField.isHidden = false
        cancelButton.isHidden = false
        okButton.isHidden = false
        gradelevel = "sophmore"
    }
    
    @IBAction func junior(_ sender: UIButton) {
        textLabel.isHidden = true
        froshButton.isHidden = true
        sophButton.isHidden = true
        juniorButton.isHidden = true
        seniorButton.isHidden = true
        subjectTextField.isHidden = false
        IDTextField.isHidden = false
        timeTextField.isHidden = false
        cancelButton.isHidden = false
        okButton.isHidden = false
        gradelevel = "junior"
    }
    
    @IBAction func senior(_ sender: UIButton) {
        textLabel.isHidden = true
        froshButton.isHidden = true
        sophButton.isHidden = true
        juniorButton.isHidden = true
        seniorButton.isHidden = true
        subjectTextField.isHidden = false
        IDTextField.isHidden = false
        timeTextField.isHidden = false
        cancelButton.isHidden = false
        okButton.isHidden = false
        gradelevel = "senior"
    }
    
    @IBAction func ok(_ sender: UIButton) {
        if subjectTextField.text == "" {
            let dialogMessage = UIAlertController(title: "Error", message: "Name Left Empty", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
             })
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
        }
        else if IDTextField.text == "" {
            let dialogMessage = UIAlertController(title: "Error", message: "ID# Left Empty", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
             })
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
        }
        else if timeTextField.text == "" {
            let dialogMessage = UIAlertController(title: "Error", message: "Time Left Empty", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
             })
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
        }
        else {
            var time = 0
            time = Int(timeTextField.text!)!
            timeSpent += time
            dictionary["\(IDTextField.text!)"] = time
            subjectArray.append(subjectTextField.text!)
            
            firebase.PushGoogle(Data: ["helpedId":IDTextField.text!,"time":Int(timeTextField.text!)!,"subject":subjectTextField.text!,"gradelevel":gradelevel], User: defaults.string(forKey: "StudentID") ?? "0")
            
            textLabel.isHidden = false
            froshButton.isHidden = false
            sophButton.isHidden = false
            juniorButton.isHidden = false
            seniorButton.isHidden = false
            subjectTextField.isHidden = true
            IDTextField.isHidden = true
            timeTextField.isHidden = true
            cancelButton.isHidden = true
            okButton.isHidden = true
            subjectTextField.text = ""
            IDTextField.text = ""
            timeTextField.text = ""
            print(dictionary)
            print(subjectArray)
            
        }
        
    }
    @IBAction func cancel(_ sender: UIButton) {
        textLabel.isHidden = false
        froshButton.isHidden = false
        sophButton.isHidden = false
        juniorButton.isHidden = false
        seniorButton.isHidden = false
        subjectTextField.isHidden = true
        IDTextField.isHidden = true
        timeTextField.isHidden = true
        cancelButton.isHidden = true
        okButton.isHidden = true
        subjectTextField.text = ""
        IDTextField.text = ""
        timeTextField.text = ""
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
