//
//  ContentView.swift
//  Sudoku
//
//  Created by Chris on 16/05/2022.
//

import SwiftUI

struct ContentView: View {
    @State var cells: [[Cell]]
    @State var selectedCellIndex: (x: Int, y: Int)? = nil
    let entryGridColumns: [GridItem] = Array(repeating: .init(.fixed(40)), count: 3)

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            VStack {
                ZStack {
                    // Cells
                    VStack(spacing: 0) {
                        ForEach(0..<9) { y in
                            let row = getRow(at: y)
                            let invalidRow = isHouseInvalid(row)
                            let completeRow = isHouseComplete(row)
                            HStack(spacing: 0) {
                                ForEach(0..<9) { x in
                                    let column = getColumn(at: x)
                                    let box = getBox(at: (x, y))

                                    let invalidColumn = isHouseInvalid(column)
                                    let invalidBox = isHouseInvalid(box)

                                    let completeColumn = isHouseComplete(column)
                                    let completeBox = isHouseComplete(box)

                                    let isComplete = completeRow || completeColumn || completeBox
                                    let isInvalid = invalidRow || invalidColumn || invalidBox
                                    let isSelected = (x, y) == selectedCellIndex ?? (10, 10)

                                    let fillColor: Color = isSelected ? .yellow : isComplete ? .green : isInvalid ? .red : .clear

                                    ZStack {
                                        Rectangle().fill(fillColor)

                                        CellView(cell: cells[y][x])
                                            .onTapGesture {
                                                selectedCellIndex = (x, y)
                                            }
                                    }
                                }
                            }
                        }
                    }

                    // Box borders
                    VStack(spacing: 0) {
                        ForEach(0..<3) { _ in
                            HStack(spacing: 0) {
                                ForEach(0..<3) { _ in
                                    Rectangle().strokeBorder(.black, lineWidth: 1).frame(width: width/3, height: width/3)
                                }
                            }
                        }
                    }
                }
                .frame(width: geo.size.width, height: geo.size.width)
                .border(.black, width: 2)

                HStack {
                    VStack {
                        Text("Entry").font(.title)
                        LazyVGrid(columns: entryGridColumns) {
                            ForEach(1..<10) { number in
                                Button {
                                    print("\(number) pressed")
                                    if let selectedCellIndex = selectedCellIndex {
                                        cells[selectedCellIndex.y][selectedCellIndex.x].entry = number
                                    }
                                } label: {
                                    Text(String(number)).font(.title).frame(width: 40, height: 40)
                                }

                            }
                        }
                    }
                    VStack {
                        Text("Markers").font(.title)
                        LazyVGrid(columns: entryGridColumns) {
                            ForEach(1..<10) { number in
                                Button {
                                    guard let index = selectedCellIndex else { return }
                                    if cells[index.y][index.x].markers.contains(number) {
                                        cells[index.y][index.x].markers.remove(number)
                                    } else {
                                        cells[index.y][index.x].markers.insert(number)
                                    }

                                } label: {
                                    Text(String(number)).font(.title).frame(width: 40, height: 40)
                                }

                            }
                        }
                    }
                }
                Button {
                    guard let index = selectedCellIndex else { return }
                    cells[index.y][index.x].entry = nil
                    cells[index.y][index.x].markers = []
                } label: {
                    Text("Clear cell").font(.title).foregroundColor(.red)
                }
            }
        }
        .padding()
    }
}

// MARK: Sudoku logic
extension ContentView {
    private func getRow(at index: Int) -> [Int?] {
        cells[index].map({ $0.entry })
    }

    private func getColumn(at index: Int) -> [Int?] {
        cells.map({ $0[index].entry })
    }

    private func getBox(at index: (x: Int, y: Int)) -> [Int?] {
        let yRange = [(0..<3), (3..<6), (6..<9)].first(where: { $0.contains(index.y) })!
        let xRange = [(0..<3), (3..<6), (6..<9)].first(where: { $0.contains(index.x) })!
        var boxEntries: [Int?] = []
        for y in yRange {
            for x in xRange {
                boxEntries.append(cells[y][x].entry)
            }
        }
        return boxEntries
    }

    private func isHouseInvalid(_ house: [Int?]) -> Bool {
        let nonOptionals = house.compactMap({ $0 })
        return nonOptionals.count != Set(nonOptionals).count
    }

    private func isHouseComplete(_ house: [Int?]) -> Bool {
        let nonOptionals = house.compactMap({ $0 })
        return nonOptionals.count == 9 && Set(nonOptionals).count == 9
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(cells: Array.init(repeating: Array.init(repeating: Cell(entry: nil, markers: []), count: 9), count: 9))
    }
}
