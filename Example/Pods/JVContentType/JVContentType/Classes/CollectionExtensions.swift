/// Adds the possibility to copy a whole collection with contentType elements.

public extension Array where Element: ContentTypeGroup {
    func copy() -> [Element] {
        return map { $0.copy() }
    }
}

public extension Set where Element: ContentTypeGroup {
    func copy() -> [Element] {
        return map { $0.copy() }
    }
}
