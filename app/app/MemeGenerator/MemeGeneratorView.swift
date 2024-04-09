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
                        KFImage(viewModel.imageUrl)
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
                case .loading:
                    ProgressView("Generating AI Meme...")
                }
        }
    }

    private struct UseCaseView: View {
        @Bindable var viewModel: MemeGeneratorViewModel

        var body: some View {
            switch viewModel.selectedUseCase {
            case .manual:
                VStack {
                    ForEach($viewModel.lines) { line in
                        TextField("Line \(line.index.wrappedValue + 1)",
                                  text: line.string)
                        .textFieldStyle(.roundedBorder)
                    }
                }

            case .gpt:
                TextField("Meme about Stephan Krusche", text: $viewModel.suggestionPrompt)
                    .textFieldStyle(.roundedBorder)
                Button(action: {
                    Task { await viewModel.generateSuggestion() }
                }, label: {
                    Label("Generate meme", systemImage: "brain")
                        .frame(maxWidth: .infinity)
                })
                .buttonStyle(.bordered)

            case .info:
                VStack {
                    Text("Meme information")
                        .font(.custom("impact", size: 34))
                    Link(destination: viewModel.memeInformationUrl, label: {
                        Text("Find out more on knowyourmeme")
                            .frame(maxWidth: .infinity)
                    })
                }
                .padding()
            }
        }
    }

    var body: some View {
        VStack {
            MemeGeneratorImageView(viewModel: viewModel)
                .padding(.bottom, 64)
            Picker("useCase", selection: $viewModel.selectedUseCase) {
                Text("Manual").tag(MemeGeneratorViewModel.UseCase.manual)
                Text("GPT").tag(MemeGeneratorViewModel.UseCase.gpt)
                Text("Information").tag(MemeGeneratorViewModel.UseCase.info)
            }
            .pickerStyle(.segmented)
            .padding(.bottom, 16)

            UseCaseView(viewModel: viewModel)

            Button(action: viewModel.save, label: {
                Label("Save", systemImage: "square.and.arrow.down")
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    return MemeGeneratorView(
        template: MemeTemplate.preview,
        gallery: Gallery.preview
    )
}
