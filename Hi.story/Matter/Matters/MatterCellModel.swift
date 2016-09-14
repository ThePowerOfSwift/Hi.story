//
//  MatterCellModel.swift
//  Hi.story
//
//  Created by bl4ckra1sond3tre on 8/15/16.
//  Copyright © 2016 bl4ckra1sond3tre. All rights reserved.
//

import Foundation
import Hikit

protocol MatterCellModelType {
    var title: String { get }
    var days: Int { get }
    var tag: String { get }
}

struct MatterCellModel: MatterCellModelType {
    
    var title: String
    var days: Int
    var tag: String
    
    init(matter: Matter) {
        self.title = matter.title
        self.days = Date().hi.days(withDate: Date(timeIntervalSince1970: matter.happenedUnixTime))
        self.tag = (Tag(rawValue: matter.tag) ?? .red) .value
    }
}
