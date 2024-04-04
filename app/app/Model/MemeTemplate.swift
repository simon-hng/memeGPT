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
