//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Denis Ricard on 2015-09-18.
//  Copyright © 2015 Hexaedre. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(path: NSURL, title: String) {
        self.title = title
        self.filePathUrl = path
    }
}