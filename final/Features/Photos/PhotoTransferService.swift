//
//  PhotoTransferService.swift
//  Final2
//
//  Created by Kai Jennings on 4/11/23.
//

import SwiftUI
import PhotosUI
import CoreTransferable

@MainActor
class PhotoTransferService: ObservableObject {

  enum ImageState {
    case empty
    case loading(Progress)
    case success(Image)
    case failure(Error)
  }

  @Published var imageState: ImageState = .empty
  @Published var imageSelection: PhotosPickerItem? = nil {
    didSet {
      if let imageSelection {
        let progress = loadTransferable(from: imageSelection)
        imageState = .loading(progress)
      } else {
        imageState = .empty
      }
    }
  }

  private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
    return imageSelection.loadTransferable(type: TransferredPhoto.self) { result in
      DispatchQueue.main.async {
        guard imageSelection == self.imageSelection else {
          print("Failed to get the selected item.")
          return
        }
        switch result {
        case .success(let selectedImage?):
          self.imageState = .success(selectedImage.image)
        case .success(nil):
          self.imageState = .empty
        case .failure(let error):
          self.imageState = .failure(error)
        }
      }
    }
  }
}
