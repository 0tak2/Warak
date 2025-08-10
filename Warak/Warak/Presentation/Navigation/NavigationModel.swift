//
//  NavigationModel.swift
//  Warak
//
//  Created by 임영택 on 8/10/25.
//

import Foundation

@Observable
class NavigationModel {
    var paths: [NavigationItem] = []
    
    func push(_ item: NavigationItem) {
        paths.append(item)
    }
    
    func pop() {
        paths.removeLast()
    }
    
    func reset() {
        paths = []
    }
}
