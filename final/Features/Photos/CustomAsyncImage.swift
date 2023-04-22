//
//  CustomAsyncImage.swift
//  final
//
//  Created by Adar Schwarzbach on 4/21/23.
//

import SwiftUI

struct AsyncImageWithTimeout: View {
    @StateObject private var model: URLImageModel
    let placeholder: Image
    
    init(url: URL?, placeholder: Image = Image(systemName: "person"), maxLoadDuration: TimeInterval = 5.0) {
        _model = StateObject(wrappedValue: URLImageModel(url: url, maxLoadDuration: maxLoadDuration))
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let image = model.image {
                Image(uiImage: image)
                    .resizable()
                   .aspectRatio(contentMode: .fill)
                   .clipShape(Circle())
                   .overlay(Circle().stroke(Color.white, lineWidth: 3))
                   .frame(width: 50, height: 50)
                
            } else {
                placeholder
                    .font(.largeTitle)
                  .foregroundColor(.gray)
                  .padding(10)
                  .background(Color.white)
                  .clipShape(Circle())
                  .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                  .frame(width: 50, height: 50)
            }
        }
    }
}


class URLImageModel: ObservableObject {
    @Published var image: UIImage?
    private let maxLoadDuration: TimeInterval
    
    init(url: URL?, maxLoadDuration: TimeInterval) {
        self.maxLoadDuration = maxLoadDuration
        guard let url = url else { return }
        loadImage(from: url)
    }
    
    private func loadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
        task.resume()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + maxLoadDuration) {
            if self.image == nil {
                task.cancel()
            }
        }
    }
}
