import Foundation
import Alamofire
import OSLog

@Observable
class MemeTemplateBrowserViewModel {
    var searchString = ""

    enum State {
        case initial
        case loading
        case success([MemeTemplate])
        case error(Error)
    }

    private(set) var state: State = .initial

    var filteredTemplates: [MemeTemplate] {
        if case .success(let templates) = state {
            if searchString.isEmpty {
                return templates
            }
            return templates.filter { $0.name.lowercased().contains(searchString.lowercased()) }
        }

        return []
    }

    func fetchTemplates() async {
        // swiftlint:disable:next force_unwrapping
        let url = URL(string: "https://api.memegen.link/templates")!
        let headers: HTTPHeaders = [ "Accept": "application/json" ]

        let templates: [MemeTemplate]
        do {
            templates = try await AF.request(url, method: .get, headers: headers)
                .validate()
                .serializingDecodable([MemeTemplate].self)
                .value
        } catch {
            state = .error(error)
            return
        }

        state = .success(templates)
        logger.info("Received \(templates.count) templates")
    }
}
