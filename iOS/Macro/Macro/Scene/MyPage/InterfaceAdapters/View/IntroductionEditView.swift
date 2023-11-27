//
//  IntroductionView.swift
//  Macro
//
//  Created by 김나훈 on 11/27/23.
//

import UIKit

final class IntroductionEditView: UIView {
    
    // MARK: - UI Components
    
    let optionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(.baeEunCaption)
        label.backgroundColor = UIColor.appColor(.purple1)
        return label
    }()
    
    let introductionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.appFont(.baeEunBody)
        textView.backgroundColor = UIColor.appColor(.purple1)
        return textView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.appColor(.purple1)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UI Settings
extension IntroductionEditView {
    
    private func setTranslatesAutoresizingMaskIntoConstraints() {
        optionLabel.translatesAutoresizingMaskIntoConstraints = false
        introductionTextView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addsubviews() {
        addSubview(optionLabel)
        addSubview(introductionTextView)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            optionLabel.topAnchor.constraint(equalTo: topAnchor, constant: Padding.labelTop),
            optionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Padding.labelSide),
            optionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Padding.labelSide),
            optionLabel.heightAnchor.constraint(equalToConstant: Metrics.labelHeight),
            introductionTextView.topAnchor.constraint(equalTo: optionLabel.bottomAnchor, constant: Padding.textFieldTop),
            introductionTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Padding.textFieldSide),
            introductionTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Padding.textFieldSide),
            introductionTextView.heightAnchor.constraint(equalToConstant: Metrics.textFieldHeight)
        ])
    }
    
}

extension IntroductionEditView {
    
    private func setUpLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
    }
    
}

// MARK: - Methods

extension IntroductionEditView {
    
}

// MARK: - LayoutMetrics

extension IntroductionEditView {
    enum Metrics {
        static let labelHeight: CGFloat = 21
        static let textFieldHeight: CGFloat = 100
    }
    
    enum Padding {
        static let labelTop: CGFloat = 10
        static let labelSide: CGFloat = 20
        static let textFieldTop: CGFloat = 4
        static let textFieldSide: CGFloat = 20
    }
}
