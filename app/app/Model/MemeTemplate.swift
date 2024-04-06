import Foundation
import Alamofire

struct MemeTemplate: Codable, Identifiable {
    let id: String
    let name: String
    let lines: Int
    let overlays: Int
    let styles: [String]
    let blank: String
    let example: MemeExample
}

struct MemeExample: Codable {
    let text: [String]
    let url: String
}

#if DEBUG
extension MemeTemplate {
    static let preview = MemeTemplate(
        id: "aag",
        name: "Ancient Aliens Guy",
        lines: 2,
        overlays: 0,
        styles: [],
        blank: "https://api.memegen.link/images/aag.png",
        example: MemeExample(text: ["aliens"],
                             url: "https://api.memegen.link/images/aag/_/aliens.png")
    )
}
#endif
