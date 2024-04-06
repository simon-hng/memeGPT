import SwiftUI

struct MemeGalleryView: View {
    @State private var viewModel: MemeGalleryViewModel

    init (gallery: Gallery) {
        self._viewModel = State(wrappedValue:
                                MemeGalleryViewModel(gallery: gallery)
        )
    }
    var body: some View {
        VStack {
            if viewModel.gallery.memes.isEmpty {
                HStack {
                    Image(systemName: "questionmark.folder")
                    Text("no memes here yet")
                }
            } else {
                List(viewModel.gallery.memes) { meme in
                    MemeCardView(meme: meme)
                        .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
            }
        }
    }
}

#Preview {
    MemeGalleryView(gallery: Gallery.preview)
}
