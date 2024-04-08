import Foundation
import OSLog

@Observable
class Gallery {
    private(set) var memes: [Meme]

    init() {
        self.memes = []
    }

    init(memes: [Meme]) {
        self.memes = memes
        logger.info("Creating new instance of Gallery model")
    }

    func saveMeme(_ meme: Meme) {
        self.memes.append(meme)
        logger.info("Saved meme to gallery")
    }
}

#if DEBUG
extension Gallery {
    static let preview = Gallery(
        memes: [ Meme.preview, Meme.preview ]
    )
}
#endif
