//
//  TabBarViewModel.swift
//  Macro
//
//  Created by Byeon jinha on 11/14/23.
//

import Combine
import Foundation

final class TabBarViewModel {
    let tabComponentArray = CurrentValueSubject<[TabComponent], Never>([
        TabComponent(index: 1, imageName: "magnifyingglass", text: "주변 탐색"),
        TabComponent(index: 2, imageName: "person.circle", text: "내 정보"),
        TabComponent(index: 3, imageName: "square.and.pencil", text: "일지 작성"),
        TabComponent(index: 4, imageName: "map", text: "여행")
    ])
    
    let currentTabComponent = CurrentValueSubject<TabComponent, Never>(
        TabComponent(index: 0, imageName: "house", text: "홈"))
    
    var radius: CGFloat = 90
    var rotationAngle: Double = 0
    var timer: Timer?
    
    var isTabBarActive: Bool = false
    var animationStep: Int = 0
}
