public class ImageZoomAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    // TODO: Change to unowned var when swift 5.0 is supported.
    weak var fromDelegate: ImageZoomAnimatorDelegate!
    weak var toDelegate: ImageZoomAnimatorDelegate!
    
    let originalImageIsRounded: Bool
    var transitionImageView: UIImageView!
    var isPresenting = true
    
    init(originalImageIsRounded: Bool) {
        self.originalImageIsRounded = originalImageIsRounded
        
        super.init()
    }
    
    private func animateZoomInTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toReferenceImageView = toDelegate.referenceImageView(for: self)!
        let toVC = transitionContext.viewController(forKey: .to)!
        let fromVC = transitionContext.viewController(forKey: .from)!
        let fromReferenceImageView = fromDelegate.referenceImageView(for: self)!
        let fromReferenceImageViewFrame = fromDelegate.referenceImageViewFrameInTransitioningView(for: self)!
        let referenceImage = fromReferenceImageView.image!
        let finalTransitionSize = calculateZoomInImageFrame(image: referenceImage, forView: toVC.view)
        
        toVC.view.alpha = 0
        containerView.addSubview(toVC.view)
        toReferenceImageView.isHidden = true
        fromReferenceImageView.isHidden = true
        
        change(transitionImage: referenceImage, frame: fromReferenceImageViewFrame)
        
        containerView.addSubview(transitionImageView)
    
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: [UIViewAnimationOptions.transitionCrossDissolve],
                       animations: {
                        self.transitionImageView.frame = finalTransitionSize
                        toVC.view.alpha = 1.0
                        fromVC.tabBarController?.tabBar.alpha = 0
        }, completion: { _ in
            self.transitionImageView.removeFromSuperview()
            toReferenceImageView.isHidden = false
            fromReferenceImageView.isHidden = false
            
            self.transitionImageView = nil
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    private func tappedBackButton(transitionContext: UIViewControllerContextTransitioning) {
        let toReferenceImageView = toDelegate.referenceImageView(for: self)
        let toReferenceImageViewFrame = toDelegate.referenceImageViewFrameInTransitioningView(for: self)
        let fromReferenceImageViewFrame = fromDelegate.referenceImageViewFrameInTransitioningView(for: self)!
        let fromReferenceImageView = fromDelegate.referenceImageView(for: self)!
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        
        toReferenceImageView?.isHidden = true
        fromReferenceImageView.isHidden = true
        
        let referenceImage = fromReferenceImageView.image!
        let containerView = transitionContext.containerView
        
        change(transitionImage: referenceImage, frame: fromReferenceImageViewFrame)
        
        containerView.addSubview(transitionImageView)
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       options: [],
                       animations: {
                        fromVC.view.alpha = 0
                        self.transitionImageView?.frame = toReferenceImageViewFrame ?? .zero
                        toVC.tabBarController?.tabBar.alpha = 1
        }, completion: { _ in
            self.transitionImageView?.removeFromSuperview()
            
            toReferenceImageView?.isHidden = false
            fromReferenceImageView.isHidden = false
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    private func calculateZoomInImageFrame(image: UIImage, forView view: UIView) -> CGRect {
        let viewRatio = view.frame.size.width / view.frame.size.height
        let imageRatio = image.size.width / image.size.height
        let touchesSides = (imageRatio > viewRatio)
        
        if touchesSides {
            let height = view.frame.width / imageRatio
            let yPoint = view.frame.minY + (view.frame.height - height) / 2
            return CGRect(x: 0, y: yPoint, width: view.frame.width, height: height)
        } else {
            let width = view.frame.height * imageRatio
            let xPoint = view.frame.minX + (view.frame.width - width) / 2
            return CGRect(x: xPoint, y: 0, width: width, height: view.frame.height)
        }
    }
    
    func change(transitionImage: UIImage, frame: CGRect) {
        transitionImageView = UIImageView(image: transitionImage)
        transitionImageView.contentMode = .scaleAspectFill
        transitionImageView.clipsToBounds = true
        transitionImageView.frame = frame
    }
}

public extension ImageZoomAnimator {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if isPresenting {
            return 0.5
        } else {
            return 0.25
        }
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animateZoomInTransition(using: transitionContext)
        } else {
            tappedBackButton(transitionContext: transitionContext)
        }
    }
}
