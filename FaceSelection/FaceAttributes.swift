//
//  FaceAttributes.swift
//  FaceSelection
//
//  Created by Ryan McDonald on 7/12/18.
//  Copyright © 2018 Curious Kiwi Co. All rights reserved.
//

import Foundation

struct FaceAttributesIdentifiers {
    static let hair = "hair"
    static let bald = "bald"
    static let invisible = "invisible"
    static let hairColor = "hairColor"
    static let smile = "smile"
    static let gender = "gender"
    static let age = "age"
    static let glasses = "glasses"
    static let emotion = "emotion"
    static let headPose = "headPose"
}

struct FaceAttributes {
    
    enum HairColor: String {
        case brown
        case black
        case other
        case red
        case gray
        case blond
    }
    
    enum Gender: String {
        case male
        case female
        case unknown
    }
    
    enum Emotion: String {
        case anger
        case contempt
        case disgust
        case fear
        case happiness
        case neutral
        case sadness
        case surprise
        case none
    }
    
    var hairColor: [HairColor : Double]
    var bald: Double
    var smile: Bool
    var gender: Gender
    var age: Double
    var emotions: [Emotion : Int]
    var headPose: HeadPose
    
    init(hairColor: [HairColor : Double], bald: Double, smile: Bool, gender: Gender, age: Double, emotions: [Emotion : Int], headPose: HeadPose) {
        self.hairColor = hairColor
        self.bald = bald
        self.smile = smile
        self.gender = gender
        self.age = age
        self.emotions = emotions
        self.headPose = headPose
    }
    
    
    /// Initializes FaceAttributes Object
    ///
    /// - Parameter data: Dictionary representation of FaceAttributes Object
    /// - Returns: Initialized FaceAttributes object
    static func parseFaceAttributes(_ data: [String : Any]) -> FaceAttributes {
        var hairColor: [HairColor : Double] = [:]
        
        if let hColor = data[FaceAttributesIdentifiers.hairColor] as? [String : Any] {
            for (_,k) in hColor.enumerated() {
                guard let color = HairColor(rawValue: k.key) else {
                    continue
                }
                let confidence = k.value as? Double ?? 0.0
                
                hairColor[color] = confidence
            }
        }
        
        let bald = data[FaceAttributesIdentifiers.bald] as? Double ?? 0.0
        
        let s = data[FaceAttributesIdentifiers.smile] as? Int ?? 0
        let smile = s == 1 ? true : false
        
        let gender = Gender(rawValue: data[FaceAttributesIdentifiers.gender] as? String ?? "") ?? .unknown
        let age = data[FaceAttributesIdentifiers.age] as? Double ?? 0.0
        
        var emotionsDict: [Emotion : Int] = [:]
        if let emotions = data[FaceAttributesIdentifiers.emotion] as? [String : Any] {
            for (_,j) in emotions.enumerated() {
                guard let emotion = Emotion(rawValue: j.key) else {
                    continue
                }
                
                let confidence = j.value as? Int ?? 0
                
                emotionsDict[emotion] = confidence
                
            }
        }
        
        let headPoseDict = data[FaceAttributesIdentifiers.headPose] as? [String : AnyObject] ?? [:]
        let headPose = HeadPose.parseHeadPose(headPoseDict)
        
        
        let faceAttributes = FaceAttributes(hairColor:  hairColor,
                                            bald:       bald,
                                            smile:      smile,
                                            gender:     gender,
                                            age:        age,
                                            emotions:   emotionsDict,
                                            headPose:   headPose)
        
        return faceAttributes
        
    }
    
    
    /// Get the most confident emotion shown in the FaceAttributes object
    ///
    /// - Returns: Emotion with the most confidence
    func getMostConfidentEmotion() -> Emotion {
        var emotion: Emotion = .none
        var confidence = 0
        
        for (_,k) in emotions.enumerated() {
            if k.value > confidence {
                emotion = k.key
                confidence = k.value
            }
        }
        
        return emotion
    }
    
}
