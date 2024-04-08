import Foundation
import Kingfisher
import SwiftUI

struct Meme: Identifiable, Transferable {
    var id = UUID()
    let templateId: String
    let lines: [String]
    let image: Image

    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.image)
    }
}

#if DEBUG
extension Meme {
    static let preview = Meme(
        templateId: "aag",
        lines: ["bofan", "alien"],
        image: Image(uiImage: #imageLiteral(resourceName: "meme"))
    )
}
#endif
