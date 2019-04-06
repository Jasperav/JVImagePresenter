import UIKit
import JVConstraintEdges
import JVGenericNotificationCenter
import JVUIButtonExtensions

/// Presents a loading view wich acts like a placeholder for an upcoming image.
open class LoadableImage: UIView, NotificationCenterObserver {
    
    public enum State {
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
        return state.isLoading
    }
    
    public var image: UIImage? {
        return state.image
    }
    
    public private (set) var state = State.loading
    
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
                isUserInteractionEnabled: Bool = true,
                stretched: Bool = false) {
        fatalError()
        //indicator = UIActivityIndicatorView(style: style)
        self.rounded = rounded
        self.imageButton.clipsToBounds = rounded
        self.tapped = tapped
        
        super.init(frame: .zero)
        
        assert(tapped != nil ? isUserInteractionEnabled : true)
        
        setupImage(isUserInteractionEnabled: isUserInteractionEnabled)
        setupIndicator()
        
        if registerNotificationCenter {
            register()
        }
        
        if stretched {
            imageButton.stretchImage()
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        guard rounded else {
            return
        }
        
        assert(imageButton.bounds.height == imageButton.bounds.width, "The width of the image isn't equal to the height of the image. This is illegal.")
        
        imageButton.layer.cornerRadius = imageButton.bounds.height / 2
    }
    
    /// Will show an image with an indicator to indicate a higher resolution photo is being downloaded
    open func show(blurredImage: UIImage) {
        imageButton.setImage(blurredImage, for: .normal)
        imageButton.alpha = 1
        imageButton.isUserInteractionEnabled = false
        indicator.alpha = 1
        state = .loading
    }
    
    open func show(image: UIImage) {
        self.imageButton.setImage(image, for: .normal)
        self.imageButton.alpha = 1
        self.imageButton.isUserInteractionEnabled = true
        
        indicator.alpha = 0
        state = .presenting(image)
    }
    
    /// Call this when you use this in a TableViewCell
    open func showIndicator() {
        indicator.startAnimating()
        indicator.alpha = 1
        
        imageButton.alpha = 0
        imageButton.isUserInteractionEnabled = false
        
        state = .loading
    }
    
    public func retrieved(observer: NotificationCenterImageSender) {
        guard identifier == observer.photoIdentifier else { return }
        
        show(image: UIImage(data: observer.photo)!)
    }
    
    @objc private func _tapped() {
        tapped!()
    }
}

extension LoadableImage: ModelCreator {
    private func setupIndicator() {
        indicator.fill(toSuperview: self)
        
        indicator.startAnimating()
    }
    
    private func setupImage(isUserInteractionEnabled: Bool) {
        imageView = imageButton.imageView!
        
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
