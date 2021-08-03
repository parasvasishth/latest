//
//  MenuList.swift
//  DemoScreen
//
//  Created by mac on 03/10/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
class Menu
{
    var list:String=""
    var image:String=""
    
    init(list:String,image:String) {
        self.list=list
        self.image=image
    }
}

class artistList
{
    var name:String=""
    var category:String=""
    var photo:String=""
    
    init(name:String,category:String,photo:String) {
        self.name = name
        self.category = category
        self.photo = photo
    }
}


class eventList
{
    var name:String=""
    var detail:String=""
    var address:String=""
    var time:String=""
    var photo:String=""
    
    init(name:String,detail:String,address:String,time:String,photo:String) {
        self.name = name
        self.detail = detail
        self.address = address
        self.time = time
        self.photo = photo
        
    }
}

class venueList
{
    var name:String=""
    var address:String=""
   var photo:String=""
    
    init(name:String,address:String,photo:String) {
        self.name = name
        self.address = address
        self.photo = photo
        
    }
}

class chatList
{
    var name:String=""
    var message:String=""
    var time:String=""
   var photo:String=""
    
    init(name:String,message:String,time:String,photo:String) {
        self.name = name
        self.message = message
        self.time = time
        self.photo = photo
        
    }
}

class reviewList
{
    var name:String=""
    var date:String=""
    var message:String=""
   var photo:String=""
    
    init(name:String,date:String,message:String,photo:String) {
        self.name = name
        self.date = date
        self.message = message
        self.photo = photo
        
    }
}

class inviteList
{
    var name:String=""
    var code:String=""
   var photo:String=""
    
    init(name:String,code:String,photo:String) {
        self.name = name
        self.code = code
        self.photo = photo
        
    }
}
class historyList
{
    var name:String=""
    var address:String=""
    var date:String=""
   var photo:String=""
    
    init(name:String,address:String,date:String,photo:String) {
        self.name = name
        self.address = address
        self.date = date
        self.photo = photo
        
    }
}
class contactlist
{
    var name:String=""
    var contact:String=""
    var status:String=""
   
    init(name:String,contact:String,status:String) {
        self.name = name
        self.contact = contact
        self.status = status
    }
}
