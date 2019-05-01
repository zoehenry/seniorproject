//
//  PersonEvent.swift
//  FamilyArchives
//
//  Created by Zoe Henry on 4/15/19.
//  Copyright © 2019 Zoe Henry. All rights reserved.
//

import UIKit
import AVFoundation
import os.log


class PersonEvent: NSObject, NSCoding {
    
    //MARK: Properties
    var name: String
    var photo: UIImage?
    var audioURL: URL?
    var personEventDescription: String
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("personEvents")
    
    //MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let audioURL = "audioURL"
        static let personEventDescription = "description"
    }
    
    //MARK: Initialization
    init?(name: String, photo: UIImage?, audioURL: URL?, personEventDescription: String) {
        if name.isEmpty {
            return nil
        }
        self.name = name
        self.photo = photo
        self.audioURL = audioURL
        self.personEventDescription = personEventDescription
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(audioURL, forKey: PropertyKey.audioURL)
        aCoder.encode(personEventDescription, forKey: PropertyKey.personEventDescription)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a PersonEvent object.", log: OSLog.default, type: .debug)
            return nil
        }

        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let audioURL = aDecoder.decodeObject(forKey: PropertyKey.audioURL) as? URL

        let personEventDescription = aDecoder.decodeObject(forKey: PropertyKey.personEventDescription) as? String

        self.init(name: name, photo: photo, audioURL: audioURL, personEventDescription: personEventDescription ?? "")
    }
}
