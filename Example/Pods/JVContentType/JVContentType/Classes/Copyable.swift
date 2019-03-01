/// Copys the content of the old contentTypeId into the new contentTypeId
/// Use this in combination with ContentType if you need to use a class rather than a struct
public protocol Copyable: class {
    
    /// Make this class func in an inherence tree
    /// When a class implements this method but also implements the content type protocol
    /// the contentTypeId shoud NOT be copied
    init(old: Self, contentTypeId: String?)
}

public extension Copyable {
    func copy(contentTypeId: String?) -> Self {
        return Self.init(old: self, contentTypeId: contentTypeId)
    }
}

public extension Copyable where Self: ContentType {
    /// Gets the content type but copied.
    static func copyContentType(contentTypeId: String) -> Self {
        let instance = Self.allTypes.first(where: { $0.contentTypeId == contentTypeId })!
        return Self.copyContentType(contentType: instance)
    }
    
    static func copyContentType(contentType: Self, newContentTypeId: String? = nil) -> Self {
        return Self(old: contentType, newContentTypeId: newContentTypeId)
    }
}
