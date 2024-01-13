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
        meta.title = "Play Fall Ball Together!"
        meta.type = .generic
        return meta
    }
}
