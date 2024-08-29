//
//  ImagePicker.swift
//  StyleBites
//
//  Created by Nicolas Niemann on 02.07.24.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @ObservedObject var viewModel: ChatBotViewModel
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage, let imageUrl = info[.imageURL] as? URL {
                parent.viewModel.selectImage(uiImage, imageName: imageUrl.lastPathComponent)
            } else if let uiImage = info[.originalImage] as? UIImage {
                parent.viewModel.selectImage(uiImage, imageName: "Selected Image")
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
