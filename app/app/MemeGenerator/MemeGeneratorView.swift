import SwiftUI
import Kingfisher

struct MemeGeneratorView: View {
    @State private var viewModel: MemeGeneratorViewModel

    init (template: MemeTemplate, gallery: Gallery) {
        self._viewModel = State(wrappedValue:
                                MemeGeneratorViewModel(template: template,
                                                       gallery: gallery)
        )
    }

    private struct MemeGeneratorImageView: View {
        let viewModel: MemeGeneratorViewModel

        var body: some View {
            switch viewModel.state {
                case .preview:
                    KFImage( viewModel.previewUrl)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                case .saving:
                    ZStack {
                        ProgressView("Loading...")
                        KFImage( viewModel.imageUrl)
                            .onSuccess { result in
                                viewModel.saveImage(image: result.image)
                            }
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                case .saved:
                    VStack {
                        KFImage( viewModel.imageUrl)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        HStack {
                            Image(systemName: "checkmark")
                            Text("Saved")
                        }
                        .foregroundColor(.green)
                        .bold()
                    }

                case .error(let error):
                    Text(error.localizedDescription)
                }
        }
    }

    var body: some View {
        VStack {
            MemeGeneratorImageView(viewModel: viewModel)
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
    return MemeGeneratorView(
        template: MemeTemplate.preview,
        gallery: Gallery.preview
    )
}
