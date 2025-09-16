import SwiftUI
import PhotosUI

struct ProfileEditView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var username: String = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var profileImage: Image?
    @State private var showingPhotoPicker = false
    
    var body: some View {
        NavigationView {
            ZStack {
                
                    LinearGradient(colors: [.clas1, .colorS], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack {
                    Form {
                        Section("Profile Photo") {
                            VStack {
                                if let profileImage = profileImage {
                                    profileImage
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.black)
                                }
                                
                                PhotosPicker(selection: $selectedItem,
                                             matching: .images) {
                                    Text("Select photo")
                                }
                            }
                           
                            .frame(maxWidth: .infinity)
                            .padding(.vertical)
                        }
                        
                        Section("Personal data") {
                            TextField("Имя", text: $username)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
            leading: Button("Cancel") {
            dismiss()
            },
            trailing: Button("Save") {
            saveProfile()
            }
            )
            .onChange(of: selectedItem) { _ in
                Task {
                    if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                        if let uiImage = UIImage(data: data) {
                            profileImage = Image(uiImage: uiImage)
                        }
                    }
                }
            }
            .onAppear {
                if let user = appViewModel.currentUser {
                    username = user.username
                }
            }
        }
        .scrollContentBackground(.hidden)
      
      
    }
    
    private func saveProfile() {
        appViewModel.updateProfile(username: username)
        dismiss()
    }
}

