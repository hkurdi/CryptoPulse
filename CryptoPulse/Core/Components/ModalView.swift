import SwiftUI

struct ModalView: View {
    let modalText: String
    let time: Double
    let iconName: String

    @Binding var show: Bool

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack {
                    Image(systemName: iconName)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color.green)
                    Text(modalText)
                        .font(.headline)
                        .foregroundColor(Color.white)
                }
                .padding(20)
                .background(Color.theme.modalColor)
                .cornerRadius(30)
                Spacer()
            }
            Spacer()
        }
        .onAppear {
            withAnimation(.bouncy(duration: 0.1)) {
                show = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                withAnimation(.easeInOut) {
                    show = false
                }
            }
        }
//        .transition(.opacity)
    }
}
