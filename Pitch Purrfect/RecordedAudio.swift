//
//  RecordedAudio.swift
//  Pitch Purrfect
//
//  Created by David Fierstein on 3/28/15.
//  Copyright (c) 2015 davidiad. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!
    
    init (filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
