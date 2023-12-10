//
//  SearchResultViewController.swift
//  Macro
//
//  Created by 김나훈 on 11/16/23.
//

import Combine
import MacroNetwork
import UIKit

final class SearchResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties

    private let viewModel: TravelViewModel
    private let inputSubject: PassthroughSubject<TravelViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private var tableView: UITableView!
    
    lazy var dataEmptyView: DataEmptyView = DataEmptyView(
        emptyTitle: "검색 정보가 없습니다."
    )
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setTableView()
        setupLayout()
        bind()
    }
    
    // MARK: - Init
    
    init(viewModel: TravelViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UI Settings

extension SearchResultViewController {
    
    private func setTableView() {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func setTranslatesAutoresizingMaskIntoConstraints() {
       
        tableView.translatesAutoresizingMaskIntoConstraints = false
        dataEmptyView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    private func addsubviews() {
        view.addSubview(tableView)
        view.addSubview(dataEmptyView)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            dataEmptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dataEmptyView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150)
        ])
    }
    
    private func setupLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
    }
}
// MARK: - Bind
extension SearchResultViewController {
    private func bind() {
        viewModel.transform(with: inputSubject.eraseToAnyPublisher())
            .sink { [weak self] output in
                switch output {
                case .updateSearchResult:
                    self?.tableView.reloadData()
                case let .transViewBySearchedResultCount(isEmpty):
                    self?.transViewBySearchedResultCount(isEmpty)
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Methods

extension SearchResultViewController {
    
    @objc func pinLocation(_ sender: UIButton) {
        let location = viewModel.searchedResult[sender.tag]
        viewModel.togglePinnedPlaces(location)
        let isPinnedNow = viewModel.isPinned(location)
        let pinImage = isPinnedNow ? UIImage.appImage(.pinFill) : UIImage.appImage(.pin)
        sender.setImage(pinImage, for: .normal)
    }
    
    func transViewBySearchedResultCount(_ isEmpty: Bool) {
        DispatchQueue.main.async {
            self.tableView.isHidden = isEmpty
            self.dataEmptyView.isHidden = !isEmpty
        }
    }
}

// MARK: - TableView

extension SearchResultViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DispatchQueue.main.async {
            self.tableView.isHidden = self.viewModel.searchedResult.isEmpty
            self.dataEmptyView.isHidden = !self.viewModel.searchedResult.isEmpty
        }
        return viewModel.searchedResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
           let locationDetail = viewModel.searchedResult[indexPath.row]

           let cellText = "\(locationDetail.placeName)\n\(   locationDetail.addressName)"
           cell.textLabel?.text = cellText
           cell.textLabel?.numberOfLines = 0
           cell.textLabel?.font = UIFont.appFont(.baeEunCallout)
           let pinButton = UIButton(type: .custom)
           let pinImage = viewModel.isPinned(locationDetail) ? UIImage.appImage(.pinFill) : UIImage.appImage(.pin)
           pinButton.setImage(pinImage, for: .normal)
           pinButton.tintColor = UIColor.appColor(.purple4)
           pinButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
           pinButton.addTarget(self, action: #selector(pinLocation(_:)), for: .touchUpInside)
           cell.accessoryView = pinButton
           pinButton.tag = indexPath.row
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let provider = APIProvider(session: URLSession.shared)
        let locationViewModel = LocationInfoViewModel(locationDetail: viewModel.searchedResult[indexPath.row], searcher: Searcher(provider: provider))
        let locationInfoVC = LocationInfoViewController(viewModel: locationViewModel)
        navigationController?.pushViewController(locationInfoVC, animated: true)
    }
}
