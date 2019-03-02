import UIKit

class ImageZoomDismissalInteractionController: NSObject {
    
    var transitionContext: UIViewControllerContextTransitioning!
    var animator: (UIViewControllerAnimatedTransitioning & ImageZoomAnimator)!
    
    var fromReferenceImageViewFrame: CGRect?
    var toReferenceImageViewFrame: CGRect?
    
    func didPanWith(gestureRecognizer: UIPanGestureRecognizer) {
        let toReferenceImageViewFrame = animator.toDelegate.referenceImageViewFrameInTransitioningView(for: animator) ?? .zero
        let toReferenceImageView = animator.toDelegate.referenceImageView(for: animator)
        let fromReferenceImageView = animator.fromDelegate.referenceImageView(for: animator)!
        guard transitionContext != nil else {
            return // Is nil when the user pans fast.
        }
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        let transitionImageView = animator.transitionImageView!
        let anchorPoint = CGPoint(x: fromReferenceImageViewFrame!.midX, y: fromReferenceImageViewFrame!.midY)
        let translatedPoint = gestureRecognizer.translation(in: fromReferenceImageView)
        let verticalDelta = translatedPoint.y
        let backgroundAlpha = backgroundAlphaFor(view: fromVC.view, withPanningVerticalDelta: verticalDelta)
        let scale = scaleFor(view: fromVC.view, withPanningVerticalDelta: verticalDelta)
        let newCenter = CGPoint(x: anchorPoint.x + translatedPoint.x, y: anchorPoint.y + translatedPoint.y - transitionImageView.frame.height * (1 - scale) / 2.0)
        
        fromVC.view.alpha = backgroundAlpha
        
        if self.animator.originalImageIsRounded {
            let percentScrolled = abs(backgroundAlpha - 1)
            let fullRoundRadius = toReferenceImageViewFrame.height / 2
            let correctedRadius = fullRoundRadius * percentScrolled
            
            transitionImageView.layer.cornerRadius = correctedRadius
        }
        
        toVC.tabBarController?.tabBar.alpha = 1 - backgroundAlpha
        
        transitionImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        transitionImageView.center = newCenter
        
        fromReferenceImageView.isHidden = true
        toReferenceImageView?.isHidden = true
        
        transitionContext.updateInteractiveTransition(1 - scale)
        
        guard gestureRecognizer.state == .ended else { return }
        
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: [],
                       animations: {
                        fromVC.view.alpha = 0
                        transitionImageView.frame = toReferenceImageViewFrame
                        toVC.tabBarController?.tabBar.alpha = 1
                        
                        if self.animator.originalImageIsRounded {
                            transitionImageView.layer.cornerRadius = toReferenceImageViewFrame.height / 2
                        }
        }, completion: { _ in
            transitionImageView.removeFromSuperview()
            toReferenceImageView?.isHidden = false
            fromReferenceImageView.isHidden = false
            
            self.transitionContext.finishInteractiveTransition()
            
            self.transitionContext.completeTransition(!self.transitionContext.transitionWasCancelled)
            
            self.transitionContext = nil
        })
    }
    
    func backgroundAlphaFor(view: UIView, withPanningVerticalDelta verticalDelta: CGFloat) -> CGFloat {
        let startingAlpha:CGFloat = 1.0
        let finalAlpha: CGFloat = 0.0
        let totalAvailableAlpha = startingAlpha - finalAlpha
        
        let maximumDelta = view.bounds.height / 4.0
        let deltaAsPercentageOfMaximun = min(abs(verticalDelta) / maximumDelta, 1.0)
        
        return startingAlpha - (deltaAsPercentageOfMaximun * totalAvailableAlpha)
    }
    
    func scaleFor(view: UIView, withPanningVerticalDelta verticalDelta: CGFloat) -> CGFloat {
        let startingScale: CGFloat = 1.0
        let finalScale: CGFloat = 0.5
        let totalAvailableScale = startingScale - finalScale
        let maximumDelta = view.bounds.height / 2.0
        let deltaAsPercentageOfMaximun = min(abs(verticalDelta) / maximumDelta, 1.0)
        
        return startingScale - (deltaAsPercentageOfMaximun * totalAvailableScale)
    }
}

extension ImageZoomDismissalInteractionController: UIViewControllerInteractiveTransitioning {
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let fromReferenceImageViewFrame = animator.fromDelegate.referenceImageViewFrameInTransitioningView(for: animator)!
        let fromReferenceImageView = animator.fromDelegate.referenceImageView(for: animator)!
        
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        
        let toReferenceImageViewFrame = animator.toDelegate.referenceImageViewFrameInTransitioningView(for: animator) ?? CGRect.zero
        
        let containerView = transitionContext.containerView
        let referenceImage = fromReferenceImageView.image!
        
        self.transitionContext = transitionContext
        self.fromReferenceImageViewFrame = fromReferenceImageViewFrame
        self.toReferenceImageViewFrame = toReferenceImageViewFrame
        
        animator.change(transitionImage: referenceImage, frame: fromReferenceImageViewFrame)
        
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        containerView.addSubview(animator.transitionImageView)
    }
}
