//
//  PhotoModel.swift
//  Final2
//
//  Created by Kai Jennings on 4/11/23.
//

import SwiftUI

struct PhotoFromLibrary: Identifiable {
  let id: UUID = UUID()
  let photo: Image
}

enum TransferError: Error {
  case importFailed
}

struct TransferredPhoto: Transferable {
  let image: Image

  static var transferRepresentation: some TransferRepresentation {
    DataRepresentation(importedContentType: .image) { data in
      guard let uiImage = UIImage(data: data) else {
        throw TransferError.importFailed
      }
      let image = Image(uiImage: uiImage)
      return TransferredPhoto(image: image)
    }
  }
}

