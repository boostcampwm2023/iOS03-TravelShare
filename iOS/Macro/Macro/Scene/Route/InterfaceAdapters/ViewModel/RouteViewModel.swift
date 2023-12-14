//
//  RouteViewModel.swift
//  Macro
//
//  Created by Byeon jinha on 11/29/23.
//

import Combine
import Foundation
import MacroNetwork

class RouteViewModel: ViewModelProtocol, MapCollectionViewProtocol {

    // MARK: - Properties
    var travels: [TravelInfo] = [] {
        didSet {
            outputSubject.send(.changeInnerView(travels.isEmpty))
        }
    }
    private var cancellables = Set<AnyCancellable>()
    private let outputSubject = PassthroughSubject<Output, Never>()
    
    // MARK: - Input
    
    enum Input {
    }
    
    // MARK: - Output
    
    enum Output {
        case deleteTravel(String)
        case navigateToWriteView(WriteViewModel)
        case transView(TabbarType)
        case changeInnerView(Bool)
    }
}

// MARK: - Methods

extension RouteViewModel {
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { _ in
        }.store(in: &cancellables)
        
        return outputSubject.eraseToAnyPublisher()
    }
    
    func navigateToWriteView(travelInfo: TravelInfo) {
        let provider = APIProvider(session: URLSession.shared)
        let viewModel = WriteViewModel(uploadImageUseCase: UploadImage(provider: provider),
                                       uploadPostUseCase: UploadPost(provider: provider),
                                       travelInfo: travelInfo)
        self.outputSubject.send(.navigateToWriteView(viewModel))
    }
                                
    func deleteTravel(uuid: String) {
        self.outputSubject.send(.deleteTravel(uuid))
    }
}
