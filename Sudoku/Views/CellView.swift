//
//  Cell.swift
//  Sudoku
//
//  Created by Chris on 16/05/2022.
//

import SwiftUI

struct Cell {
    var entry: Int?
    var markers: Set<Int>
}

struct CellView: View {
    let cell: Cell
    
    private let threeColumnGrid = [
        GridItem(.flexible(minimum: 0, maximum: .infinity)),
        GridItem(.flexible(minimum: 0, maximum: .infinity)),
        GridItem(.flexible(minimum: 0, maximum: .infinity))
    ]

    var body: some View {
        GeometryReader { geo in
            let padding: CGFloat = geo.size.width / 20
            let entryFontSize: CGFloat = geo.size.width / 1.5
            let entryFont: Font = .system(size: entryFontSize)
            let markerFontSize: CGFloat = geo.size.width / 5
            let markerFont: Font = .system(size: markerFontSize)
            let rowSpacing: CGFloat = geo.size.width * 0.075

            ZStack {
                Rectangle()
                    .strokeBorder(.black, lineWidth: 0.25)
                Group {
                    if let entry = cell.entry {
                        Text(String(entry)).font(entryFont)
                    } else {
                        LazyVGrid(columns: threeColumnGrid, spacing: rowSpacing) {
                            ForEach((1...9), id: \.self) {
                                if cell.markers.contains($0) {
                                    Text(String($0)).font(markerFont)
                                } else {
                                    Text(" ").font(markerFont)
                                }
                             }
                         }.font(.largeTitle)
                    }
                }
                .padding(EdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding))
            }
        }
    }
}

struct Cell_Previews: PreviewProvider {
    static let width: CGFloat = 100
    static let padding: CGFloat = 5
    
    static var previews: some View {
        VStack {
            HStack(spacing: 0) {
                CellView(cell: Cell(entry: nil, markers: [1, 2, 3, 4, 5, 6, 7, 8, 9]))
                    .frame(width: width, height: width)
//                    .border(.black)
                CellView(cell: Cell(entry: nil, markers: [2, 5, 8]))
                    .frame(width: width, height: width)
//                    .border(.black)
                CellView(cell: Cell(entry: 9, markers: [2, 5, 8]))
                    .frame(width: width, height: width)
//                    .border(.black)
            }
        }
    }
}
