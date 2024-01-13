//
//  SharePlayActivity.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 1/10/24.
//

import Foundation
import GroupActivities

struct SharePlayActivity: GroupActivity {

    var metadata: GroupActivityMetadata {
        var meta = GroupActivityMetadata()
        meta.title = NSLocalizedString("SharePlay Example", comment: "")
        meta.type = .watchTogether
        return meta
    }
}
