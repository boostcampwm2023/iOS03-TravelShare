//
//  PostFindResponse+Hashable.swift
//  Macro
//
//  Created by Byeon jinha on 12/8/23.
//

import Foundation

struct PostFindResponseHashable: Hashable {
    static func == (lhs: PostFindResponseHashable, rhs: PostFindResponseHashable) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    let identifier: UUID = UUID()
    var postFindResponse: PostFindResponse
    
    func hash(into hasher: inout Hasher) { // dataSource가 snapshot이 달라진 것 인식하기 위해 필요함
           hasher.combine(identifier)
       }
}
