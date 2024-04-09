import SwiftUI

struct MemeTemplateBrowserView: View {
    @Environment(Gallery.self) private var gallery
    @Bindable var viewModel = MemeTemplateBrowserViewModel()

    var body: some View {
        VStack {
            switch viewModel.state {
                case .success:
                    List(viewModel.filteredTemplates) { template in
                        ZStack {
                            MemeTemplateCardView(memeTemplate: template)
                                .padding(.bottom, 16)
                                .listRowSeparator(.hidden)
                            NavigationLink {
                                MemeGeneratorView(
                                    template: template,
                                    gallery: gallery
                                )
                                    .navigationTitle(template.name)
                                    .navigationBarTitleDisplayMode(.inline)
                            } label: {
                                EmptyView()
                            }
                            .opacity(0)
                        }
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .searchable(text: $viewModel.searchString,
                                placement: .navigationBarDrawer(displayMode: .always))

                case .loading:
                    ProgressView("Loading...")

                case .error(let error):
                    Text(error.localizedDescription)

                case .initial:
                    Color.clear
                }
        }
        .onAppear {
            Task {
                await viewModel.fetchTemplates()
            }
        }
    }
}

#Preview {
    MemeTemplateBrowserView()
        .environment(Gallery.preview)
}
