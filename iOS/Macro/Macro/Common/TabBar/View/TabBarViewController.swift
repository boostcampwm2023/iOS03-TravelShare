//
//  TabBarViewController.swift
//  Macro
//
//  Created by Byeon jinha on 11/14/23.
//

import Combine
import UIKit

final class TabbarViewController: UIViewController {
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: TabBarViewModel
    
    // MARK: - UI Components
    private let tabBarBackgroundLargeCirclceView: TabBarBackgroundLargeCirclceView = TabBarBackgroundLargeCirclceView()
    private let tabBarBackgroundSmallCirclceView: TabBarBackgroundSmallCirclceView = TabBarBackgroundSmallCirclceView()
    private let activeTabBarCenterView: TabBarCenterView = TabBarCenterView()
    private let inactiveTabBarCenterView: TabBarCenterView = TabBarCenterView()
    private let tabBarOpacityView: TabBarOpacityView = TabBarOpacityView()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        setUpLayout()
        bind()
        manageTabBarStatus(active: false)
        super.viewDidLoad()
    }
    
    init(viewModel: TabBarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = TabBarViewModel()
        super.init(coder: coder)
    }
}

// MARK: - UI Settings
private extension TabbarViewController {
    
    func setupTranslatesAutoresizingMaskIntoConstraints() {
        tabBarBackgroundLargeCirclceView.translatesAutoresizingMaskIntoConstraints = false
        tabBarBackgroundSmallCirclceView.translatesAutoresizingMaskIntoConstraints = false
        activeTabBarCenterView.translatesAutoresizingMaskIntoConstraints = false
        inactiveTabBarCenterView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func generateSubviewLocation(index: Int) -> TabLocation {
        let centerX: CGFloat = tabBarBackgroundLargeCirclceView.bounds.width * 0.5
        let centerY: CGFloat = tabBarBackgroundLargeCirclceView.bounds.height * 0.5
        let cosX: CGFloat = CGFloat(cos(angle(index: index) + viewModel.rotationAngle))
        let sinY: CGFloat = CGFloat(sin(angle(index: index) + viewModel.rotationAngle))
        let subviewX: CGFloat = centerX + cosX * viewModel.radius
        let subviewY: CGFloat = centerY + sinY * viewModel.radius
        
        return  TabLocation(locationX: subviewX, locationY: subviewY)
    }
    
    func addSubviews() {
        view.addSubview(tabBarOpacityView)
        view.addSubview(tabBarBackgroundLargeCirclceView)
        view.addSubview(inactiveTabBarCenterView)
        tabBarBackgroundLargeCirclceView.addSubview(tabBarBackgroundSmallCirclceView)
        tabBarBackgroundSmallCirclceView.addSubview(activeTabBarCenterView)
    }
    
    func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            tabBarOpacityView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            tabBarOpacityView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            inactiveTabBarCenterView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            inactiveTabBarCenterView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30),
            
            tabBarBackgroundLargeCirclceView.centerXAnchor.constraint(equalTo: super.view.centerXAnchor),
            tabBarBackgroundLargeCirclceView.bottomAnchor.constraint(equalTo: super.view.bottomAnchor, constant: -30),
            
            tabBarBackgroundSmallCirclceView.centerXAnchor.constraint(equalTo: tabBarBackgroundLargeCirclceView.centerXAnchor),
            tabBarBackgroundSmallCirclceView.centerYAnchor.constraint(equalTo: tabBarBackgroundLargeCirclceView.centerYAnchor),
            
            activeTabBarCenterView.centerXAnchor.constraint(equalTo: tabBarBackgroundSmallCirclceView.centerXAnchor),
            activeTabBarCenterView.centerYAnchor.constraint(equalTo: tabBarBackgroundSmallCirclceView.centerYAnchor)
        ])
    }
    
    func addTapGesture() {
        let inactiveCenterTapGesture = UITapGestureRecognizer(target: self, action: #selector(inactiveCenterHandleTapGesture(_:)))
        inactiveTabBarCenterView.addGestureRecognizer(inactiveCenterTapGesture)
        
        let activCenterTapGesture = UITapGestureRecognizer(target: self, action: #selector(activeCenterHandleTapGesture(_:)))
        activeTabBarCenterView.addGestureRecognizer(activCenterTapGesture)
    }
    
    func setUpLayout() {
        setupTranslatesAutoresizingMaskIntoConstraints()
        addSubviews()
        setLayoutConstraints()
        addTapGesture()
        setItemLayout()
    }
    
    func setItemLayout() {
        viewModel.tabComponentArray
            .sink { [weak self] tabComponents in
                for (index, tabComponent) in tabComponents.enumerated() {
                    let componentView: TabComponentView = TabComponentView(
                        frame: .zero,
                        tabComponent: tabComponent,
                        index: index)
                    tabComponentViewSetLayout(view: componentView, index: index)
                    
                }
            }
            .store(in: &cancellables)
        func setupTranslatesAutoresizingMaskIntoConstraints(view: TabComponentView) {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        func addSubviews(view: TabComponentView) {
            tabBarBackgroundLargeCirclceView.addSubview(view)
        }
        
        func setLayoutConstraints(view: TabComponentView, index: Int) {
            let componentViewWidth: CGFloat = TabComponentView.Metrics.width
            let componentViewHeight: CGFloat = TabComponentView.Metrics.height
            
            let tabLocation: TabLocation = self.generateSubviewLocation(index: index)
            
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(
                    equalTo: self.tabBarBackgroundLargeCirclceView.leadingAnchor,
                    constant: tabLocation.locationX - componentViewWidth / 2),
                
                view.topAnchor.constraint(
                    equalTo: self.tabBarBackgroundLargeCirclceView.topAnchor,
                    constant: tabLocation.locationY - componentViewHeight / 2),
                
                view.widthAnchor.constraint(
                    equalToConstant: componentViewWidth),
                
                view.heightAnchor.constraint(
                    equalToConstant: componentViewHeight)
            ])
        }
        
        func addTapGesture(view: TabComponentView) {
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.tabComponentHandlePanGesture(_:)))
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tabComponentHandleTapGesture(_:)))
            
            view.addGestureRecognizer(panGesture)
            view.addGestureRecognizer(tapGesture)
        }
        
        func tabComponentViewSetLayout(view: TabComponentView, index: Int) {
            setupTranslatesAutoresizingMaskIntoConstraints(view: view)
            addSubviews(view: view)
            setLayoutConstraints(view: view, index: index)
            addTapGesture(view: view)
        }
    }
}

// MARK: - Handdle Gesture
private extension TabbarViewController {
    
    /// 타이머가 활성화되어 있지 않은 경우, 사라지는 이벤트를 처리합니다.
    @objc func activeCenterHandleTapGesture(_ sender: UITapGestureRecognizer) {
        guard viewModel.timer == nil else { return }
        disAppearEvent()
    }
    
    /// 타이머가 활성화되어 있지 않은 경우, 비활성 탭 바 센터 뷰를 숨기고 탭 바 큰 원형 뷰를 나타내는 이벤트를 처리합니다.
    @objc func inactiveCenterHandleTapGesture(_ sender: UITapGestureRecognizer) {
        guard viewModel.timer == nil else { return }
        manageTabBarStatus(active: true)
        appearEvent()
    }
    
    /// 탭된 뷰의 탭 컴포넌트 이미지를 현재 탭 컴포넌트 이미지와 교환하며, 비활성 탭 바 센터 뷰에 이미지를 설정하고 사라지는 이벤트를 처리합니다.
    @objc func tabComponentHandleTapGesture(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view as? TabComponentView else { return }
        guard let image = UIImage(systemName: tappedView.tabComponent.imageName) else { return }
        swap(&tappedView.tabComponent, &viewModel.currentTabComponent.value)
        
        inactiveTabBarCenterView.image = image
        disAppearEvent()
    }
    
    /// 탭 컴포넌트 뷰에서 발생하는 팬 제스처에 대응하여 동작하는 함수입니다.
    /// 각 탭의 위치를 계산해서 이동시키고 이동이 끝났을 때, endEvent를 발생시켜 각도에 근접한 값으로 탭을 이동시킵니다.
    @objc func tabComponentHandlePanGesture(_ sender: UIPanGestureRecognizer) {
        guard let componentView = sender.view as? TabComponentView else { return }
        
        let touchPoint = sender.location(in: tabBarBackgroundSmallCirclceView)
        let translation = sender.translation(in: tabBarBackgroundSmallCirclceView)
        let movePointY = touchPoint.y + translation.y
        let movePointX = touchPoint.x + translation.x
        let currentAngle = angle(index: componentView.index)
        
        let dragAngle: Double = atan2(
            Double(movePointY - tabBarBackgroundSmallCirclceView.frame.height * 0.5),
            Double(movePointX - tabBarBackgroundSmallCirclceView.frame.width * 0.5))
        
        viewModel.rotationAngle = dragAngle - currentAngle
        
        for subview in tabBarBackgroundLargeCirclceView.subviews {
            if let subview = subview as? TabComponentView {
                let tabLocation: TabLocation = generateSubviewLocation(index: subview.index)
                
                subview.center = CGPoint(x: tabLocation.locationX, y: tabLocation.locationY)
            }
        }
        
        if sender.state == .ended {
            endEvent(location: touchPoint, index: componentView.index, dragAngle: dragAngle)
        }
    }
}

// MARK: - Bind
private extension TabbarViewController {
    
    func bindCurrentTabComponentImage() {
        viewModel.currentTabComponent
            .sink { [weak self] tabComponent in
                guard let self = self else { return }
                if let image = UIImage(systemName: tabComponent.imageName) {
                    self.activeTabBarCenterView.image = image
                }
            }
            .store(in: &cancellables)
    }
    
    func bind() {
        bindCurrentTabComponentImage()
    }
    
}

// MARK: - Animation
private extension TabbarViewController {
    func appearEvent() {
        self.viewModel.rotationAngle += self.generateAngle(per: 2)
        self.tabBarBackgroundLargeCirclceView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        viewModel.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if self.viewModel.animationStep < 2 {
                self.viewModel.animationStep += 1
                self.tabBarBackgroundLargeCirclceView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.viewModel.rotationAngle += self.generateAngle(per: 1)
                UIView.animate(withDuration: 0.1, animations: { [self] in
                    for subview in self.tabBarBackgroundLargeCirclceView.subviews {
                        if let subview = subview as? TabComponentView {
                            let tabLocation: TabLocation = generateSubviewLocation(index: subview.index)
                            subview.center = CGPoint(x: tabLocation.locationX, y: tabLocation.locationY)
                        }
                    }
                })
            } else if self.viewModel.animationStep == 2 {
                self.viewModel.animationStep += 1
                self.tabBarBackgroundLargeCirclceView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.viewModel.rotationAngle += self.generateAngle(per: 0.3)
                UIView.animate(withDuration: 0.1, animations: { [self] in
                    for subview in self.tabBarBackgroundLargeCirclceView.subviews {
                        if let subview = subview as? TabComponentView {
                            let tabLocation: TabLocation = generateSubviewLocation(index: subview.index)
                            
                            subview.center = CGPoint(x: tabLocation.locationX, y: tabLocation.locationY)
                        }
                    }
                })
            } else if self.viewModel.animationStep == 3 {
                self.viewModel.animationStep += 1
                self.tabBarBackgroundLargeCirclceView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.viewModel.rotationAngle -= self.generateAngle(per: 0.3)
                UIView.animate(withDuration: 0.1, animations: { [self] in
                    for subview in self.tabBarBackgroundLargeCirclceView.subviews {
                        if let subview = subview as? TabComponentView {
                            let tabLocation: TabLocation = generateSubviewLocation(index: subview.index)
                            
                            subview.center = CGPoint(x: tabLocation.locationX, y: tabLocation.locationY)
                        }
                    }
                })
                self.viewModel.animationStep = 0
                self.stopTimer()
            }
        }
    }
    
    func disAppearEvent() {
        self.viewModel.rotationAngle -= generateAngle(per: 1)
        viewModel.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if self.viewModel.animationStep < 2 {
                self.viewModel.animationStep += 1
                self.tabBarBackgroundLargeCirclceView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                self.viewModel.rotationAngle -= self.generateAngle(per: 1)
                UIView.animate(withDuration: 0.1, animations: { [self] in
                    for subview in self.tabBarBackgroundLargeCirclceView.subviews {
                        if let subview = subview as? TabComponentView {
                            let tabLocation: TabLocation = generateSubviewLocation(index: subview.index)
                            subview.center = CGPoint(x: tabLocation.locationX, y: tabLocation.locationY)
                        }
                    }
                })
            } else if self.viewModel.animationStep == 2 {
                self.viewModel.animationStep += 1
                self.tabBarBackgroundLargeCirclceView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.viewModel.rotationAngle -= self.generateAngle(per: 1)
                UIView.animate(withDuration: 0.1, animations: { [self] in
                    for subview in self.tabBarBackgroundLargeCirclceView.subviews {
                        if let subview = subview as? TabComponentView {
                            let tabLocation: TabLocation = generateSubviewLocation(index: subview.index)
                            
                            subview.center = CGPoint(x: tabLocation.locationX, y: tabLocation.locationY)
                        }
                    }
                })
                
                self.viewModel.animationStep = 0
                self.stopTimer()
                self.manageTabBarStatus(active: false)
            }
        }
    }
    
    /// 드래그 제스처가 종료되었을 때 발생하는 이벤트를 처리하는 함수입니다.
    /// - Parameters:
    ///   - location: 드래그 제스처가 종료된 위치입니다.
    ///   - index: 탭 컴포넌트의 인덱스입니다.
    ///   - dragAngle: 드래그 제스처에서 얻은 각도입니다.
    func endEvent(location: CGPoint, index: Int, dragAngle: Double) {
        let angleStep: Double = 2 * CGFloat.pi / CGFloat(viewModel.tabComponentArray.value.count)
        let angleRange: StrideThrough<Double> = stride(from: -Double.pi, through: Double.pi, by: angleStep)
        let anglesArray: [Double] = Array(angleRange)
        
        let redPointAngle: Double = angle(index: index)
        var minAngle: Double = 3.15
        var minAnlgeIndex: Int = 0
        for index in anglesArray.indices where abs(anglesArray[index] - dragAngle) < minAngle {
            minAngle = abs(anglesArray[index] - dragAngle)
            minAnlgeIndex = index
        }
        
        viewModel.rotationAngle = anglesArray[minAnlgeIndex] - redPointAngle
        
        for subview in tabBarBackgroundLargeCirclceView.subviews {
            if let subview = subview as? TabComponentView {
                let tabLocation: TabLocation = generateSubviewLocation(index: subview.index)
                subview.center = CGPoint(x: tabLocation.locationX, y: tabLocation.locationY)
            }
        }
    }
    
    /// 타이머를 중지하는 함수입니다. 만약 타이머가 실행 중이라면 종료하고, 타이머 객체를 해제합니다.
    func stopTimer() {
        viewModel.timer?.invalidate()
        viewModel.timer = nil
    }
    
    /// 주어진 인덱스에 따른 각도를 계산하는 함수입니다. 인덱스를 사용하여 회전하는 각도를 반환합니다.
    /// - Parameter index: 각도를 계산하기 위한 탭 컴포넌트의 인덱스입니다.
    /// - Returns: 인덱스에 해당하는 회전 각도를 반환합니다.
    func angle(index: Int) -> Double {
        let angleStep = 2 * .pi / Double(viewModel.tabComponentArray.value.count)
        return angleStep * Double(index)
    }
    
    /// 회전 각도를 계산하는 함수입니다. 입력된 비율에 따라 해당하는 각도를 생성합니다.
    /// - Parameter per 회전할 각도를 계산하기 위한 비율입니다.
    /// - Returns: per 에 해당하는 회전 각도를 반환합니다.
    func generateAngle(per: Double) -> CGFloat {
        (.pi / Double(self.viewModel.tabComponentArray.value.count) * per).truncatingRemainder(dividingBy: 2 * .pi)
    }
    
    /// TabBar의 상태에 따라 뷰의 상태를 관리합니다.
    /// - Parameter active TabBar의 Active상태 입니다.
    func manageTabBarStatus(active: Bool) {
        inactiveTabBarCenterView.isHidden = active
        tabBarBackgroundLargeCirclceView.isHidden = !active
        tabBarOpacityView.isHidden = !active
    }
}
