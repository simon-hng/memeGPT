import SwiftUI
import Kingfisher

struct MemeGeneratorView: View {
    @State private var viewModel: MemeGeneratorViewModel

    init (template: MemeTemplate) {
        self._viewModel = State(wrappedValue: MemeGeneratorViewModel(template: template))
    }

    var body: some View {
        VStack {
            KFImage(viewModel.previewUrl)
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
            Spacer()
            VStack {
                ForEach($viewModel.lines) { line in
                    TextField("Line \(line.index.wrappedValue + 1)",
                              text: line.string)
                        .textFieldStyle(.roundedBorder)
                }
            }
            Button(action: viewModel.save, label: {
                Label("Save", systemImage: "square.and.arrow.down")
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .padding(.vertical, 48)
    }
}

#Preview {
    let exampleTemplate = MemeTemplate(
        id: "aag",
        name: "Ancient Aliens Guy",
        lines: 2,
        overlays: 0,
        styles: [],
        blank: "https://api.memegen.link/images/aag.png",
        example: MemeExample(text: ["aliens"],
                             url: "https://api.memegen.link/images/aag/_/aliens.png"))
    return MemeGeneratorView(template: exampleTemplate)
}
