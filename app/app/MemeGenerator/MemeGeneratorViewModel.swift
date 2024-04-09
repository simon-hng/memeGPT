import Foundation
import SwiftUI
import Alamofire
import Kingfisher
import OSLog
import OpenAI

struct Line: Identifiable {
    let id = UUID()
    var index: Int
    var string: String
}

enum GptError: Error {
    case failedToParsePrompt
    case notAJson
    case notAnArray
}

extension GptError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .failedToParsePrompt:
            return NSLocalizedString("Failed to parse your prompt. Please try out a different wording",
                                     comment: "")
        case .notAJson:
            return NSLocalizedString("The response from OpenAI did not conform to a JSON format. Please try again",
                                     comment: "")
        case .notAnArray:
            return NSLocalizedString("The response from OpenAI was not an array. Please try again", comment: "")
        }
    }
}

@Observable
class MemeGeneratorViewModel {
    // PLEASE DON'T STEAL MY API KEY
    let openAI = OpenAI(apiToken: "OPENAI_API_TOKEN")

    var gallery: Gallery
    enum State {
        case preview
        case loading
        case saving
        case saved
        case error(Error)
    }

    private(set) var state: State = .preview

    enum UseCase {
        case manual
        case gpt
        case info
    }

    var selectedUseCase: UseCase = .manual

    let template: MemeTemplate
    var lines: [Line]
    var suggestionPrompt = ""

    var previewUrl: URL {
        var parameters = lines.map { value in
            URLQueryItem(name: "lines[]", value: value.string.isEmpty ? " " : value.string)
        }
        parameters.append(URLQueryItem(name: "template", value: template.id))

        // swiftlint:disable:next force_unwrapping
        var components = URLComponents(string: "https://api.memegen.link/images/preview.jpg")!
        components.queryItems = parameters

        guard let url = components.url else {
            fatalError("Invalid URL components")
        }

        state = .preview
        return url
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

        logger.info("Getting generated meme from \(url)")
        state = .preview
        return url
    }

    var memeInformationUrl: URL {
        // swiftlint:disable:next force_unwrapping
        var components = URLComponents(string: "https://knowyourmeme.com/search")!
        components.queryItems = [
            URLQueryItem(name: "q", value: template.name)
        ]

        guard let url = components.url else {
            fatalError("Invalid URL components")
        }

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
            image: Image(uiImage: image)
        )

        gallery.saveMeme(meme)
    }

    func generateSuggestion() async {
        guard let chatQueryParam = ChatQuery.ChatCompletionMessageParam(
            role: .user,
            content: "Give me a suggestion for a meme that has \(template.lines) lines." +
                "The meme should be about \(suggestionPrompt)" +
                "Answer only in JSON as JSON array of the lines"
        ) else {
            state = .error(GptError.failedToParsePrompt)
            return
        }

        let query = ChatQuery(messages: [chatQueryParam], model: .gpt3_5Turbo)

        let suggestedLines: [String]
        state = .loading
        do {
            let res = try await openAI.chats(query: query).choices[0].message.content?.string
            logger.info("received ai message: \(res ?? "")")

            guard let res, let jsonData = res.data(using: .utf8) else {
                state = .error(GptError.notAJson)
                return
            }
            guard let suggestion = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String] else {
                state = .error(GptError.notAnArray)
                return
            }

            suggestedLines = suggestion
            state = .preview
        } catch {
            state = .error(error)
            logger.error("\(String(describing: error))")
            return
        }

        logger.info("Received AI suggestion")
        for index in 0..<lines.count {
            lines[index].string = suggestedLines[index]
        }
    }
}
