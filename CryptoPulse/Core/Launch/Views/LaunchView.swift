import SwiftUI

struct LaunchView: View {
    
    @State private var loadingTexts: [String] = [
        "Checking your digital piggy bank...",
        "Decrypting your treasure chest...",
        "Summoning your crypto assets...",
        "Turning coins into magic...",
        "Counting your digital coins..."
    ]
    
    @State private var showLoadingText: Bool = false
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    @State private var counter: Int = 1
    @State private var loops: Int = 1
    
    @Binding var showLaunchView: Bool
    
    private var randomLoadingText: String {
        loadingTexts.randomElement() ?? "Loading..."
    }
    
    var body: some View {
        ZStack {
            Color.launch.background
                .ignoresSafeArea()
            
            Image("logo-transparent")
                .resizable()
                .frame(width: 100, height: 100)
            if showLoadingText {
                HStack(spacing: 0) {
                Text(randomLoadingText)
                    .font(.headline)
                    .foregroundStyle(Color.launch.accent)
                    .fontWeight(.heavy)
                    .offset(y: Int(counter) % randomLoadingText.count == 0 ? 0 : 2)
                    .transition(AnyTransition.scale.animation(.smooth))
                    .offset(y: 70)
            }
        }
        }
        .onAppear {
            withAnimation(.easeInOut) {
                showLoadingText.toggle()
            }
        }
        .onReceive(timer) { _ in
            withAnimation(.easeInOut) {
                
                let lastIndex = loadingTexts.count - 1
                if counter == lastIndex {
                    counter = 0
                    loops += 1
                    if loops >= 2 {
                        showLaunchView = false
                    }
                } else {
                    counter += 1
                }

            }
        }
    }
}

#Preview {
    LaunchView(showLaunchView: .constant(true))
}
