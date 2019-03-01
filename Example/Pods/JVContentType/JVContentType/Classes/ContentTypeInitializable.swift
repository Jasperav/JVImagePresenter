public protocol ContentTypeInitializable: ContentType {
    init()
    init(contentTypeId: String?)
}

public extension ContentTypeInitializable {
    init(contentTypeId: String?) {
        self.init()
        self.contentTypeId = contentTypeId
    }
}
