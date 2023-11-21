//
//  TabBarViewController+Animaion.swift
//  Macro
//
//  Created by Byeon jinha on 11/21/23.
//

import UIKit

// MARK: - Animation
internal extension TabBarViewController {
    func appearEvent() {
        self.viewModel.rotationAngle += self.generateAngle(per: 2)
        self.tabBarBackgroundLargeCirclceView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        viewModel.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if !self.viewModel.isTabBarActive { return }
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
                self.manageTabBarStatus(active: self.viewModel.isTabBarActive)
            }
        }
    }
    
    func disAppearEvent() {
        self.viewModel.rotationAngle -= generateAngle(per: 1)
        viewModel.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if self.viewModel.isTabBarActive { return }
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
                self.manageTabBarStatus(active: self.viewModel.isTabBarActive)
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
