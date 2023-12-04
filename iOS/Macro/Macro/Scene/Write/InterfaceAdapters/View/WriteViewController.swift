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
    private let imageAddSubject: PassthroughSubject<Bool, Never> = .init()
    private let didScrollSubject: PassthroughSubject<Int, Never> = .init()
    private let inputSubject: PassthroughSubject<WriteViewModel.Input, Never> = .init()
    private var subscriptions: Set<AnyCancellable> = []
    private var routeOverlay: NMFPath?
    
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
        textField.placeholder = "제목을 입력하세요..."
        textField.borderStyle = .none
        textField.font = UIFont.appFont(.baeEunBody)
        textField.rightViewMode = .always
        return textField
    }()
    
    private let summaryTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 10
        textView.font = UIFont.appFont(.baeEunCallout)
        textView.backgroundColor = UIColor.appColor(.purple1)
        return textView
    }()
    
    private lazy var carouselView: MacroCarouselView = MacroCarouselView(addImageOutputSubject: imageAddSubject, didScrollOutputSubject: didScrollSubject, inputSubject: self.inputSubject, viewModel: viewModel)
    
    private let mapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.positionMode = .normal
        return mapView
    }()
    
    private let writeSubmitButton: UIButton = {
        let button = UIButton()
        button.setTitle("글 올리기", for: .normal)
        button.titleLabel?.font = UIFont.appFont(.baeEunTitle1)
        button.setTitleColor(UIColor.appColor(.purple4), for: .normal)
        button.backgroundColor = UIColor.appColor(.purple1)
        button.layer.cornerRadius = 15
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bind()
        addTarget()
        self.inputSubject.send(.loadTravel)
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
    
    func setTranslatesAutoresizingMaskIntoConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        summaryTextView.translatesAutoresizingMaskIntoConstraints = false
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
            carouselView.heightAnchor.constraint(equalToConstant: 400),
            carouselView.widthAnchor.constraint(equalToConstant: UIScreen.width),

            mapView.topAnchor.constraint(equalTo: carouselView.bottomAnchor, constant: 30),
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
        carouselView.descriptionTextField.delegate = self
    }
    
    func setLayout() {
        titleTextField.rightView = isVisibilityButton
        view.backgroundColor = .white
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
        delegateConfigure()
        hideKeyboardWhenTappedAround()
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
                        self?.carouselView.descriptionTextField.text = description
                    }
                case let .updatePageIndex(index):
                    self?.updatePageIndex(index)
                case let .updateMap(travel):
                    guard let recordedLocation = travel.recordedLocation else { return }
                    guard let recordedPinedInfo = travel.recordedPinnedLocations else { return }
                    self?.calculateCenterLocation(routePoints: recordedLocation)
                    self?.updateMapWithLocation(routePoints: recordedLocation)
                    
                    self?.updateMark(recordedPindedInfo: recordedPinedInfo)
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
                self?.viewModel.carouselCurrentIndex = index
                self?.inputSubject.send(.didScroll(self?.viewModel.carouselCurrentIndex ?? 0))
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

// MARK: - Methods
extension WriteViewController {
    
    func updatePageIndex(_ index: Int) {
        self.carouselView.pageController.currentPage = viewModel.pageIndex
        self.didScrollSubject.send(viewModel.pageIndex)
    }
    
    func addTarget() {
        isVisibilityButton.addTarget(self, action: #selector(isisVisibilityButtonTouched), for: .touchUpInside)
        writeSubmitButton.addTarget(self, action: #selector(writeSubmitButtonTouched), for: .touchUpInside)
        titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange), for: .editingChanged)
    }
    
    func calculateCenterLocation(routePoints: [[Double]]) {
        var maxLatitude = -90.0
        var minLatitude = 90.0
        var maxLongitude = -180.0
        var minLongitude = 180.0
        
        for point in routePoints {
            let latitude = point[0]
            let longitude = point[1]
            
            if latitude > maxLatitude {
                maxLatitude = latitude
            }
            if latitude < minLatitude {
                minLatitude = latitude
            }
            if longitude > maxLongitude {
                maxLongitude = longitude
            }
            if longitude < minLongitude {
                minLongitude = longitude
            }
        }
        
        let centerLatitude = (maxLatitude + minLatitude) / 2.0
        let centerLongitude = (maxLongitude + minLongitude) / 2.0
        
        let centerLocation = NMGLatLng(lat: centerLatitude, lng: centerLongitude)
        let distanceLatitude = abs(maxLatitude - minLatitude)
        let distanceLongitude = abs(maxLongitude - minLongitude)
        
        let zoomLevelLatitude = log2(90 / distanceLatitude)
        let zoomLevelLongitude = log2(90 / distanceLongitude)
        let zoomLevel = min(zoomLevelLatitude, zoomLevelLongitude)
        mapView.zoomLevel = zoomLevel
       
        let cameraUpdate = NMFCameraUpdate(scrollTo: centerLocation )
        mapView.moveCamera(cameraUpdate)
    }
    
    /// 이동 경로를 입력받아 지도에 그립니다.
    /// - Parameters:
    ///   - routePoints: 위도, 경도 배열 입니다.
    func updateMapWithLocation(routePoints: [[Double]]) {
        routeOverlay?.mapView = nil
        let coords = routePoints.map { NMGLatLng(lat: $0[0], lng: $0[1]) }
        routeOverlay = NMFPath(points: coords)
        routeOverlay?.color = UIColor.appColor(.purple1)
        routeOverlay?.mapView = mapView
    }
    
    // TODO: - 위경도 좌표가 바뀌어 있어요. 다음 스프린트 때, 코어데이터 테이블 추가하면서 수정하도록하겠습니다. :)
    /// Pin이 저장된 곳에  Mark를 찍습니다.
    /// - Parameters:
    ///   - recordedPindedInfo: Pin의 위도, 경도 배열 입니다.
    func updateMark(recordedPindedInfo: [RecordedPinnedLocationInfomation]) {
        for (index, placeInfo) in recordedPindedInfo.enumerated() {
            let marker = NMFMarker()
            guard let name = placeInfo.placeName?.first, let placeLocation = placeInfo.coordinate else { return }
            marker.position = NMGLatLng(lat: placeLocation.latitude, lng: placeLocation.longitude)
            marker.captionText = "\(index + 1). \(name)"
            marker.mapView = mapView
        }
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
    
    func textViewDidChange(_ textView: UITextView) {
        guard let summary = textView.text else { return }
        inputSubject.send(.summaryTextUpdate(summary))
    }
}
