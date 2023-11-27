//
//  TabBarViewController.swift
//  Macro
//
//  Created by Byeon jinha on 11/14/23.
//

import Combine
import UIKit

final class TabBarViewController: UIViewController {
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    internal let viewModel: TabBarViewModel
    
    // MARK: - UI Components
    internal let tabBarBackgroundLargeCirclceView: TabBarBackgroundLargeCirclceView = TabBarBackgroundLargeCirclceView()
    private let tabBarBackgroundSmallCirclceView: TabBarBackgroundSmallCirclceView = TabBarBackgroundSmallCirclceView()
    private let activeTabBarCenterView: TabBarCenterView = TabBarCenterView()
    internal let inactiveTabBarCenterView: TabBarCenterView = TabBarCenterView()
    internal let tabBarOpacityView: TabBarOpacityView = TabBarOpacityView()
    private let tabBarBackgroundLineView: TabBarBackgroundLineView = TabBarBackgroundLineView()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        self.addChild(viewModel.currentTabComponent.value.viewController)
        configure()
        setUpLayout()
        bind()
        manageTabBarStatus(active: viewModel.isTabBarActive)
    
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
internal extension TabBarViewController {
    
    func configure() {
        self.view.backgroundColor = UIColor.appColor(.blue1)
        self.navigationController?.navigationBar.tintColor = UIColor.appColor(.purple4)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func setupTranslatesAutoresizingMaskIntoConstraints() {
        tabBarBackgroundLargeCirclceView.translatesAutoresizingMaskIntoConstraints = false
        tabBarBackgroundSmallCirclceView.translatesAutoresizingMaskIntoConstraints = false
        activeTabBarCenterView.translatesAutoresizingMaskIntoConstraints = false
        inactiveTabBarCenterView.translatesAutoresizingMaskIntoConstraints = false
        tabBarBackgroundLineView.translatesAutoresizingMaskIntoConstraints = false
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
        
        view.addSubview(viewModel.currentTabComponent.value.viewController.view)
        view.addSubview(tabBarBackgroundLineView)
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
            
            tabBarBackgroundLineView.heightAnchor.constraint(equalToConstant: 60),
            tabBarBackgroundLineView.leadingAnchor.constraint(equalTo: tabBarOpacityView.leadingAnchor),
            tabBarBackgroundLineView.trailingAnchor.constraint(equalTo: tabBarOpacityView.trailingAnchor),
            tabBarBackgroundLineView.bottomAnchor.constraint(equalTo: tabBarOpacityView.bottomAnchor),
            
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
        activeTabBarCenterView.addGestureRecognizer(inactiveCenterTapGesture)
        
        let inactiveOpacityViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(inactiveCenterHandleTapGesture(_:)))
        tabBarOpacityView.addGestureRecognizer(inactiveOpacityViewTapGesture)
        
        let activCenterTapGesture = UITapGestureRecognizer(target: self, action: #selector(activeCenterHandleTapGesture(_:)))
        inactiveTabBarCenterView.addGestureRecognizer(activCenterTapGesture)
        
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
private extension TabBarViewController {
    
    /// 타이머가 활성화되어 있지 않은 경우, 사라지는 이벤트를 처리합니다.
    @objc func inactiveCenterHandleTapGesture(_ sender: UITapGestureRecognizer) {
        guard viewModel.timer == nil else { return }
        self.viewModel.isTabBarActive = false
        disAppearEvent()
    }
    
    /// 타이머가 활성화되어 있지 않은 경우, 비활성 탭 바 센터 뷰를 숨기고 탭 바 큰 원형 뷰를 나타내는 이벤트를 처리합니다.
    @objc func activeCenterHandleTapGesture(_ sender: UITapGestureRecognizer) {
        guard viewModel.timer == nil else { return }
        self.viewModel.isTabBarActive = true
        appearEvent()
    }
    
    /// 탭된 뷰의 탭 컴포넌트 이미지를 현재 탭 컴포넌트 이미지와 교환하며, 비활성 탭 바 센터 뷰에 이미지를 설정하고 사라지는 이벤트를 처리합니다.
    @objc func tabComponentHandleTapGesture(_ sender: UITapGestureRecognizer) {
        guard viewModel.timer == nil else { return }
        
        guard let tappedView = sender.view as? TabComponentView,
        let image = tappedView.tabComponent.image
        else { return }
        
        viewModel.currentTabComponent.value.viewController.view.removeFromSuperview()
        viewModel.currentTabComponent.value.viewController.removeFromParent()
        self.view.insertSubview(tappedView.tabComponent.viewController.view, belowSubview: tabBarBackgroundLineView)
        swap(&tappedView.tabComponent, &viewModel.currentTabComponent.value)
        self.addChild(viewModel.currentTabComponent.value.viewController)
        inactiveTabBarCenterView.image = image
        self.viewModel.isTabBarActive = false
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
private extension TabBarViewController {
    
    func bindCurrentTabComponentImage() {
        viewModel.currentTabComponent
            .sink { [weak self] tabComponent in
                guard let self = self else { return }
                if let image = tabComponent.image {
                    self.activeTabBarCenterView.image = image
                }
            }
            .store(in: &cancellables)
    }
    
    func bind() {
        bindCurrentTabComponentImage()
    }
    
}
