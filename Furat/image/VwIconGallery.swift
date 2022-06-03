//
//  VwImageGallery.swift
//  Furat
//
//  Created by 浅香紘 on R 4/04/10.
//

import SwiftUI

struct GetIconView {
    
    @Binding var activ_gallery: Bool
    @Binding var activ_edit: Bool
    @Binding var rawImage: Image?
    @Binding var rawUIImage: UIImage?
    @Binding var iniSize: CGSize?
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(
            activ_gallery: $activ_gallery,
            activ_edit: $activ_edit,
            rawImage: $rawImage,
            rawUIImage: $rawUIImage,
            iniSize: $iniSize
        )
    }
}

extension GetIconView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<GetIconView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        // picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,context: UIViewControllerRepresentableContext<GetIconView>) {
    }
}

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @Binding var activ_gallery: Bool
    @Binding var activ_edit: Bool
    @Binding var rawImage: Image?
    @Binding var rawUIImage: UIImage?
    @Binding var iniSize: CGSize?
    
    init(
        activ_gallery: Binding<Bool>,
        activ_edit: Binding<Bool>,
        rawImage: Binding<Image?>,
        rawUIImage: Binding<UIImage?>,
        iniSize: Binding<CGSize?>
    ) {
        _activ_gallery = activ_gallery
        _activ_edit = activ_edit
        _rawImage = rawImage
        _rawUIImage = rawUIImage
        _iniSize = iniSize
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let gotUIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        let width = gotUIImage.size.width
        let height = gotUIImage.size.height
        var widthF: CGFloat
        var heightF: CGFloat
        if width < height{
            widthF = 200
            heightF = CGFloat(widthF * height / width)
        }else{
            heightF =  200
            widthF = CGFloat(heightF * width / height)
        }
        
        iniSize = CGSize(width: widthF, height: heightF)
        if let size = iniSize{
            rawUIImage = gotUIImage.resize(targetSize: size)
        }else{
            rawUIImage = gotUIImage
        }
        rawImage = Image(uiImage: gotUIImage)
        activ_gallery = false
        activ_edit = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        activ_gallery = false
    }
}

