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
        let waiter = waitForData(FireBase: FireBase, controller: self)
        
        overrideUserInterfaceStyle = .light
        
        outputTable.delegate = self
        outputTable.dataSource = self
        outputTable.rowHeight = 44.0
        
        Data = [["10pm","in","yes"]]
        
        print("Wait starting")
        waiter.start()
        print("Wait Started")
         
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("Count: " + String(Data.count))
        return Data.count
    }
    
    func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Ask for a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "Data", for: indexPath) as! CustomCell?
        let r = indexPath.row
        cell?.TimeL.text = Data[r][0]
        cell?.StateL.text = Data[r][1]
        cell?.LibL.text = Data[r][2]
        
        
        return cell!
    }

    func updateTable(newData:[[String]]){
        DispatchQueue.main.async {
            self.Data = newData
            self.outputTable.reloadData()
        }
    }
}


class waitForData: Thread{
    private var FireBase:FBC
    private var controller:PreviousDataController
    
    init(FireBase: FBC, controller: PreviousDataController) {
        self.FireBase = FireBase
        self.controller = controller
    }
    
    override func start() {
        UserDefaults.standard.set([[""]], forKey: "FireData")
        UserDefaults.standard.set(false, forKey: "DataFound")
        let id = UserDefaults.standard.string(forKey: "StudentID")!
        self.FireBase.PullPerm(Id: id)
        super.start()
    }
    
    override func main() {
        while true{
            waitForData.sleep(forTimeInterval: 0.5)
            let d = self.FireBase.GetData()
            
            if d != []{
                self.controller.updateTable(newData: d)
                self.Exit()
            }
        }
    }
    func Exit(){
        Thread.exit()
    }
}







class CustomCell: UITableViewCell {

    
    @IBOutlet weak var StateL: UILabel!
    @IBOutlet weak var LibL: UILabel!
    @IBOutlet weak var TimeL: UILabel!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    

}
