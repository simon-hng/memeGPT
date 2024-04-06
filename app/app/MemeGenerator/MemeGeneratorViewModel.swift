import Foundation
import Alamofire
import OSLog

let logger = Logger()

func getImageUrl(_ parameters: [URLQueryItem]) -> URL {
    let baseURLString = "https://api.memegen.link/images/preview.jpg"

    // swiftlint:disable:next force_unwrapping
    var components = URLComponents(string: baseURLString)!

    components.queryItems = parameters

    // Create the final URL
    guard let url = components.url else {
        fatalError("Invalid URL components")
    }

    return url
}

struct Line: Identifiable {
    let id = UUID()
    var index: Int
    var string: String
}

@Observable
class MemeGeneratorViewModel {
    let template: MemeTemplate
    var lines: [Line]
    var previewUrl: URL {
        var parameters = lines.map { value in
            URLQueryItem(name: "lines[]", value: value.string.isEmpty ? " " : value.string)
        }
        parameters.append(URLQueryItem(name: "template", value: template.id))

        return getImageUrl(parameters)
    }

    init(template: MemeTemplate) {
        self.template = template
        self.lines = (0..<template.lines).map {
            Line( index: $0, string: "")
        }
    }

    func save() {
        logger.info("Saving meme")
    }
}
