//

import SwiftUI

struct BoxBordersView: View {
    let boxWidth: CGFloat

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<3) { _ in
                HStack(spacing: 0) {
                    ForEach(0..<3) { _ in
                        Rectangle().strokeBorder(.black, lineWidth: 1).frame(width: boxWidth, height: boxWidth)
                    }
                }
            }
        }
    }
}

struct BoxBordersView_Previews: PreviewProvider {
    static var previews: some View {
        BoxBordersView(boxWidth: 10)
    }
}
