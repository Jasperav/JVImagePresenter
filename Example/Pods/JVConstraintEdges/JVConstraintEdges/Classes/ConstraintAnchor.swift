public struct ConstraintAnchor {
    
    public var height: CGFloat?
    public var width: CGFloat?
    public var centerY: CGFloat?
    public var centerX: CGFloat?
    
    public static let zero = ConstraintAnchor()
    
    public init(height: CGFloat? = 0, width: CGFloat? = nil, centerY: CGFloat? = 0, centerX: CGFloat? = 0) {
        self.height = height
        self.width = width
        self.centerY = centerY
        self.centerX = centerX
    }
}
