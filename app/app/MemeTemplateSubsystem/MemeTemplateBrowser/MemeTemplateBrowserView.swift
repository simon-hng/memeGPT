import SwiftUI

struct MemeTemplateBrowserView: View {
    var viewModel = MemeTemplateBrowserViewModel()

    var body: some View {
        VStack {
            switch viewModel.state {
                case .success(let templates):
                    List(templates) { template in
                        ZStack {
                            MemeTemplateCardView(memeTemplate: template)
                                .padding(.bottom, 16)
                                .listRowSeparator(.hidden)
                            NavigationLink {
                                MemeGeneratorView(template: template)
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

struct MemeTemplateBrowserView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MemeTemplateBrowserView()
                .navigationTitle("Browse Templates")
        }
    }
}
