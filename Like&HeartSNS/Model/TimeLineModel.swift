//
//  TimeLineModel.swift
//  Like&HeartSNS
//
//  Created by 酒井専冴 on 2020/03/16.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import Foundation
import Firebase

class TimeLineModel{
    
    var text:String = ""
    var imageString:String = ""
    var profileImageString:String = ""
    var userName:String = ""
    var likeCounts:Int = 0
    var heartCounts:Int = 0
    let ref:DatabaseReference!
    
    init(text:String,imageString:String,ProfileImageString:String,userName:String) {
        
        self.text = text
        self.imageString = imageString
        self.profileImageString = ProfileImageString
        self.userName = userName
        self.ref = Database.database().reference().child("timeLine").childByAutoId()
        
    }
    init(snapShot:DataSnapshot) {
        
        ref = snapShot.ref
        if let value = snapShot.value as? [String:Any] {
            
            text = value["text"] as! String
            imageString = value["imageString"] as! String
            userName = value["userName"] as! String
            likeCounts = value["likeCounts"] as! Int
            heartCounts = value["heartCounts"] as! Int
            profileImageString = value["profileImageString"] as! String
            
        }
    }
    func toContents() -> [String:Any] {
        
        return ["text":text,"imageString":imageString,"userName":userName,"profileImageString":profileImageString,"likeCounts":likeCounts,"heartCounts":heartCounts]
    }
    func contentsSave(){
        
        ref.setValue(toContents())
    }
}

extension TimeLineModel{
    
    func plusLike(){
        
        likeCounts += 1
        ref.child("likeCounts").setValue(likeCounts)
        
    }
    func plusHeart(){
        
        heartCounts += 1
        ref.child("heartCounts").setValue(heartCounts)
        
    }
    func minusLike(){
        
        likeCounts -= 1
        ref.child("likeCounts").setValue(likeCounts)
    }
    func minusHeart(){
        
        heartCounts -= 1
        ref.child("heartCounts").setValue(heartCounts)
        
    }
}
