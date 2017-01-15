//
//  StorybookCellModel.swift
//  Hi.story
//
//  Created by bl4ckra1sond3tre on 8/20/16.
//  Copyright © 2016 bl4ckra1sond3tre. All rights reserved.
//

import Foundation
import Hikit

protocol StorybookCellModelType {
    
    var name: String { get }
    var coverImageURL: URL? { get }
}

struct StorybookCellModel: StorybookCellModelType {
    
    fileprivate(set) var name: String
    fileprivate(set) var coverImageURL: URL?
    
    init(storybook: Storybook) {
        self.name = storybook.name
        if let urlString = storybook.latestPicturedStory?.attachment?.urlString {
            self.coverImageURL =  URL(string: urlString)
        } else {
            self.coverImageURL = nil
        }
    }
}
