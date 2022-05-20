//

import SwiftUI

struct GridCellsView: View {
    let cells: [[Cell]]
    let getState: (CellIndex) -> CellState
    @Binding var selectedIndex: CellIndex?

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<9) { y in
                HStack(spacing: 0) {
                    ForEach(0..<9) { x in
                        ZStack {
                            CellView(cell: cells[y][x], state: getState((x, y)))
                                .onTapGesture {
                                    selectedIndex = (x, y)
                                }
                        }
                    }
                }
            }
        }
    }
}

//struct GridCellsView_Previews: PreviewProvider {
//    static var previews: some View {
//        GridCellsView()
//    }
//}
