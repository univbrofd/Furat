//
//  VwImageGallery.swift
//  Furat
//
//  Created by 浅香紘 on R 4/04/26.
//

import SwiftUI

struct GetImageView :UIViewControllerRepresentable {
    @Binding var activ : Bool
    @Binding var uiimage : UIImage?
    @Binding var update : Bool
    
    func makeCoordinator() -> ImageCoordinator {
        return ImageCoordinator(
            activ : $activ,
            uiimage: $uiimage,
            update  :$update
        )
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<GetImageView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        // picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,context: UIViewControllerRepresentableContext<GetImageView>) {
    }
}

class ImageCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var activ :Bool
    @Binding var uiimage :UIImage?
    @Binding var update: Bool
    
    init(
        activ : Binding<Bool>,
        uiimage :Binding<UIImage?>,
        update : Binding<Bool>
    ) {
        _activ = activ
        _uiimage = uiimage
        _update = update
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let gotUIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        let width = gotUIImage.size.width
        let height = gotUIImage.size.height
        var resize = false
        var widthF = width
        var heightF = height
        if width >= height, width > 200{
            widthF = 200
            heightF = CGFloat(widthF * height / width)
            resize = true
        }
        if height > width, height > 200{
            heightF = 200
            widthF = CGFloat(heightF * width / height)
            resize = true
        }
        if resize {
            uiimage = gotUIImage.resize(targetSize: CGSize(width: widthF, height: heightF))
        }else{
            uiimage = gotUIImage
        }
        update = true
        activ = false
        print("sucsess get image")
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        activ = false
    }
}
