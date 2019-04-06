import UIKit
import JVDebugProcessorMacros

public extension UIView {
    
    var contentHugging: Float {
        get {
            Unsupported()
        } set {
            setContentHuggingPriority(UILayoutPriority(rawValue: newValue), for: .horizontal)
            setContentHuggingPriority(UILayoutPriority(rawValue: newValue), for: .vertical)
        }
    }
    
    var contentCompression: Float {
        get {
            Unsupported()
        } set {
            setContentCompressionResistancePriority(UILayoutPriority(rawValue: newValue), for: .horizontal)
            setContentCompressionResistancePriority(UILayoutPriority(rawValue: newValue), for: .vertical)
        }
    }
    
    var contentHuggingAndCompressionResistance: Float {
        get {
            Unsupported()
        } set {
            contentHugging = newValue
            contentCompression = newValue
        }
    }
    
    var isSquare: Bool {
        get {
            Unsupported()
        } set {
            assert(newValue)
            
            heightAnchor.constraint(equalTo: widthAnchor).isActive = true
        }
    }
    
    var widthConstant: CGFloat {
        get {
            Unsupported()
        } set {
            widthAnchor.constraint(equalToConstant: newValue).isActive = true
        }
    }
    
    var heightConstant: CGFloat {
        get {
            Unsupported()
        } set {
            heightAnchor.constraint(equalToConstant: newValue).isActive = true
        }
    }
    
    var equalToCenterY: UIView {
        get {
            Unsupported()
        } set {
            centerYAnchor.constraint(equalTo: newValue.centerYAnchor).isActive = true
        }
    }
    
    var equalToCenterX: UIView {
        get {
            Unsupported()
        } set {
            centerXAnchor.constraint(equalTo: newValue.centerXAnchor).isActive = true
        }
    }
    
    var equalsSizeOf: UIView {
        get {
            Unsupported()
        } set {
            heightAnchor.constraint(equalTo: newValue.heightAnchor).isActive = true
            widthAnchor.constraint(equalTo: newValue.widthAnchor).isActive = true
        }
    }

    func createLeadingConstraint(toRightView: UIView, constant: CGFloat? = nil, multiplier: CGFloat? = nil) {
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: toRightView, attribute: .trailing, multiplier: multiplier ?? 1, constant: constant ?? 0).isActive = true
    }
    
    func createTopConstraint(toBottomView: UIView, constant: CGFloat? = nil, multiplier: CGFloat? = nil) {
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: toBottomView, attribute: .bottom, multiplier: multiplier ?? 1, constant: constant ?? 0).isActive = true
    }
    
    func fillToMiddleWithSameHeightAndWidth(toView: UIView, addToSuperView: Bool = true, toSafeMargins: Bool = false) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if addToSuperView{
            toView.superview!.addSubview(self)
        }
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: toView,
                               attribute: .centerX,
                               multiplier: 1,
                               constant: 0),
            NSLayoutConstraint(item: self,
                               attribute: .centerY,
                               relatedBy: .equal,
                               toItem: toView,
                               attribute: .centerY,
                               multiplier: 1,
                               constant: 0)
            ])
        
        equal(to: toView, height: true, width: true)
    }
    
    func fillToMiddle(toSuperview superview: UIView, addToSuperView: Bool = true, toSafeMargins: Bool = false) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if addToSuperView{
            superview.addSubview(self)
        }
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: superview,
                               attribute: .centerX,
                               multiplier: 1,
                               constant: 0),
            NSLayoutConstraint(item: self,
                               attribute: .centerY,
                               relatedBy: .equal,
                               toItem: superview,
                               attribute: .centerY,
                               multiplier: 1,
                               constant: 0)
            ])
    }
    
    // Because the normal fill() is used so often and this method just a few times
    // We do not want extra overhead with the unnecessary callbacks
    // That is why this method is introduced, it is just a copy of the normal fill method with a callback
    func fillWithResult(toSuperview: UIView, edges: ConstraintEdges? = nil, addToSuperView: Bool = true, toSafeMargins: Bool = false, activateConstraints: Bool = true) -> [NSLayoutConstraint] {
        let edgesToUse  = edges ?? ConstraintEdges.zero
        let safeGuide = toSuperview.safeAreaLayoutGuide
        var constraints = [NSLayoutConstraint]()
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if addToSuperView{
            toSuperview.addSubview(self)
        }
        
        if let bottom = edgesToUse.bottom {
            if toSafeMargins {
                constraints.append(bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor, constant: -bottom))
            } else {
                constraints.append(bottomAnchor.constraint(equalTo: toSuperview.bottomAnchor, constant: -bottom))
            }
        }
        
        if let top = edgesToUse.top {
            if toSafeMargins {
                constraints.append(topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: top))
            } else {
                constraints.append(topAnchor.constraint(equalTo: toSuperview.topAnchor, constant: top))
            }
        }
        
        if let leading = edgesToUse.leading {
            if toSafeMargins {
                constraints.append(leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: leading))
            } else {
                constraints.append(leadingAnchor.constraint(equalTo: toSuperview.leadingAnchor, constant: leading))
            }
        }
        
        if let trailing = edgesToUse.trailing {
            if toSafeMargins {
                constraints.append(trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -trailing))
            } else {
                constraints.append(trailingAnchor.constraint(equalTo: toSuperview.trailingAnchor, constant: -trailing))
            }
        }
        
        if activateConstraints {
            NSLayoutConstraint.activate(constraints)
        }
        
        return constraints
    }
    
    /// Only fill in 1 corner
    func fillMiddleInCorner(toSuperview: UIView, corner: UIRectCorner, addToSuperView: Bool = true) {
        assert(!corner.contains(.allCorners))
        translatesAutoresizingMaskIntoConstraints = false
        
        if addToSuperView{
            toSuperview.addSubview(self)
        }
        
        if corner.contains(.topRight) || corner.contains(.bottomRight) {
            centerXAnchor.constraint(equalTo: toSuperview.trailingAnchor).isActive = true
        }
        
        if corner.contains(.bottomRight) || corner.contains(.bottomLeft) {
            centerYAnchor.constraint(equalTo: toSuperview.bottomAnchor).isActive = true
        }
        
        if corner.contains(.bottomLeft) || corner.contains(.topLeft) {
            centerXAnchor.constraint(equalTo: toSuperview.leadingAnchor).isActive = true
        }
        
        if corner.contains(.topLeft) || corner.contains(.topRight) {
            centerYAnchor.constraint(equalTo: toSuperview.topAnchor).isActive = true
        }
        
    }
    
    func fillByAnchor(toSuperview: UIView, constraintAnchor: ConstraintAnchor = ConstraintAnchor.zero) {
        assert(superview == nil)
        addAsSubview(to: toSuperview)
        
        if let width = constraintAnchor.width {
            widthAnchor.constraint(equalTo: toSuperview.widthAnchor, constant: width).isActive = true
        }
        
        if let height = constraintAnchor.height {
            heightAnchor.constraint(equalTo: toSuperview.heightAnchor, constant: height).isActive = true
        }
        
        if let centerX = constraintAnchor.centerX {
            centerXAnchor.constraint(equalTo: toSuperview.centerXAnchor, constant: centerX).isActive = true
        }
        
        if let centerY = constraintAnchor.centerY {
            centerYAnchor.constraint(equalTo: toSuperview.centerYAnchor, constant: centerY).isActive = true
        }
    }
    
    func fill(toSuperview: UIView, edges: ConstraintEdges? = nil, addToSuperView: Bool = true, toSafeMargins: Bool = false) {
        let edgesToUse  = edges ?? ConstraintEdges.zero
        let safeGuide = toSuperview.safeAreaLayoutGuide
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if addToSuperView{
            toSuperview.addSubview(self)
        }
        
        if let bottom = edgesToUse.bottom {
            if toSafeMargins {
                bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor, constant: -bottom).isActive = true
            } else {
                bottomAnchor.constraint(equalTo: toSuperview.bottomAnchor, constant: -bottom).isActive = true
            }
        }
        
        if let top = edgesToUse.top {
            if toSafeMargins {
                topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: top).isActive = true
            } else {
                topAnchor.constraint(equalTo: toSuperview.topAnchor, constant: top).isActive = true
            }
        }
        
        if let leading = edgesToUse.leading {
            if toSafeMargins {
                leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: leading).isActive = true
            } else {
                leadingAnchor.constraint(equalTo: toSuperview.leadingAnchor, constant: leading).isActive = true
            }
        }
        
        if let trailing = edgesToUse.trailing {
            if toSafeMargins {
                trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -trailing).isActive = true
            } else {
                trailingAnchor.constraint(equalTo: toSuperview.trailingAnchor, constant: -trailing).isActive = true
            }
        }
    }
    
    func addAsSubview(to: UIView) {
        assert(superview == nil)
        to.addSubview(self)
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func equal(edge: ConstraintEdges, view: UIView) {
        if let leading = edge.leading {
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading).isActive = true
        }
        
        if let trailing = edge.trailing {
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing).isActive = true
        }
        
        if let top = edge.top {
            topAnchor.constraint(equalTo: view.topAnchor, constant: top).isActive = true
        }
        
        if let bottom = edge.bottom {
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom).isActive = true
        }
    }
    
    func spacing(from: AnchorX, to: AnchorX, view: UIView, constant: CGFloat) {
        let toAnchor: NSLayoutYAxisAnchor
        let fromAnchor: NSLayoutYAxisAnchor
        let _constant: CGFloat
        
        switch to {
        case .top:
            toAnchor = view.topAnchor
        case .bottom:
            toAnchor = view.bottomAnchor
        }
        
        switch from {
        case .top:
            fromAnchor = topAnchor
        case .bottom:
            fromAnchor = bottomAnchor
        }
        
        if from == .bottom && to == .top {
            _constant = -constant
        } else {
            _constant = constant
        }
        
        fromAnchor.constraint(equalTo: toAnchor, constant: _constant).isActive = true
    }
    
    func spacing(from: AnchorY, to: AnchorY, view: UIView, constant: CGFloat) {
        let toAnchor: NSLayoutXAxisAnchor
        let fromAnchor: NSLayoutXAxisAnchor
        let _constant: CGFloat
        
        switch to {
        case .left:
            toAnchor = view.leftAnchor
        case .right:
            toAnchor = view.rightAnchor
        }
        
        switch from {
        case .left:
            fromAnchor = leftAnchor
        case .right:
            fromAnchor = rightAnchor
        }
        
        if from == .right && to == .left {
            _constant = -constant
        } else {
            _constant = constant
        }
        
        fromAnchor.constraint(equalTo: toAnchor, constant: _constant).isActive = true
    }
    
    func equal(to: UIView, height: Bool, width: Bool) {
        if height {
            heightAnchor.constraint(equalTo: to.heightAnchor, multiplier: 1).isActive = true
        }
        
        if width {
            widthAnchor.constraint(equalTo: to.widthAnchor, multiplier: 1).isActive = true
        }
    }
    
    func equalWithResult(to: UIView, height: Bool, width: Bool) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        
        if height {
            constraints.append(heightAnchor.constraint(equalTo: to.heightAnchor, multiplier: 1))
        }
        
        if width {
            constraints.append(widthAnchor.constraint(equalTo: to.widthAnchor, multiplier: 1))
        }
        
        NSLayoutConstraint.activate(constraints)
        
        return constraints
    }
}
