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
    let TempRefrence = "https://tutor-6e628-default-rtdb.firebaseio.com/temp/"
    //init
    public func FBC(){
        
    }
    
    //push to firebase
    public func Push(Data:Dictionary<String, Any>,User: String){
        Database.database(url: TempRefrence).reference().setValue(Data)
        Database.database(url: PermRefrence+User+"/").reference().setValue(Data)
    }
    public func Pull(User: String) async -> Any{
        do{
            //get data
            return try await Database.database(url: self.PermRefrence+User+"/").reference().getData()
            
        }catch{
            return []
        }
    }
}
