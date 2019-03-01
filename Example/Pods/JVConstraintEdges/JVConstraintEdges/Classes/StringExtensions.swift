public extension String {
    var contentTypeConstraintEdges: ContentTypeConstraintEdges {
        return ContentTypeConstraintEdges.getContentType(contentTypeId: self)
    }
}
