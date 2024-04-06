import Foundation

@Observable
class Gallery {
    private(set) var memes: [Meme]

    init() {
        self.memes = []
    }

    init(memes: [Meme]) {
        self.memes = memes
    }

    func saveMeme(_ meme: Meme) {
        self.memes.append(meme)
    }
}

#if DEBUG
extension Gallery {
    static let preview = Gallery(
        memes: [ Meme.preview, Meme.preview ]
    )
}
#endif
