import UIKit

public struct ConstraintEdges: Decodable {
    
    public static let zero = ConstraintEdges(all: 0)
    
    static let isTablet = UIDevice.current.userInterfaceIdiom == .pad
    
    public var leading: CGFloat?
    public var trailing: CGFloat?
    public var top: CGFloat?
    public var bottom: CGFloat?
    
    public var edgeInsets: UIEdgeInsets {
        return UIEdgeInsets(top: top ?? 0, left: leading ?? 0, bottom: bottom ?? 0, right: trailing ?? 0)
    }
    
    public var inversed: ConstraintEdges {
        return ConstraintEdges(leading: leading?.inversed(), trailing: trailing?.inversed(), top: top?.inversed(), bottom: bottom?.inversed())
    }
    
    public var width: CGFloat {
        return (leading ?? 0) + (trailing ?? 0)
    }
    
    public var height: CGFloat {
        return (top ?? 0) + (bottom ?? 0)
    }

    public init(leading: CGFloat?, trailing: CGFloat?, top: CGFloat?, bottom: CGFloat?) {
        self.leading = leading
        self.trailing = trailing
        self.top = top
        self.bottom = bottom
    }
    
    public init(leading: CGFloat) {
        self.init(leading: leading, trailing: nil, top: nil, bottom: nil)
    }
    
    public init(trailing: CGFloat) {
        self.init(leading: nil, trailing: trailing, top: nil, bottom: nil)
    }
    
    public init(top: CGFloat) {
        self.init(leading: nil, trailing: nil, top: top, bottom: nil)
    }
    
    public init(bottom: CGFloat) {
        self.init(leading: nil, trailing: nil, top: nil, bottom: bottom)
    }
    
    public init(all: CGFloat) {
        self.init(leading: all, trailing: all, top: all, bottom: all)
    }
    
    public init(height: CGFloat, setWidthToNil: Bool) {
        self.init(leading: setWidthToNil ? nil : 0,
                  trailing: setWidthToNil ? nil : 0,
                  top: height,
                  bottom: height)
    }
    
    public init(width: CGFloat, setHeightToNil: Bool) {
        self.init(leading: width,
                  trailing: width,
                  top: setHeightToNil ? nil : 0,
                  bottom: setHeightToNil ? nil : 0)
    }
    
    public init(height: CGFloat, width: CGFloat) {
        self.init(leading: width, trailing: width, top: height, bottom: height)
    }
    
    public init() {
        self.init(leading: nil, trailing: nil, top: nil, bottom: nil)
    }
    
    public static func doubleIfTablet(padding: CGFloat) -> ConstraintEdges {
        return ConstraintEdges(all: isTablet ? padding * 2 : padding)
    }
    
    public static func padding(phone: CGFloat, tablet: CGFloat) -> ConstraintEdges {
        return ConstraintEdges(all: isTablet ? tablet * 2 : phone)
    }
    
    public mutating func minus(edge: UIRectEdge) {
        self = min(edge)
    }
    
    public func min(_ edge: UIRectEdge) -> ConstraintEdges {
        if edge == .left {
            return ConstraintEdges(leading: nil, trailing: trailing, top: top, bottom: bottom)
        }
        
        if edge == .top {
            return ConstraintEdges(leading: leading, trailing: trailing, top: nil, bottom: bottom)
        }
        
        if edge == .right {
            return ConstraintEdges(leading: leading, trailing: nil, top: top, bottom: bottom)
        }
        
        return ConstraintEdges(leading: leading, trailing: trailing, top: top, bottom: nil)
    }
    
    public func inverseHeight() -> ConstraintEdges {
        return ConstraintEdges(leading: leading, trailing: trailing, top: top?.inversed(), bottom: bottom?.inversed())
    }
    
    public func inverseWidth() -> ConstraintEdges {
        return ConstraintEdges(leading: leading?.inversed(), trailing: trailing?.inversed(), top: top, bottom: bottom)
    }
    
    public mutating func min(_ value: CGFloat, edge: UIRectEdge) {
        self = minus(value, edge: edge)
    }
    
    public func minus(_ value: CGFloat, edge: UIRectEdge) -> ConstraintEdges {
        var leading: CGFloat? = nil
        var trailing: CGFloat? = nil
        var top: CGFloat? = nil
        var bottom: CGFloat? = nil
        
        if edge == .left || edge == .all {
            leading = self.leading?.decreased(value)
        }
        
        if edge == .top || edge == .all {
            top = self.top?.decreased(value)
        }
        
        if edge == .right || edge == .all {
            trailing = self.trailing?.decreased(value)
        }
        
        if edge == .bottom || edge == .all {
            bottom = self.bottom?.decreased(value)
        }
        
        return ConstraintEdges(leading: leading, trailing: trailing, top: top, bottom: bottom)
    }
    
    /// Leave nil to add it to all edges
    public mutating func add(_ value: CGFloat, edge: UIRectEdge) {
        self = added(value, edge: edge)
    }
    
    public func added(_ value: CGFloat, edge: UIRectEdge) -> ConstraintEdges {
        var leading: CGFloat? = nil
        var trailing: CGFloat? = nil
        var top: CGFloat? = nil
        var bottom: CGFloat? = nil
        
        if edge == .left || edge == .all {
            leading = self.leading?.increased(value)
        }
        
        if edge == .top || edge == .all {
            top = self.top?.increased(value)
        }
        
        if edge == .right || edge == .all {
            trailing = self.trailing?.increased(value)
        }
        
        if edge == .bottom || edge == .all {
            bottom = self.bottom?.increased(value)
        }
        
        return ConstraintEdges(leading: leading, trailing: trailing, top: top, bottom: bottom)
    }
    
    public mutating func doubled(_ edge: UIRectEdge) {
        self = double(edge)
    }
    
    public func double(_ edge: UIRectEdge) -> ConstraintEdges {
        assert(edge != .all)
        if edge == .left {
            return ConstraintEdges(leading: leading! * 2, trailing: trailing, top: top, bottom: bottom)
        }
        
        if edge == .top {
            return ConstraintEdges(leading: leading, trailing: trailing, top: top! * 2, bottom: bottom)
        }
        
        if edge == .right {
            return ConstraintEdges(leading: leading, trailing: trailing! * 2, top: top, bottom: bottom)
        }
        
        return ConstraintEdges(leading: leading, trailing: trailing, top: top, bottom: bottom! * 2)
    }
    
}
