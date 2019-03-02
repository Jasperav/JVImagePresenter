import UIKit

class ImageZoomTransitionController: NSObject {
    
    var isInteractive = false
    
    private let animator: ImageZoomAnimator
    private let interactionController = ImageZoomDismissalInteractionController()
    
    // TODO: Change to unowned var when Swift 5.0 is supported
    weak var fromDelegate: ImageZoomAnimatorDelegate!
    weak var toDelegate: ImageZoomAnimatorDelegate!
    
    init(originalImageIsRounded: Bool) {
        animator = ImageZoomAnimator(originalImageIsRounded: originalImageIsRounded)
    }
    
    func didPanWith(gestureRecognizer: UIPanGestureRecognizer) {
        interactionController.didPanWith(gestureRecognizer: gestureRecognizer)
    }
}

extension ImageZoomTransitionController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.isPresenting = true
        animator.fromDelegate = fromDelegate
        animator.toDelegate = toDelegate
        
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let fromDelegate = animator.fromDelegate
        
        animator.isPresenting = false
        animator.fromDelegate = toDelegate
        animator.toDelegate = fromDelegate
        
        return animator
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard isInteractive else {
            return nil
        }
        
        interactionController.animator = (animator as! (ImageZoomAnimator & UIViewControllerAnimatedTransitioning))
        
        return interactionController
    }
    
}

extension ImageZoomTransitionController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            animator.isPresenting = true
            animator.fromDelegate = fromDelegate
            animator.toDelegate = toDelegate
        } else {
            assert(operation == .pop)
            
            let fromDelegate = animator.fromDelegate
            
            animator.isPresenting = false
            animator.fromDelegate = toDelegate
            animator.toDelegate = fromDelegate
        }
        
        return animator
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard isInteractive else {
            return nil
        }
        
        interactionController.animator = animator
        
        return interactionController
    }
    
}
