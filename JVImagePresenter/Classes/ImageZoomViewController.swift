import UIKit
import JVConstraintEdges

open class ImageZoomViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate, ImageZoomAnimatorDelegate {
    
    public let imageView: ImageViewConstraints
    
    private var firstTimeLoaded = true
    private let transitionController: ImageZoomTransitionController
    private var didSetupContraint = false
    private var correctedZoomScale: CGFloat = 1.0
    private let scrollView = UIScrollView()
    private var doubleTapGestureRecognizer: UITapGestureRecognizer!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var singleTapGestureRecognizer: UITapGestureRecognizer!
    
    public init(image: UIImage, originalImageIsRounded: Bool, presenter: ImageZoomAnimatorDelegate & UIViewController) {
        imageView = ImageViewConstraints(image: image)
        transitionController = ImageZoomTransitionController(originalImageIsRounded: originalImageIsRounded)
        
        super.init(nibName: nil, bundle: nil)
        
        presenter.navigationController!.delegate = transitionController
        transitionController.fromDelegate = presenter
        transitionController.toDelegate = self
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanWith(gestureRecognizer:)))
        panGestureRecognizer.delegate = self
        view.addGestureRecognizer(panGestureRecognizer)
        
        singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSingleTapWith(gestureRecognizer:)))
        view.addGestureRecognizer(singleTapGestureRecognizer)
        
        scrollView.fill(toSuperview: view)
        imageView.fill(to: scrollView)
        
        view.backgroundColor = .white
        
        // Very high else if a small image will be presented,
        // it glitches
        scrollView.maximumZoomScale = 100
        
        doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapWith(gestureRecognizer:)))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        
        singleTapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
        
        scrollView.delegate = self
        adjustImageViewSize(toImage: image)
        view.addGestureRecognizer(doubleTapGestureRecognizer)
        
        scrollView.contentInsetAdjustmentBehavior = .never
        
        imageView.contentHugging = 251
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
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
            scrollView.isScrollEnabled = false
            transitionController.isInteractive = true
            let _ = navigationController!.popViewController(animated: true)
        default:
            transitionController.didPanWith(gestureRecognizer: gestureRecognizer)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateZoomScaleForSize(view.bounds.size)
    }
    
    @objc private func didDoubleTapWith(gestureRecognizer: UITapGestureRecognizer) {
        let pointInView = gestureRecognizer.location(in: imageView)
        var newZoomScale = scrollView.maximumZoomScale
        
        if scrollView.zoomScale >= newZoomScale || abs(scrollView.zoomScale - newZoomScale) <= 0.01 {
            newZoomScale = scrollView.minimumZoomScale
        }
        
        let width = scrollView.bounds.width / newZoomScale
        let height = scrollView.bounds.height / newZoomScale
        let originX = pointInView.x - (width / 2.0)
        let originY = pointInView.y - (height / 2.0)
        
        let rectToZoomTo = CGRect(x: originX, y: originY, width: width, height: height)
        
        scrollView.zoom(to: rectToZoomTo, animated: true)
    }
    
    private func adjustImageViewSize(toImage image: UIImage) {
        imageView.frame = CGRect(x: imageView.frame.origin.x,
                                 y: imageView.frame.origin.y,
                                 width: image.size.width,
                                 height: image.size.height)
    }
    
    private func updateZoomScaleForSize(_ size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        correctedZoomScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = correctedZoomScale
        
        //scrollView.zoomScale is only updated once when
        //the view first loads and each time the device is rotated
        if firstTimeLoaded {
            scrollView.zoomScale = correctedZoomScale
            firstTimeLoaded = false
            
        }
        
        scrollView.maximumZoomScale = correctedZoomScale * 4
    }
    
    private func updateConstraintsForSize(_ size: CGSize) {
        guard !didSetupContraint else { return }
        
        didSetupContraint = true
        
        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        let contentHeight = yOffset * 2 + imageView.frame.height
        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        
        imageView.topConstraint.constant = yOffset
        imageView.bottomConstraint.constant = yOffset
        imageView.leadingConstraint.constant = xOffset
        imageView.trailingConstraint.constant = xOffset
        
        view.layoutIfNeeded()
        
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width,
                                        height: contentHeight)
    }
}

public extension ImageZoomViewController {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(view.bounds.size)
    }
}

public extension ImageZoomViewController {
    func referenceImageView(for zoomAnimator: ImageZoomAnimator) -> UIImageView? {
        return imageView
    }
    
    func referenceImageViewFrameInTransitioningView(for zoomAnimator: ImageZoomAnimator) -> CGRect? {
        var rect = scrollView.convert(imageView.frame, to: view)
        
        rect.origin.y += view.frame.origin.y
        
        return rect
    }
}
