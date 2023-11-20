//
//  TabBarViewModel.swift
//  Macro
//
//  Created by Byeon jinha on 11/14/23.
//

import Combine
import MacroDesignSystem
import UIKit
import MacroNetwork

final class TabBarViewModel {
    let tabComponentArray = CurrentValueSubject<[TabComponent], Never>([])
    
    let currentTabComponent = CurrentValueSubject<TabComponent, Never>(
        TabComponent(index: 0, image: UIImage.appImage(.house), text: "홈", viewController: HomeViewController() ))
    
    var radius: CGFloat = 90
    var rotationAngle: Double = 0
    var timer: Timer?
    
    var isTabBarActive: Bool = false
    var animationStep: Int = 0
    
    init() {
        setTabComponetArray()
    }
    
    // MARK: - Method
    
    private func setTabComponetArray() {
        let provider = APIProvider(session: URLSession.shared)
        
        let searchViewModel = SearchViewModel()
        let writeViewModel = WriteViewModel()
        let travelViewModel = TravelViewModel(
            routeRecorder: RouteRecorder(provider: provider),
            locationSearcher: LocationSearcher(provider: provider),
            pinnedPlaceManager: PinnedPlaceManager(provider: provider))
 
        let setComponentArray = [
        TabComponent(index: 1, 
                     image: UIImage.appImage(.magnifyingglass),
                     text: "주변 탐색", 
                     viewController: SearchViewController()),
        TabComponent(index: 2,
                     image: UIImage.appImage(.personCircle),
                     text: "내 정보",
                     viewController: SearchViewController()),
        TabComponent(index: 3,
                     image: UIImage.appImage(.squareAndPencil),
                     text: "일지 작성",
                     viewController: WriteViewController(viewModel: writeViewModel)),
        TabComponent(index: 4,
                     image: UIImage.appImage(.map),
                     text: "여행", 
                     viewController: TravelViewController(viewModel: travelViewModel))
        ]
        
        self.tabComponentArray.value = setComponentArray
    }
}
