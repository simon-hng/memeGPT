import SwiftUI

struct MemeTemplateBrowserView: View {
    var viewModel = MemeTemplateBrowserViewModel()

    var body: some View {
        VStack {
            switch viewModel.state {
                case .success(let templates):
                    List(templates) { template in
                        MemeTemplateCardView(memeTemplate: template)
                            .padding(.bottom, 16)
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
        MemeTemplateBrowserView()
    }
}
