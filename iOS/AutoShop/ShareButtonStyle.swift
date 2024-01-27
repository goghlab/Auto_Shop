import SwiftUI

struct SharedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.blue))
    }
}
