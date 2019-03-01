import JVConstraintEdges

class ImageViewConstraints: UIImageView {
    
    private (set) var topConstraint: NSLayoutConstraint!
    private (set) var bottomConstraint: NSLayoutConstraint!
    private (set) var leadingConstraint: NSLayoutConstraint!
    private (set) var trailingConstraint: NSLayoutConstraint!
    
    init(image: UIImage) {
        super.init(image: image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fill(to: UIView) {
        addAsSubview(to: to)
        
        topConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: to, attribute: .top, multiplier: 1, constant: 0)
        bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: to, attribute: .bottom, multiplier: 1, constant: 0)
        leadingConstraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: to, attribute: .leading, multiplier: 1, constant: 0)
        trailingConstraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: to, attribute: .trailing, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
    }
}
