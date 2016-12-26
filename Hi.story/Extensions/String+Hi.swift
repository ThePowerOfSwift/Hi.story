//
//  String+Hi.swift
//  Hi.story
//
//  Created by bl4ckra1sond3tre on 24/12/2016.
//  Copyright © 2016 bl4ckra1sond3tre. All rights reserved.
//

import Foundation
import Hikit

extension StringProxy {
    
    func height(with width: CGFloat, fontSize: CGFloat) -> CGFloat {
        return ceil(base.boundingRect(with: CGSize(width: width, height: CGFloat(FLT_MAX)), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: fontSize)], context: nil).height)
    }
}

