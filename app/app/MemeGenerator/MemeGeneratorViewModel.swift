import Foundation
import Alamofire
import Kingfisher
import OSLog

let logger = Logger()

func getPreviewUrl(_ parameters: [URLQueryItem]) -> URL {
    // swiftlint:disable:next force_unwrapping
    var components = URLComponents(string: "https://api.memegen.link/images/preview.jpg")!
    components.queryItems = parameters

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
    var gallery: Gallery
    enum State {
        case preview
        case saving
        case saved
        case error(Error)
    }

    private(set) var state: State = .preview
    let template: MemeTemplate
    var isSaved = false
    var lines: [Line]

    var previewUrl: URL {
        var parameters = lines.map { value in
            URLQueryItem(name: "lines[]", value: value.string.isEmpty ? " " : value.string)
        }
        parameters.append(URLQueryItem(name: "template", value: template.id))

        state = .preview
        return getPreviewUrl(parameters)
    }

    var imageUrl: URL {
        // swiftlint:disable:next force_unwrapping
        var components = URLComponents(string: "https://api.memegen.link/images")!
        components.path += "/\(template.id)"
        for line in lines {
            components.path += "/\(line.string)"
        }

        guard let url = components.url else {
            fatalError("Invalid URL components")
        }

        state = .preview
        return url
    }

    init(template: MemeTemplate, gallery: Gallery) {
        self.template = template
        self.lines = (0..<template.lines).map {
            Line( index: $0, string: "")
        }
        self.gallery = gallery
    }

    func save() {
        state = .saving
        // Saving is done through the callback in the KFImage
        logger.info("Saving meme")
    }

    func saveImage(image: KFCrossPlatformImage) {
        state = .saved
        let meme = Meme(
            templateId: template.id,
            lines: self.lines.map { $0.string },
            image: image
        )

        gallery.saveMeme(meme)
    }
}
