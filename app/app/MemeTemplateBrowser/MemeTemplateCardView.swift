import SwiftUI
import Kingfisher

struct MemeTemplateCardView: View {
    let memeTemplate: MemeTemplate

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(memeTemplate.name)
                .font(.headline)
                .bold()
                .padding(.bottom, 8)

            KFImage(URL(string: memeTemplate.example.url))
                .resizable()
                .scaledToFit()
                .cornerRadius(16)
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

struct MemeTemplateCardView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleTemplate = MemeTemplate(
            id: "aag",
            name: "Ancient Aliens Guy",
            lines: 2,
            overlays: 0,
            styles: [],
            blank: "https://api.memegen.link/images/aag.png",
            example: MemeExample(text: ["", "aliens"],
                                 url: "https://api.memegen.link/images/aag/_/aliens.png"))

        MemeTemplateCardView(memeTemplate: exampleTemplate)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
