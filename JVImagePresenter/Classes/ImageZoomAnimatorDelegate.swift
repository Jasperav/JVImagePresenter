import UIKit

public protocol ImageZoomAnimatorDelegate: class {
    func referenceImageView(for zoomAnimator: ImageZoomAnimator) -> UIImageView?
    func referenceImageViewFrameInTransitioningView(for zoomAnimator: ImageZoomAnimator) -> CGRect?
}
