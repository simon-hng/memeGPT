import Foundation
import Kingfisher
import SwiftUI

struct Meme: Identifiable {
    var id = UUID()
    let templateId: String
    let lines: [String]
    let image: UIImage
}

#if DEBUG
extension Meme {
    static let preview = Meme(
        templateId: "aag",
        lines: ["bofan", "alien"],
        image: #imageLiteral(resourceName: "meme")
    )
}
#endif
