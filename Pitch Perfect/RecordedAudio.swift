//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Denis Ricard on 2015-09-18.
//  Copyright © 2015 Hexaedre. All rights reserved.
//

import Foundation

// This is the Model class for this project. filePathUrl holds the path
// to the audio file
class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(path: NSURL, title: String) {
        self.title = title
        self.filePathUrl = path
    }
}