//
//  RecorderAudio.swift
//  Pitch Perfect
//
//  Created by Krzysztof Maciążek on 19/03/16.
//  Copyright © 2016 kysieksoftware. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!
    
    required init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}