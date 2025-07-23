import SwiftUI

struct ViewModel {
    let items: [ContentItem]
}

public struct ContentView: View {
    @State private var viewModel: ViewModel = .init(items: ContentItem.allCases)

    public var body: some View {
        NavigationStack {
            List(viewModel.items) { item in
                NavigationLink(item.title) {
                    MetalViewRepresentable(animationSpeed: item.animationSpeed, contentItem: item)
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
