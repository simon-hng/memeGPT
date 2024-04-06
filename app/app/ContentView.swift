import SwiftUI
import PhotosUI

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
