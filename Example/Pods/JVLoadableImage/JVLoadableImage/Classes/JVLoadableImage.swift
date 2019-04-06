import UIKit
import JVConstraintEdges
import JVGenericNotificationCenter
import JVUIButtonExtensions

/// Presents a loading view wich acts like a placeholder for an upcoming image.
open class LoadableImage: UIView, NotificationCenterObserver {
    
    public enum CurrentState {
        case loading, presenting(UIImage)
        
        var isLoading: Bool {
            switch self {
            case .loading: return true
            default: return false
            }
        }
        
        var image: UIImage? {
            switch self {
            case .presenting(let image): return image
            default: return nil
            }
        }
    }

    public typealias MappedType = NotificationCenterImageSender
    
    public private (set) var imageView: UIImageView!
    
    public var isLoading: Bool {
        return currentState.isLoading
    }
    
    public var image: UIImage? {
        return currentState.image
    }
    
    public private (set) var currentState = CurrentState.loading
    
    public var selectorExecutor: NotificationCenterSelectorExecutor!
    
    // The identifier for the photo. Can later be used to set the image on if it is done loading.
    public var identifier: Int64 = 0
    
    public var tapped: (() -> ())!
    
    private let imageButton = UIButton(frame: .zero)
    private let indicator: UIActivityIndicatorView
    private let rounded: Bool

    public init(style: UIActivityIndicatorView.Style = .gray,
                rounded: Bool,
                registerNotificationCenter: Bool = true,
                tapped: (() -> ())? = nil,
                isUserInteractionEnabled: Bool = true) {
        indicator = UIActivityIndicatorView(style: style)
        self.rounded = rounded
        self.imageButton.clipsToBounds = rounded
        self.tapped = tapped
        
        super.init(frame: .zero)
        
        imageView = imageButton.imageView!
        
        assert(tapped != nil ? isUserInteractionEnabled : true)
        
        if registerNotificationCenter {
            register()
        }
        
        addImage(isUserInteractionEnabled: isUserInteractionEnabled)
        addIndicator()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Will show an image with an indicator to indicate a higher resolution photo is being downloaded
    open func show(blurredImage: UIImage) {
        imageButton.setImage(blurredImage, for: .normal)
        imageButton.alpha = 1
        imageButton.isUserInteractionEnabled = false
        indicator.alpha = 1
        currentState = .loading
    }
    
    open func show(image: UIImage) {
        self.imageButton.setImage(image, for: .normal)
        self.imageButton.alpha = 1
        self.imageButton.isUserInteractionEnabled = true
        
        indicator.alpha = 0
        currentState = .presenting(image)
    }
    
    open func showIndicator() {
        // We have to do this every time the cell reappears.
        indicator.startAnimating()
        indicator.alpha = 1
        imageButton.alpha = 0
        imageButton.isUserInteractionEnabled = false
        currentState = .loading
    }
    
    public func stretchImage() {
        imageButton.stretchImage()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        guard rounded else {
            return
        }
        
        assert(imageButton.bounds.height == imageButton.bounds.width, "The width of the image isn't equal to the height of the image. This is illegal.")
        
        imageButton.layer.cornerRadius = imageButton.bounds.height / 2
    }
    
    public func retrieved(observer: NotificationCenterImageSender) {
        guard identifier == observer.photoIdentifier else { return }
        
        show(image: UIImage(data: observer.photo)!)
    }
    
    @objc private func _tapped() {
        tapped!()
    }
    
    private func addIndicator() {
        indicator.fill(toSuperview: self)
        
        indicator.startAnimating()
    }
    
    private func addImage(isUserInteractionEnabled: Bool) {
        imageButton.fill(toSuperview: self)
        
        imageButton.imageView!.contentMode = .scaleAspectFit
        imageButton.isUserInteractionEnabled = isUserInteractionEnabled
        
        guard imageButton.isUserInteractionEnabled else {
            // Without this, the image sometimes gets enabled again, dunno why...
            self.isUserInteractionEnabled = false
            
            return
        }
        
        imageButton.addTarget(self, action: #selector(_tapped), for: .touchUpInside)
    }
}
