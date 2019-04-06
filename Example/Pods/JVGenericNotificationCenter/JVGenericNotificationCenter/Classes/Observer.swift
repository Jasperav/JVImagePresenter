import JVJSONCodable

/// The object that will be used to listen for notification center incoming posts.
public protocol NotificationCenterObserver: class {
    
    /// The generic object for sending and retrieving objects through the notification center.
    associatedtype MappedType: NotificationCenterSendable
    
    /// The selector executor that will be used as a bridge for Objc - C compability.
    var selectorExecutor: NotificationCenterSelectorExecutor! { get set }
    
    /// Required implementing method when the notification did send a message.
    func retrieved(observer: MappedType)
}

public extension NotificationCenterObserver {
    /// This has to be called exactly once. Best practise: right after 'self' is fully initialized.
    func register() {
        assert(selectorExecutor == nil, "You called twice the register method. This is illegal.")
        
        selectorExecutor = NotificationCenterSelectorExecutor(execute: retrieved)
        
        NotificationCenter.default.addObserver(selectorExecutor, selector: #selector(selectorExecutor.hit), name: Self.MappedType.notificationName, object: nil)
    }
    
    /// Retrieved non type safe information from the notification center.
    /// Making a type safe object from the user info.
    func retrieved(userInfo: Dictionary) {
        retrieved(observer: MappedType.decodeFrom(data: userInfo))
    }
}

/// Bridge for using Objc - C methods inside a protocol extension.
public class NotificationCenterSelectorExecutor {
    
    /// The method that will be called when the notification center did send a message.
    private let execute: ((_ userInfo: Dictionary) -> ())
    
    public init(execute: @escaping ((_ userInfo: Dictionary) -> ())) {
        self.execute = execute
    }
    
    /// The notification did send a message. Forwarding to the protocol method again.
    @objc fileprivate func hit(_ notification: Notification) {
        execute(notification.userInfo! as! Dictionary)
    }
}
