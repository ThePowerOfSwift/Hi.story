//
//  DraftCellModel.swift
//  Hi.story
//
//  Created by bl4ckra1sond3tre on 11/01/2017.
//  Copyright © 2017 bl4ckra1sond3tre. All rights reserved.
//

import RxCocoa
import RxSwift
import Hikit

protocol DraftCellModelType {
    var title: String { get }
    var content: String { get }
    var updatedAt: TimeInterval { get }
    var thumbnail: UIImage? { get }
    var hasAttachment: Bool { get }
}

struct DraftCellModel: DraftCellModelType {
    
    let title: String
    let content: String
    let updatedAt: TimeInterval
    let thumbnail: UIImage?
    let hasAttachment: Bool
    
    init(story: Story) {
        self.title = story.title
        self.content = story.body
        self.updatedAt = story.updatedAt
        self.thumbnail = story.attachment?.thumbnailImage // Maybe async?
        self.hasAttachment = (story.attachment != nil)
    }
}
