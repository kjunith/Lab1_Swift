//
//  Profile.swift
//  Lab1 - Swift
//
//  Created by Jimmie Määttä on 2019-06-11.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import Foundation


class Profile {
    
    let userDefaults = UserDefaults.standard
    static let data = Profile()
    
    var userName = String()
    var email = String()
    var firstName = String()
    var lastName = String()
    var picture = Data()
    
    func saveData() {
        let userNameData = try? NSKeyedArchiver.archivedData(withRootObject: self.userName, requiringSecureCoding: false)
        let emailData = try? NSKeyedArchiver.archivedData(withRootObject: self.email, requiringSecureCoding: false)
        let firstNameData = try? NSKeyedArchiver.archivedData(withRootObject: self.firstName, requiringSecureCoding: false)
        let lastNameData = try? NSKeyedArchiver.archivedData(withRootObject: self.lastName, requiringSecureCoding: false)
        let pictureData = try? NSKeyedArchiver.archivedData(withRootObject: self.picture, requiringSecureCoding: false)
        
        let profileData:[Data] = [
            userNameData! as Data,
            emailData! as Data,
            firstNameData! as Data,
            lastNameData! as Data,
            pictureData! as Data
        ]
        
        userDefaults.set(profileData, forKey: SaveKeys.profileKey)
        print("Profile data saved")
    }
    
    func loadData() {
        if let profileData:[Data] = userDefaults.object(forKey: SaveKeys.profileKey) as? [Data] {
            let userNameData:String = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(profileData[0] as Data) as! String
            let emailData:String = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(profileData[1] as Data) as! String
            let firstNameData:String = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(profileData[2] as Data) as! String
            let lastNameData:String = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(profileData[3] as Data) as! String
            let pictureData:Data = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(profileData[4] as Data) as! Data
            
            self.userName = userNameData
            self.email = emailData
            self.firstName = firstNameData
            self.lastName = lastNameData
            self.picture = pictureData
            
            print("Profile data loaded")
        } else {
            print("No profile data found")
        }
    }
}
