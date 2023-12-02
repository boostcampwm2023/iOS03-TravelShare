import UIKit

final class NameEditView: UIView {
    
    // MARK: - UI Components
    
    let optionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(.baeEunCaption)
        label.backgroundColor = UIColor.appColor(.purple1)
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.appFont(.baeEunBody)
        textField.backgroundColor = UIColor.appColor(.purple1)
        textField.borderStyle = .none
        return textField
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
extension NameEditView {
    
    private func setTranslatesAutoresizingMaskIntoConstraints() {
        optionLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addsubviews() {
        addSubview(optionLabel)
        addSubview(nameTextField)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            optionLabel.topAnchor.constraint(equalTo: topAnchor, constant: Padding.labelTop),
            optionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Padding.labelSide),
            optionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Padding.labelSide),
            optionLabel.heightAnchor.constraint(equalToConstant: Metrics.labelHeight),
            nameTextField.topAnchor.constraint(equalTo: optionLabel.bottomAnchor, constant: Padding.textFieldTop),
            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Padding.textFieldSide),
            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Padding.textFieldSide),
            nameTextField.heightAnchor.constraint(equalToConstant: Metrics.textFieldHeight)
        ])
    }
    private func setUpLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
    }
    
}

// MARK: - LayoutMetrics

extension NameEditView {
    enum Metrics {
        static let labelHeight: CGFloat = 21
        static let textFieldHeight: CGFloat = 29
    }
    
    enum Padding {
        static let labelTop: CGFloat = 10
        static let labelSide: CGFloat = 20
        static let textFieldTop: CGFloat = 4
        static let textFieldSide: CGFloat = 20
    }
}
