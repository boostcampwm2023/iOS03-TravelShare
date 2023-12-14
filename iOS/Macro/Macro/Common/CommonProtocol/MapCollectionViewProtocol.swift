//
//  MapCollectionViewProtocol.swift
//  Macro
//
//  Created by Byeon jinha on 11/29/23.
//

import Combine
import UIKit

protocol MapCollectionViewProtocol: AnyObject {
    var travels: [TravelInfo] { get set }
    
    func navigateToWriteView(travelInfo: TravelInfo)
    func deleteTravel(uuid: String)
}
