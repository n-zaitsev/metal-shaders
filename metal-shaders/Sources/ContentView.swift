import SwiftUI

enum SectionId: Int, Hashable {
    case `static`
    case infinite
    case configurable

    var title: String {
        switch self {
        case .static:
            return "Static"
        case .infinite:
            return "Infinite animations"
        case .configurable:
            return "Configurable animations"
        }
    }
}

struct ViewModel {
    let items: [SectionId: [ContentItem]]
}

public struct ContentView: View {
    @State private var viewModel: ViewModel = .init(items: [
        .static: [.heart],
        .infinite: [.animatedGradient, .blackWhiteCircles, .neonCircles, .archimedeanSpiral],
        .configurable: [.rhodonea],
    ])
    
    public var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.items.keys.sorted(by: { $0.rawValue < $1.rawValue }), id: \.self) { section in
                    Section(header: Text(section.title)) {
                        ForEach(viewModel.items[section] ?? [], id: \.self) { item in
                            NavigationLink(item.title) {
                                MetalViewFactory
                                    .makeView(for: item)
                                    .navigationTitle(item.title)
                            }
                        }
                    }
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
