public extension UIButton {
    func stretchImage() {
        imageView!.contentMode = .scaleAspectFill
        
        contentHorizontalAlignment = .fill
        contentVerticalAlignment = .fill
    }
}
