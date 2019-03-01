import UIKit

public extension CGFloat {
    func inversed() -> CGFloat {
        return -self
    }
    
    mutating func inverse() {
        self = -self
    }
    
    func increased(_ by: CGFloat) -> CGFloat {
        return self + by
    }
    
    mutating func increase(_ by: CGFloat) {
        self += by
    }
    
    func decreased(_ by: CGFloat) -> CGFloat {
        return self - by
    }
    
    mutating func decrease(_ by: CGFloat) {
        self -= by
    }
}

