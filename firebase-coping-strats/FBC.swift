//
//  FBC.swift
//  firebase-coping-strats
//
//  Created by Aaron K. Brey on 12/1/22.
//

//FirebaseClass

import Foundation


import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase
import FirebaseAppCheck

import CoreLocation

class FBC{
    let FirebaseRefrence = Database.database(url: "https://tutor-6e628-default-rtdb.firebaseio.com/").reference()
    let BaseRefrence = "https://tutor-6e628-default-rtdb.firebaseio.com/"
    var RecevedData:[[String]]
    
    //init
    init() {
        self.RecevedData = []
    }
    
    //push to firebase
    public func Push(Data:Dictionary<String, Any>,User: String){
        Database.database(url: BaseRefrence).reference().child("/temp/").childByAutoId().setValue(Data)
        Database.database(url: BaseRefrence).reference().child("/perm/"+User+"/").childByAutoId().setValue(Data)
    }
    public func PushGoogle(Data:Dictionary<String, Any>,User: String){
        Database.database(url: BaseRefrence).reference().child("/helped/"+User+"/").childByAutoId().setValue(Data)
    }
    public func PullPerm(Id:String){
        var cells: [[String]] = []
        FirebaseRefrence.child("/perm/").child(Id+"/").observeSingleEvent(of: .value, with: { snapshot in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let keys = value?.allKeys
            for k in keys!{
                let block = value![k]! as? NSDictionary
                let inLib = String(self.ParceLoc(Str: block?["location"] as? String ?? "1, 1"))
                let state = block?["state"] as! String
                let time = block?["time"] as! String
                cells.append([time,state,inLib])
            }
            if cells.count > 0 {
                print("Data Found for " + Id)
                self.RecevedData = cells.sorted(by: { $0[0] > $1[0] })

            }
            // ...
        }) { error in
            print(error.localizedDescription)
        }
        
    }
    
    public func GetData() -> [[String]]{
        return self.RecevedData
    }
    private func ParceLoc(Str:String) -> Bool{
        if #available(iOS 16.0, *) {
            let s1 = Str.split(separator: ", ")[0]
            let s2 = Str.split(separator: ", ")[1]
            let pastloc = CLLocation(latitude: Double(s1)!, longitude: Double(s2)!)
            let target = CLLocation(latitude: 42.07978319, longitude: -87.95002423)
            let distence = pastloc.distance(from: target)
            if distence.binade < 39.5{
                return true
            }
        } else {
            // Fallback on earlier versions
            var n = Str
            var s1 = ""
            var s2 = ""
            var F = true
            for _ in 0...Str.count-1{
                let L = n.removeFirst()
                if L != "," || L != " "{
                    if F{s1.append(L)}
                    else {s2.append(L)}
                }else{
                    F = false
                }
            }
            let pastloc = CLLocation(latitude: Double(s1)!, longitude: Double(s2)!)
            let target = CLLocation(latitude: 42.07978319, longitude: -87.95002423)
            let distence = pastloc.distance(from: target)
            if distence.binade < 39.5{
                return true
            }
        }
        return false
    }
    
}
