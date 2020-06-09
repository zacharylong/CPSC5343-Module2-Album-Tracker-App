//
//  Album.swift
//  AlbumTracker
//
//  Created by Zachary Long on 6/7/20.
//  Copyright © 2020 Zachary Long. All rights reserved.
//

import UIKit
import os.log



class Album: NSObject, NSCoding {
    
    //MARK: Properties
    
    var name: String
    var artist: String
    var year: String
    var recordLabel: String
    var photo: UIImage?
    var trackList: String
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("albums")
    
    //MARK: Types
    
    struct PropertyKey {
        
        static let name = "name"
        static let artist = "artist"
        static let year = "year"
        static let recordLabel = "recordLabel"
        static let photo = "photo"
        static let trackList = "trackList"
        
    }
    
    //MARK: Initialization
    
     
    //init?(name: String, artist: String, year: String, recordLabel: String, photo: UIImage?) {
    //init(name: String, artist: String, photo: UIImage?) {
    init(name: String, artist: String, year: String, recordLabel: String, photo: UIImage?, trackList: String) {
        // Initialization should fail if there is no name or if the rating is negative.
//        guard name.isEmpty else {
//            return nil
//        }
        
        // Initialize stored properties.
        self.name = name
        self.artist = artist
        self.year = year
        self.recordLabel = recordLabel
        self.photo = photo
        self.trackList = trackList
        
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(artist, forKey: PropertyKey.artist)
        aCoder.encode(year, forKey: PropertyKey.year)
        aCoder.encode(recordLabel, forKey: PropertyKey.recordLabel)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(trackList, forKey: PropertyKey.trackList)
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        //The name is required. If we cannot decode a name string, the initializer should fail
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String
            else {
                os_log("Unable to decode the name for an Album object.", log: OSLog.default, type: .debug)
        return nil
        }
        
        //Because the photo is optional, just use conditional cast
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        guard let artist = aDecoder.decodeObject(forKey: PropertyKey.artist) as? String else { return nil }
        
        guard let year = aDecoder.decodeObject(forKey: PropertyKey.year) as? String else { return nil }
        
        guard let recordLabel = aDecoder.decodeObject(forKey: PropertyKey.recordLabel) as? String else { return nil }
        
        guard let trackList = aDecoder.decodeObject(forKey: PropertyKey.trackList) as? String else { return nil }
        
        //Must call desginated initializer
        self.init(name: name, artist: artist, year: year, recordLabel: recordLabel, photo: photo, trackList: trackList)
        
    }
    
}
