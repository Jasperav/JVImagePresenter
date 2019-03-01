public protocol ContentTypeGroupInitializable: ContentTypeGroup {
    init()
    init(contentTypeId: String?)
}

public extension ContentTypeGroupInitializable {
    init() {
        self.init()
    }
    
    init(contentTypeId: String?) {
        self.init()
        self.contentTypeId = contentTypeId
    }
}
