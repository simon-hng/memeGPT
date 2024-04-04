import SwiftUI
import PhotosUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            MemeTemplateBrowserView()
                .navigationTitle("Browse Templates")
        }
    }
}

#Preview {
    ContentView()
}
