//
//  TodayItem.swift
//  AppStore
//
//  Created by William Yeung on 4/1/21.
//

import UIKit

struct TodayItem {
    let category: String
    let title: String
    let image: UIImage
    let description: String
    let backgroundColor: UIColor
    let cellType: CellType
    
    enum CellType: String {
        case single, multiple
    }
}
