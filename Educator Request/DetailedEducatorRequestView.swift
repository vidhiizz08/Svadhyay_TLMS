import SwiftUI

struct DetailedEducatorRequestView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var firebaseFetch = FirebaseFetch()
    var educator: Educator
    
    @State private var profileImage: Image? = Image(systemName: "person.circle.fill")
    
    var body: some View {
        VStack {
            // Profile Picture
            profileImage?
                .resizable()
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                .padding()
                .onTapGesture {
                    // Implement image picker logic here
                }
            Divider()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    InfoSection(title: "Name:", content: educator.firstName + " " + educator.lastName)
                    InfoSection(title: "About:", content: educator.about)
                    InfoSection(title: "Phone Number:", content: educator.phoneNumber)
                    InfoSection(title: "Email:", content: educator.email)
                }
                .padding(.horizontal)
            }
            .padding(.top)
            
            // Approval and Rejection Buttons
            HStack(spacing: 20) {
                RequestsButton(text: "Approve", action: {
                    firebaseFetch.moveEducatorToApproved(educator: educator)
                    presentationMode.wrappedValue.dismiss()
                })

                RequestsButton(text: "Reject", action: {
                    firebaseFetch.removeEducator(educator: educator)
                    presentationMode.wrappedValue.dismiss()
                })
            }
            .padding(.bottom)
        }
        .padding()
        .background(Color(.systemBackground))
        .edgesIgnoringSafeArea(.all)
    }
}

struct DetailedEducatorRequestView_Previews: PreviewProvider {
    static var previews: some View {
        let educator = Educator(
            firstName: "Veronica", lastName: "Lodge", about: "Hey Noobies, Coding isn't your thing!", email: "veronica@gmail.com", password: "123456", phoneNumber: "9898090909", profileImageURL: "ProfileURL"
        )
        DetailedEducatorRequestView(educator: educator)
    }
}

struct InfoSection: View {
    var title: String
    var content: String
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(colorScheme == .dark ? .white : .black)
            InfoFieldViews(text: content)
        }
    }
}

struct InfoFieldViews: View {
    var text: String
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Text(text)
            .padding()
            .background(colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6))
            .cornerRadius(10)
    }
}

struct RequestsButton: View {
    var text: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(Color.green)
                .cornerRadius(10)
        }
    }
}
