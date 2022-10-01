//
//  CompositionalLayout.swift
//  NetFlix
//
//  Created by MAC on 10/1/22.
//

import Foundation
import UIKit

enum CompositionalLayoutGroupAlignment {
    case vertical
    case horizontal
}
struct CompositionalLayout {
    static func createItem(width: NSCollectionLayoutDimension,
                           height: NSCollectionLayoutDimension,
                           spacing: CGFloat
    ) -> NSCollectionLayoutItem {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: width,
                                heightDimension: height))
        item.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        return item
        
    }
    
    static func createGroup (alignment: CompositionalLayoutGroupAlignment,
                             width: NSCollectionLayoutDimension,
                             height: NSCollectionLayoutDimension,
                             items: [NSCollectionLayoutItem])
    -> NSCollectionLayoutGroup {
        switch alignment {
        case .vertical:
            return NSCollectionLayoutGroup.vertical(layoutSize:NSCollectionLayoutSize(widthDimension: width,                                                                              heightDimension: height),                                         subitems: items)
            
        case .horizontal:
            return NSCollectionLayoutGroup.horizontal(layoutSize:NSCollectionLayoutSize(widthDimension: width,                                                                              heightDimension: height),                                         subitems: items)
        }
    }
    static func createGroup (alignment: CompositionalLayoutGroupAlignment,
                             width: NSCollectionLayoutDimension,
                             height: NSCollectionLayoutDimension,
                             item: NSCollectionLayoutItem,
                             count: Int)
    -> NSCollectionLayoutGroup {
        switch alignment {
        case .vertical:
            return NSCollectionLayoutGroup.vertical(layoutSize:NSCollectionLayoutSize(widthDimension: width,                                                                              heightDimension: height),                                         subitem: item,
                                                    count: count)
            
        case .horizontal:
            return NSCollectionLayoutGroup.horizontal(layoutSize:NSCollectionLayoutSize(widthDimension: width,                                                                              heightDimension: height),                                         subitem: item,
                                                      count: count)
        }
    }
}
