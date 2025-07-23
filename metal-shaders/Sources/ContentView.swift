import SwiftUI

struct ViewModel {
    let items: [ContentItem]
}

public struct ContentView: View {
    @State private var viewModel: ViewModel = .init(items: [.animatedGradient])

    public var body: some View {
        NavigationStack {
            List(viewModel.items) { item in
                NavigationLink(item.title) {
                    MetalViewRepresentable(animationSpeed: 1.0, contentItem: item)
                        .navigationTitle(item.title)
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
