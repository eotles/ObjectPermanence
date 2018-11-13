//
//  Object.swift
//  ObjectPermanence
//
//  Created by Erkin Otles on 11/12/18.
//  Copyright © 2018 Erkin Otles. All rights reserved.
//

import UIKit

/**
 Object to demonstrate storage of instances on disk over the course of several launches
 */
class Object: NSObject, NSCoding, Codable {
    //MARK: Properties
    var s: String
    var d: Date
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("results")
    
    //Mark: Types
    struct PropertyKey {
        static let s = "s"
        static let d = "d"
    }

    init?(s: String="", d: Date=Date()) {
        self.s = s
        self.d = d
    }
    
    func toJSON() -> String {
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(self)
        let jsonString = String(data: jsonData!, encoding: String.Encoding.utf8)
        return jsonString!
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(s, forKey: PropertyKey.s)
        aCoder.encode(d, forKey: PropertyKey.d)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let s = aDecoder.decodeObject(forKey: PropertyKey.s) as? String
        let d = aDecoder.decodeObject(forKey: PropertyKey.d) as? Date
        self.init(s: s!, d: d!)
    }
    
    
    

}
