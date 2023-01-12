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

class FBC{
    let FirebaseRefrence = Database.database(url: "https://tutor-6e628-default-rtdb.firebaseio.com/").reference()
    let PermRefrence = "https://tutor-6e628-default-rtdb.firebaseio.com/perm/"
    let BaseRefrence = "https://tutor-6e628-default-rtdb.firebaseio.com/"
    //init
    public func FBC(){
        
    }
    
    //push to firebase
    public func Push(Data:Dictionary<String, Any>,User: String){
        Database.database(url: BaseRefrence).reference().child("/temp/").childByAutoId().setValue(Data)
        Database.database(url: BaseRefrence).reference().child("/perm/"+User+"/").childByAutoId().setValue(Data)
    }
    public func PushGoogle(Data:Dictionary<String, Any>,User: String){
        Database.database(url: BaseRefrence).reference().child("/helped/").childByAutoId().setValue(Data)
    }

    
    public func Pull(User: String) -> [String]{
        //get data
        var cells: [String] = [""]
        print("geting data from " + User) //    +User+"/"
        FirebaseRefrence.child("perm").child(User).observeSingleEvent(of: .value, with: { snapshot in

            let dict = snapshot.value as? NSDictionary
            let values = dict?.allValues
            let keys = dict?.allKeys
            
            
            
            //now make that into cells
            cells = self.CellMaker(dict: dict!, keys: keys as! [String])
                        

              // ...
            }) { error in
              print(error.localizedDescription)
            }
        return cells
        
        
    }
    private func CellMaker(dict:NSDictionary,keys:[String]) -> [String]{
        var cells: [String] = []
        if keys.count > 1{
            let ks = keys
            for i:String in ks{
                let di = dict[i] as! [String:String]
                cells.append(di["name"]! + di["state"]! + di["time"]!)
            }
        }
        return cells
    }
}
