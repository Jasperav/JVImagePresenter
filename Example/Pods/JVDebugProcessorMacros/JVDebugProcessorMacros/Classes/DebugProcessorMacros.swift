/// Currently not supported
public func Unsupported() -> Never {
    fatalError()
}

#if DEBUG
/// Doesn't compile when going in production.
public func TodoCrash() -> Never {
    fatalError()
}
#endif

#if DEBUG
/// Doesn't compile when going in production.
public func ToDo(_ t: String = "") {
    print("Found todo \(t)")
}
#endif

/// Shouldn't happen.
public func IllegalState() -> Never {
    fatalError()
}

#if DEBUG
/// Prevents a print statement in production
public func dp(_ t: Any) {
    print(t)
}
#endif
