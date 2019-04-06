import JVGenericNotificationCenter

public struct NotificationCenterImageSender: NotificationCenterSendable, Codable {

    public static var notificationName = Notification.Name.retrievedLoadableImage
    
    public let photoIdentifier: Int64
    public let photo: Data
    
    public init(photoIdentifier: Int64, photo: UIImage) {
        self.photoIdentifier = photoIdentifier
        fatalError()
        //self.photo = photo.pngData()!
    }
}
