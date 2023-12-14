//
//  CarouselProtocol.swift
//  Macro
//
//  Created by Byeon jinha on 12/4/23.
//

import UIKit

protocol CarouselViewProtocol: AnyObject {
    
    var items: [UIImage?] { get set }
    var carouselCurrentIndex: Int { get set }
    var pageIndex: Int { get set }
    
}
