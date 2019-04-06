import UIKit
import JVConstraintEdges
import JVLoadableImage

open class ImageZoomViewControllerSlide: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate {

    public let imageView: LoadableImage

    private let scrollView = UIScrollView()
    private var doubleTapGestureRecognizer: UITapGestureRecognizer!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var singleTapGestureRecognizer: UITapGestureRecognizer!
    
    public init() {
        imageView = LoadableImage(rounded: false, registerNotificationCenter: true, isUserInteractionEnabled: false, stretched: true)

        super.init(nibName: nil, bundle: nil)

        setupPanGesture()
        setupSingleTapGesture()
        setupDoubleTapGesture()
        setupScrollView()
        setupImageView()

        view.backgroundColor = .white
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // Bottom to top animation, currently not used. Just use the standard animation.
//    public func present(from nv: UINavigationController) {
//        let transition = CATransition()
//
//        transition.duration = 0.5
//        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//        transition.type = CATransitionType.moveIn
//        transition.subtype = CATransitionSubtype.fromTop
//
//        nv.view.layer.add(transition, forKey: nil)
//        nv.pushViewController(self, animated: false)
//    }

    private func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer == scrollView.panGestureRecognizer {
            if scrollView.contentOffset.y == 0 {
                return true
            }
        }

        return false
    }

    @objc private func didSingleTapWith(gestureRecognizer: UITapGestureRecognizer) {
        // TODO for later
    }

    @objc private func didPanWith(gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            break
        default:
            break
        }
    }

    @objc private func didDoubleTapWith(gestureRecognizer: UITapGestureRecognizer) {
        guard !imageView.isLoading else { return } // Image is loading, do nothing
        
        guard scrollView.zoomScale == 1.0 else {
            scrollView.setZoomScale(1, animated: true)
            
            return
        }
        
        let pointInView = gestureRecognizer.location(in: imageView)
        let newZoomScale = scrollView.maximumZoomScale
        let width = scrollView.bounds.width / newZoomScale
        let height = scrollView.bounds.height / newZoomScale
        let originX = pointInView.x - (width / 2.0)
        let originY = pointInView.y - (height / 2.0)
        let rectToZoomTo = CGRect(x: originX, y: originY, width: width, height: height)

        scrollView.zoom(to: rectToZoomTo, animated: true)
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        // ...
    }
}

extension ImageZoomViewControllerSlide {
    private func setupPanGesture() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanWith(gestureRecognizer:)))
        panGestureRecognizer.delegate = self
        
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func setupSingleTapGesture() {
        singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSingleTapWith(gestureRecognizer:)))
        
        view.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    private func setupDoubleTapGesture() {
        doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapWith(gestureRecognizer:)))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        
        view.addGestureRecognizer(doubleTapGestureRecognizer)
        
        singleTapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
    }
    
    private func setupScrollView() {
        scrollView.fill(toSuperview: view)
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 4
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    private func setupImageView() {
        imageView.layout {
            $0.fillToMiddle(toSuperview: scrollView)
            
            $0.equal(to: scrollView, height: false, width: true)
            $0.isSquare = true
            
            $0.contentMode = .scaleAspectFit
        }
    }
}
