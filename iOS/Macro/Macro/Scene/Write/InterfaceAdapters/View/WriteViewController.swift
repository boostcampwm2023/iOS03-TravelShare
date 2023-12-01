//
//  WriteViewController.swift
//  Macro
//
//  Created by Byeon jinha on 11/20/23.
//

import Combine
import NMapsMap
import PhotosUI
import UIKit

final class WriteViewController: TabViewController {
    
    // MARK: - Properties
    
    private let viewModel: WriteViewModel
    private let const = MacroCarouselView.Const(itemSize: CGSize(width: UIScreen.width - 40, height: 340), itemSpacing: 24.0)
    private let imageAddSubject: PassthroughSubject<Bool, Never> = .init()
    private let didScrollSubject: PassthroughSubject<Int, Never> = .init()
    private let inputSubject: PassthroughSubject<WriteViewModel.Input, Never> = .init()
    private var subscriptions: Set<AnyCancellable> = []
    private var carouselCurrentIndex: Int = 0
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let scrollContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let isVisibilityButton: UIButton = {
        let button = UIButton()
        let image = UIImage.appImage(.lockFill)?.withTintColor(UIColor.appColor(.statusRed), renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "제목을 입력하세요..."
        textField.font = UIFont.appFont(.baeEunBody)
        textField.rightViewMode = .always
        return textField
    }()
    
    private let summaryTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.appFont(.baeEunCallout)
        textView.backgroundColor = UIColor.appColor(.purple1)
        return textView
    }()
    
    private lazy var carouselView: MacroCarouselView = {
        let view = MacroCarouselView(const: const, addImageOutputSubject: imageAddSubject, didScrollOutputSubject: didScrollSubject)
        return view
    }()
    
    private let imageDescriptionTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "문구를 입력하세요"
        textField.font = UIFont.appFont(.baeEunBody)
        return textField
    }()
    
    private let mapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.positionMode = .normal
        return mapView
    }()
    
    private let writeSubmitButton: UIButton = {
        let button = UIButton()
        button.setTitle("글 올리기", for: .normal)
        button.titleLabel?.font = UIFont.appFont(.baeEunTitle1)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.appColor(.statusGreen)
        button.layer.cornerRadius = 15
        return button
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bind()
        isVisibilityButton.addTarget(self, action: #selector(isisVisibilityButtonTouched), for: .touchUpInside)
        imageDescriptionTextField.addTarget(self, action: #selector(descriptionTextFieldDidChange), for: .editingChanged)
        writeSubmitButton.addTarget(self, action: #selector(writeSubmitButtonTouched), for: .touchUpInside)
        titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange), for: .editingChanged)
    }
    
    // MARK: - Init
    
    init(viewModel: WriteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Settings

private extension WriteViewController {
    
    func setLayout() {
        titleTextField.rightView = isVisibilityButton
        view.backgroundColor = .white
        
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
        delegateConfigure()
        hideKeyboardWhenTappedAround()
    }
    
    func setTranslatesAutoresizingMaskIntoConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        summaryTextView.translatesAutoresizingMaskIntoConstraints = false
        imageDescriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        writeSubmitButton.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addsubviews() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        [
            titleTextField,
            summaryTextView,
            carouselView,
            imageDescriptionTextField,
            mapView,
            writeSubmitButton
        ].forEach { self.scrollContentView.addSubview($0) }
    }
    
    func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            titleTextField.topAnchor.constraint(equalTo: scrollContentView.topAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 50),
            
            summaryTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            summaryTextView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 20),
            summaryTextView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -20),
            summaryTextView.heightAnchor.constraint(equalToConstant: 210),
            
            carouselView.topAnchor.constraint(equalTo: summaryTextView.bottomAnchor, constant: 20),
            carouselView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 20),
            carouselView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -20),
            carouselView.heightAnchor.constraint(equalToConstant: const.itemSize.height),
            
            imageDescriptionTextField.topAnchor.constraint(equalTo: carouselView.bottomAnchor, constant: 30),
            imageDescriptionTextField.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 50),
            imageDescriptionTextField.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -50),
            imageDescriptionTextField.heightAnchor.constraint(equalToConstant: 50),

            mapView.topAnchor.constraint(equalTo: imageDescriptionTextField.bottomAnchor, constant: 30),
            mapView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 24),
            mapView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -24),
            mapView.heightAnchor.constraint(equalToConstant: UIScreen.width - 48),
            
            writeSubmitButton.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 30),
            writeSubmitButton.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -50),
            writeSubmitButton.centerXAnchor.constraint(equalTo: scrollContentView.centerXAnchor),
            writeSubmitButton.widthAnchor.constraint(equalToConstant: UIScreen.width - 40),
            writeSubmitButton.heightAnchor.constraint(equalToConstant: 50),
            
            scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            
        ])
    }
    
    func delegateConfigure() {
        titleTextField.delegate = self
        summaryTextView.delegate = self
    }
}

// MARK: - Bind

private extension WriteViewController {
    func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        outputSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case let .isVisibilityToggle(isVisibility):
                    DispatchQueue.main.async {
                        let image = (isVisibility ? UIImage.appImage(.lockOpenFill) : UIImage.appImage(.lockFill))?.withTintColor(isVisibility ? UIColor.appColor(.statusGreen) : UIColor.appColor(.statusRed), renderingMode: .alwaysOriginal)
                        self?.isVisibilityButton.setImage(image, for: .normal)
                    }
                // imageData Cell에 추가
                case let .outputImageData(imageDatas):
                    var images = [UIImage?]()
                    
                    imageDatas.forEach {
                        images.append(UIImage(data: $0))
                    }
                    
                    self?.carouselView.updateData(images)
                // Submit 버튼 눌러진 경우
                case .postUploadSuccess:
                    let alertController = UIAlertController(title: "", message: "글 작성 완료", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "확인", style: .default) { _ in
                        if let navigationController = self?.navigationController {
                            navigationController.popViewController(animated: true)
                        } else {
                            self?.dismiss(animated: true)
                        }
                    }
                    alertController.addAction(okAction)

                    self?.present(alertController, animated: true)
                case let .outputDescriptionString(description):
                    DispatchQueue.main.async {
                        self?.imageDescriptionTextField.text = description
                    }
                }
            }
            .store(in: &subscriptions)
        
        imageAddSubject
            .sink { _ in
                self.imageAddButtonTouched()
            }
            .store(in: &subscriptions)
        
        didScrollSubject
            .receive(on: DispatchQueue.global())
            .sink { [weak self] index in
                self?.carouselCurrentIndex = index
                self?.inputSubject.send(.didScroll(self?.carouselCurrentIndex ?? 0))
            }
            .store(in: &subscriptions)
    }
}

// MARK: - objc

private extension WriteViewController {
    @objc func isisVisibilityButtonTouched() {
        inputSubject.send(.isVisibilityButtonTouched)
    }
    
    @objc func writeSubmitButtonTouched() {
        inputSubject.send(.writeSubmit)
    }
}

// MARK: - ImagePicker

extension WriteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func presentImagePickerController() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        DispatchQueue.main.async {
            self.present(imagePicker, animated: true)
        }
    }
    
    /// 사용자가 이미지를 선택했을 때
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage, let data = selectedImage.jpegData(compressionQuality: 1.0) {
            self.inputSubject.send(.addImageData(imageData: data))
        }
        dismiss(animated: true, completion: nil)
    }
    
    /// 사용자가 이미지 선택을 취소했을 때
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imageAddButtonTouched() {
        self.presentImagePickerController()
    }
}

extension WriteViewController: UITextFieldDelegate, UITextViewDelegate {
    @objc func titleTextFieldDidChange(_ sender: Any?) {
        guard let title = self.titleTextField.text else { return }
        inputSubject.send(.titleTextUpdate(title))
    }
    
    @objc func descriptionTextFieldDidChange(_ sender: Any?) {
        guard let description = self.imageDescriptionTextField.text else { return }
        inputSubject.send(.imageDescriptionUpdate(index: self.carouselCurrentIndex, description: description))
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let summarry = textView.text else { return }
        inputSubject.send(.summaryTextUpdate(summarry))
    }
}
