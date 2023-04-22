//
//  ProfileScreen.swift
//  Final2
//
//  Created by Kai Jennings on 4/10/23.
//

import SwiftUI
import _PhotosUI_SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Photos

struct ProfileScreen: View {
    @StateObject var photoService = PhotoTransferService()
    @EnvironmentObject var currentUser: CurrentUser
    @State private var email = Auth.auth().currentUser?.email ?? ""
    
    
    // Example data

    
    var body: some View {
        VStack {
           
            PhotosPicker(selection: $photoService.imageSelection,
                         matching: .images,
                         photoLibrary: .shared()) {
                Label {
                    Text("Add Profile Photo")
                        .font(.body)
                } icon: {
                    Image(systemName: "person.circle.fill")
                        .symbolRenderingMode(.multicolor)
                        .foregroundColor(.accentColor)
                        .font(.system(size: 50))
                        .controlSize(.large)
                        .scaledToFit()
                    
                }
            }
                         .padding(.top, 40)
                         

            CurrentSelectionDisplay(imageState: photoService.imageState)
            Text(currentUser.displayName ?? "")
                .font(.title)
                .padding(.bottom, 10)
            
            Text(email)
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.bottom, 20)
            DisplayNameTextField(displayName: Binding<String>(
                                    get: { currentUser.displayName ?? "" },
                                    set: { currentUser.displayName = $0.isEmpty ? nil : $0 }))
            Spacer()
            Spacer()
            SignOutButton()
                        .padding()
            
        }
        .padding(.vertical)
        
        }
    }



struct CurrentSelectionDisplay: View {
    let imageState: PhotoTransferService.ImageState
    
    var body: some View {
        ZStack {
            switch imageState {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 3))
            case .loading:
                ProgressView()
            case .empty:
                Image(systemName: "person.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
            case .failure:
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
            }
        }
        .frame(width: 120, height: 120)
        .padding(.bottom, 20)
    }
}



func uploadProfilePhoto(userID: String, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
    guard let imageData = image.jpegData(compressionQuality: 0.5) else {
        let error = NSError(domain: "com.example.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid image data"])
        completion(.failure(error))
        return
    }
    
    let storageRef = Storage.storage().reference()
    let profilePhotoRef = storageRef.child("profile_photos/\(userID).jpg")
    
    // Upload the image data to Firebase Storage
    let uploadTask = profilePhotoRef.putData(imageData, metadata: nil) { (metadata, error) in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        // Get the download URL for the uploaded image
        profilePhotoRef.downloadURL { (url, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let photoURL = url else {
                let error = NSError(domain: "com.example.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid photo URL"])
                completion(.failure(error))
                return
            }
            
            // Update the user's profile photo URL with the download URL
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.photoURL = photoURL
            changeRequest?.commitChanges(completion: { (error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                // Return success if the changes are committed successfully
                completion(.success(()))
            })
        }
    }
}




struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}
