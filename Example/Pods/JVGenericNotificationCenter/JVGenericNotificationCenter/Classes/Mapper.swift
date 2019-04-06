import JVJSONCodable

/// Not really the user info from the notification center, but this is what we want 99% of the cases anyway.
public typealias Dictionary = [String: Any]

/// The generic object that will be used for sending and retrieving objects through the notification center.
public protocol NotificationCenterSendable: Codable {
    static var notificationName: Notification.Name { get }
}

public extension NotificationCenterSendable {
    func post() {
        NotificationCenter.default.post(name: Self.notificationName, object: nil, userInfo: encode())
    }
}
