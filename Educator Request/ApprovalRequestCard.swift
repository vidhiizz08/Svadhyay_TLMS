import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ApprovalRequestCard: View {
    var educator: Educator
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationLink(destination: DetailedEducatorRequestView(educator: educator)) {
            HStack(alignment: .center, spacing: 16) {
                
                ProfileCircleImage(imageURL: educator.profileImageURL, width: 60, height: 60)
                    .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 1)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(educator.firstName + " " + educator.lastName)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    SubHeadlineText(text2: educator.about)
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                }
                Spacer()
            }
            .padding()
            .background(colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 1)
            .padding(.horizontal, 5)
        }
        .navigationTitle("Approval Request")
    }
}

struct ApprovalRequestCard_Previews: PreviewProvider {
    static var previews: some View {
        let educator = Educator(
            firstName: "Dummy", lastName: "User", about: "Beware of my presence, Coders!", email: "veronica@gmail.com", password: "1234567", phoneNumber: "7878787878", profileImageURL: "fhgfgd"
        )
        Group {
            ApprovalRequestCard(educator: educator)
                .preferredColorScheme(.light)
            
            ApprovalRequestCard(educator: educator)
                .preferredColorScheme(.dark)
        }
    }
}
