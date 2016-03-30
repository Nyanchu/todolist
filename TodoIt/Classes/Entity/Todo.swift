//
//  Todo.swift
//  TodoIt
//
//  Created by 酒井智弘 on 2016/03/01.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import Foundation
import CoreData

class Todo: NSManagedObject {
    
    //var id:Int?
    //var title = ""
    
    @NSManaged var content: String
    @NSManaged var register_time: NSDate
    
}