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
        Database.database(url: BaseRefrence).reference().child("/helped/"+User+"/").childByAutoId().setValue(Data)
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
