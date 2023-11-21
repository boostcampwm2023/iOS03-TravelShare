//
//  NetworkUnresearchableViewController.swift
//  Macro
//
//  Created by Byeon jinha on 11/20/23.
//

import Combine
import MacroDesignSystem
import Network
import UIKit

protocol MonitorProtocol {
    var pathUpdateHandler: ((NWPath) -> Void)? { get set }
    
    func start(queue: DispatchQueue)
    func cancel()
}

extension NWPathMonitor: MonitorProtocol { }

final class NetworkUnresearchableViewController: UIViewController {
    
    // MARK: - Properties
    private var networkStatusSubject: PassthroughSubject<Bool, Never>
    
    private var monitor: MonitorProtocol
    
    // MARK: - UI Componenets
    
    private let networkUnresearchableImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage.appImage(.InternetDisconnectedImage)
        imageView.image = image
        return imageView
    }()
    
    private let networkUnresearchableLabel: UILabel = {
        let label = UILabel()
        label.text = Label.networkUnresearchableLabelText
        label.font = UIFont.appFont(.baeEunLargeTitle)
        label.textColor = UIColor.appColor(.purple3)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.backgroundColor = UIColor.appColor(.blue1)
        
        setLayout()
        startMonitor()
    }
    
    init(monitor: MonitorProtocol, networkStatusSubject: PassthroughSubject<Bool, Never>) {
        self.networkStatusSubject = networkStatusSubject
        self.monitor = monitor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Settings

private extension NetworkUnresearchableViewController {
    
    func setTranslatesAutoresizingMaskIntoConstraints() {
        networkUnresearchableImageView.translatesAutoresizingMaskIntoConstraints = false
        networkUnresearchableLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addSubviews() {
        self.view.addSubview(networkUnresearchableImageView)
        self.view.addSubview(networkUnresearchableLabel)
    }
    
    func setLayoutConstraints() {
        
        NSLayoutConstraint.activate([
            networkUnresearchableImageView.topAnchor.constraint(equalTo: self.view.topAnchor,
                                                                constant: Padding.networkUnresearchableImageViewTop),
            networkUnresearchableImageView.widthAnchor.constraint(equalToConstant: Metrics.networkUnresearchableImageViewWidth),
            networkUnresearchableImageView.heightAnchor.constraint(equalToConstant: Metrics.networkUnresearchableImageViewHeight),
            networkUnresearchableImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            networkUnresearchableLabel.topAnchor.constraint(equalTo: networkUnresearchableImageView.bottomAnchor,
                                                            constant: 30),
            networkUnresearchableLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    func setLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addSubviews()
        setLayoutConstraints()
    }
    
}

// MARK: - Methodes

private extension NetworkUnresearchableViewController {
    func startMonitor() {
        monitor.pathUpdateHandler = { [weak self] path in
            let isNetworkAvailable = (path.status == .satisfied)
            if isNetworkAvailable {
                DispatchQueue.main.async {
                    self?.networkStatusSubject.send(isNetworkAvailable)
                    if let navigationController = self?.navigationController {
                        navigationController.popViewController(animated: true)
                        self?.navigationController?.setNavigationBarHidden(false, animated: false)
                    }
                }
            }
        }
        
        let queue = DispatchQueue(label: Label.dispatchQueueLabel)
        monitor.start(queue: queue)
    }
}

// MARK: - LayoutMetrics

private extension NetworkUnresearchableViewController {
    
    enum Metrics {
        static let networkUnresearchableImageViewWidth: CGFloat = 200
        static let networkUnresearchableImageViewHeight: CGFloat = 396
    }
    
    enum Label {
        static let networkUnresearchableLabelText: String = "인터넷 환경을 확인해주세요."
        static let dispatchQueueLabel: String = "NetworkMonitor"
    }
    
    enum Padding {
        static let networkUnresearchableImageViewTop: CGFloat = 150
    }
}
