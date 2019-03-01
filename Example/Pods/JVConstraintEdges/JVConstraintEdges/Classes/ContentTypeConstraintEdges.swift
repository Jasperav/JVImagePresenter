import JVContentType

public struct ContentTypeConstraintEdges: ContentType {

    public static var allTypes = Set<ContentTypeConstraintEdges>()
    
    public var contentTypeId: String?
    public let constraintEdges: ConstraintEdges
    
    public init(contentTypeId: String, constraintEdges: ConstraintEdges) {
        self.contentTypeId = contentTypeId
        self.constraintEdges = constraintEdges
    }
    
}
