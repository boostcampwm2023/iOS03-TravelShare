//
//  File.swift
//  Macro
//
//  Created by Byeon jinha on 11/23/23.
//

import Combine
import UIKit

final class UserInfoHeaderView: UIView {
    
    // MARK: - Properties
    var inputSubject: PassthroughSubject<UserInfoViewModel.Input, Never> = .init()
    // MARK: - UI Components
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.appColor(.purple5)
        label.font = UIFont.appFont(.baeEunLargeTitle)
        return label
    }()
    
    private let userInfoProfileView = UserInfoProfileView()
    
    private let followButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.appFont(.baeEunCallout)
        button.addTarget(self, action: #selector(tapFollowButton), for: .touchUpInside)
        
        button.backgroundColor = UIColor.appColor(.purple1)
        button.setTitleColor(UIColor.appColor(.purple3), for: .normal)
        button.setTitle(Label.follow, for: .normal)
        return button
    }()
    // MARK: - Initialization
    
    init(frame: CGRect, inputSubject: PassthroughSubject<UserInfoViewModel.Input, Never> = .init()) {
        self.inputSubject = inputSubject
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: UI Settings

extension UserInfoHeaderView {
    
    func setTranslatesAutoresizingMaskIntoConstraints() {
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userInfoProfileView.translatesAutoresizingMaskIntoConstraints = false
        followButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addsubviews() {
        self.addSubview(userNameLabel)
        self.addSubview(userInfoProfileView)
        self.addSubview(followButton)
    }
    
    func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: self.topAnchor),
            userNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            userInfoProfileView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor),
            userInfoProfileView.widthAnchor.constraint(equalToConstant: UIScreen.width - 40),
            userInfoProfileView.heightAnchor.constraint(equalToConstant: 100),
            
            followButton.topAnchor.constraint(equalTo: userInfoProfileView.bottomAnchor, constant: 20),
            followButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            followButton.widthAnchor.constraint(equalToConstant: UIScreen.width - 50),
            followButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
    }
}

// MARK: - Methods

extension UserInfoHeaderView {
    func configure(item: UserProfile) {
        self.userNameLabel.text = item.name
        userInfoProfileView.configure(item: item)
    }
    
    func updateFollow(item: FollowResponse) {
        switch item.followStatus {
        case true:
            followButton.backgroundColor = UIColor.appColor(.purple3)
            followButton.setTitleColor(UIColor.appColor(.purple1), for: .normal)
            followButton.setTitle(Label.unfollow, for: .normal)
        case false:
            followButton.backgroundColor = UIColor.appColor(.purple1)
            followButton.setTitleColor(UIColor.appColor(.purple3), for: .normal)
            followButton.setTitle(Label.follow, for: .normal)
        }
        
        userInfoProfileView.updateFollow(item: item)
    }
}

extension UIImageView {
    func makeCircular() {
        self.layer.cornerRadius = frame.size.width / 2
        self.clipsToBounds = true
    }
}

extension UserInfoHeaderView {
    @objc func tapFollowButton() {
        inputSubject.send(.tapFollowButton(userId: "asdf"))
    }
}


// MARK: - LayoutMetrics
extension UserInfoHeaderView {
    
    enum Metrics {
    }
    
    enum Label {
        static let follow: String = "Follow"
        static let unfollow: String = "Unfollow"
    }
}
