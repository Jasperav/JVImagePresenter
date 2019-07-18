import UIKit
import Photos
import JVUIAlertControllerExtensions

class MediaPicker: NSObject {
    
    // We shouldn't subclass UIImagePickerController according to https://developer.apple.com/documentation/uikit/uiimagepickercontroller
    let imagePickerViewController = UIImagePickerController()
    
    private let pickedMediaDataWithType: ((MediaTypeWithData) -> ())
    private unowned let presenter: UIViewController
    
    init(presenter: UIViewController, allowVideos: Bool, allowsEditing: Bool, pickedMediaDataWithType: @escaping ((MediaTypeWithData) -> ())) {
        self.presenter = presenter
        self.pickedMediaDataWithType = pickedMediaDataWithType
        
        super.init()
        
        imagePickerViewController.delegate = self
        imagePickerViewController.allowsEditing = allowsEditing
        
        attachMedia()
    }
    
    private func attachMedia() {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authorizationStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (_) in
                // Somehow this is executed on a background thread
                DispatchQueue.main.async {
                    self.attachMedia()
                }
            })
        case .restricted:
            let alert = UIAlertController.createRestricedAlertController(message: NSLocalizedString("Accessing the library is restriced.", comment: ""))
            
            presenter.present(alert, animated: true, completion: nil)
        case .denied:
            let alert = UIAlertController(title: NSLocalizedString("Allow media library", comment: ""),
                                          message: NSLocalizedString("Please allow access to the media library to send photos and videos", comment: ""),
                                          preferredStyle: UIAlertController.Style.alert)
            
            alert.createActionGoToApplicationSettings()
            
            presenter.present(alert, animated: true, completion: nil)
        case .authorized:
            presenter.present(imagePickerViewController, animated: true, completion: nil)
        @unknown default:
            fatalError()
        }
    }
}

extension MediaPicker: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        presenter.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            pickedMediaDataWithType(.image(image))
        } else if let image = info[(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
            pickedMediaDataWithType(.image(image))
        } else if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            pickedMediaDataWithType(.video(videoURL))
        } else {
            assert(false)
            imagePickerViewController.dismiss(animated: true, completion: nil)
            
            return
        }
    }
}
