//
//  PreviousDataController.swift
//  firebase-coping-strats
//
//  Created by Aaron K. Brey on 3/15/23.
//

import Foundation
import UIKit

class PreviousDataController : UIViewController, UITableViewDelegate,UITableViewDataSource{
    
    
    
    @IBOutlet weak var outputTable: UITableView!
    
    var FireBase = FBC()
    var Data: [[String]] = []
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        let id = defaults.string(forKey: "StudentID")!
        Data = FireBase.PullPerm(Id: id)
        overrideUserInterfaceStyle = .light
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.count
    }
    
    func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // Ask for a cell of the appropriate type.
       let cell = tableView.dequeueReusableCell(withIdentifier: "Data", for: indexPath)
            
       // Configure the cell’s contents with the row and section number.
       // The Basic cell style guarantees a label view is present in textLabel.
       cell.textLabel!.text = "Row \(indexPath.row)"
       return cell
    }

    
}
