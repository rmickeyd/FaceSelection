//
//  HeadPose.swift
//  FaceSelection
//
//  Created by Ryan McDonald on 7/15/18.
//  Copyright © 2018 Curious Kiwi Co. All rights reserved.
//

import Foundation

struct HeadPoseIdentifiers {
    static let pitch = "pitch"
    static let roll = "roll"
    static let yaw = "yaw"
}

struct HeadPose {
    
    var pitch: Double
    var roll: Double
    var yaw: Double
    
    init(pitch: Double, roll: Double, yaw: Double) {
        self.pitch = pitch
        self.roll = roll
        self.yaw = yaw
    }
    
    
    /// Initializes HeadPose object from Dictionary
    ///
    /// - Parameter data: Dictionary Representation of HeadPose object
    /// - Returns: Initialized HeadPose object
    static func parseHeadPose(_ data: [String : Any]) -> HeadPose {
        let pitch = data[HeadPoseIdentifiers.pitch] as? Double ?? 0.0
        let roll = data[HeadPoseIdentifiers.roll] as? Double ?? 0.0
        let yaw = data[HeadPoseIdentifiers.yaw] as? Double ?? 0.0

        let headPose = HeadPose(pitch: pitch, roll: roll, yaw: yaw)
        
        return headPose
    }
    
}
