import SwiftUI
import Kingfisher

struct MemeCardView: View {
    @Environment(\.colorScheme) var colorScheme
    let meme: Meme

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ShareLink(
                item: meme.image,
                preview: SharePreview(
                    meme.lines.joined(separator: " "),
                    image: meme.image),
                label: { meme.image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(8)
                })
        }
        .padding(16)
        .background()
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16)
            .stroke(.secondary)
        )
        .shadow(radius: 2)
    }
}

 #Preview {
     MemeCardView(meme: Meme.preview)
 }
