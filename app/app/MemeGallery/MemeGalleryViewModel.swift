import Foundation
import OSLog

@Observable
class MemeGalleryViewModel {
    var gallery: Gallery
    var memes: [Meme] {gallery.memes}

    init(gallery: Gallery) {
        self.gallery = gallery
    }
}
