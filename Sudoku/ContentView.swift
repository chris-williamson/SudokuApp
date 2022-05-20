//
//  ContentView.swift
//  Sudoku
//
//  Created by Chris on 16/05/2022.
//

import SwiftUI

typealias CellIndex = (x: Int, y: Int)

struct ContentView: View {
    @State var cells: [[Cell]]
    @State var selectedCellIndex: CellIndex? = nil

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            VStack {
                ZStack {
                    // Cells
                    GridCellsView(cells: cells, getState: getStateForCell(at:), selectedIndex: $selectedCellIndex)

                    // Box borders
                    BoxBordersView(boxWidth: width/3)
                }
                .frame(width: geo.size.width, height: geo.size.width)
                .border(.black, width: 2)

                HStack {
                    KeypadInputView(title: "Entry") { number in
                        guard let index = selectedCellIndex else { return }
                        cells[index.y][index.x].entry = number
                    }
                    KeypadInputView(title: "Markers") { number in
                        guard let index = selectedCellIndex else { return }
                        let markers = cells[index.y][index.x].markers
                        if markers.contains(number) {
                            cells[index.y][index.x].markers.remove(number)
                        } else {
                            cells[index.y][index.x].markers.insert(number)
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

// MARK: State
extension ContentView {
    private func getStateForCell(at index: CellIndex) -> CellState {
        if (index.x, index.y) == selectedCellIndex ?? (10, 10) { return .selected }

        let row = getRow(at: index.y)
        let column = getColumn(at: index.x)
        let box = getBox(at: (index.x, index.y))

        let completeColumn = isHouseComplete(column)
        let completeBox = isHouseComplete(box)
        let completeRow = isHouseComplete(row)
        if completeColumn || completeBox || completeRow { return .complete }

        let invalidColumn = isHouseInvalid(column)
        let invalidBox = isHouseInvalid(box)
        let invalidRow = isHouseInvalid(row)
        if invalidColumn || invalidBox || invalidRow { return .invalid }

        return .incomplete
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

    private func getBox(at index: CellIndex) -> [Int?] {
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
