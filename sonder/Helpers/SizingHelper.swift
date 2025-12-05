//
//  SizingHelper.swift
//  sonder
//
//  Created by Bryan Sample on 12/2/25.
//

import SwiftUI

struct SizingHelper {
    
    static func sizeByHorizontalSection(_ sectionCount: CGFloat, within width: CGFloat, padding: CGFloat = Constants.padding) -> CGFloat {
        let spacingCount = sectionCount + 1
        return (width - (spacingCount * padding)) / sectionCount
    }
    
    static func sizeByHorizontalSection(_ sectionCount: CGFloat, geometry: GeometryProxy, padding: CGFloat = Constants.padding) -> CGFloat {
        sizeByHorizontalSection(sectionCount, within: geometry.size.width, padding: padding)
    }
    
}
