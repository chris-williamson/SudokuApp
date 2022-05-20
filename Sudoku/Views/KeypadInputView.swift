//

import SwiftUI

struct KeypadInputView: View {
    let title: String
    let numberTapAction: (Int) -> ()
    let entryGridColumns: [GridItem] = Array(repeating: .init(.fixed(40)), count: 3)

    var body: some View {
        VStack {
            Text(title).font(.title)
            LazyVGrid(columns: entryGridColumns) {
                ForEach(1..<10) { number in
                    Button {
                        numberTapAction(number)
                    } label: {
                        Text(String(number)).font(.title).frame(width: 40, height: 40)
                    }

                }
            }
        }
    }
}

//struct KeypadInputView_Previews: PreviewProvider {
//    static var previews: some View {
//        KeypadInputView()
//    }
//}
