import SwiftUI
import PhotosUI
import OSLog

let logger = Logger()

struct ContentView: View {
    @State private var gallery = Gallery()
    var body: some View {
        TabView {
            NavigationStack {
                MemeTemplateBrowserView()
                    .navigationTitle("Templates")
            }
            .tabItem {
                Label("Templates", systemImage: "book.pages")
            }

            NavigationStack {
                MemeGalleryView(gallery: gallery)
                    .navigationTitle("Gallery")
            }
            .tabItem {
                Label("Gallery", systemImage: "photo")
            }
        }
        .environment(gallery)
    }
}

#Preview {
    ContentView()
}
