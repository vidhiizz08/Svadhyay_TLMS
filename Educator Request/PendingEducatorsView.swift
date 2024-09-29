import SwiftUI

struct PendingEducatorsView: View {
    @ObservedObject var firebaseFetch = FirebaseFetch()
    
    var body: some View {
        NavigationView {
            List(firebaseFetch.pendingEducators) { educator in
                ApprovalRequestCard(educator: educator)
            }
            .navigationTitle("Pending Educators")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                firebaseFetch.fetchPendingEducators()
            }
        }
    }
}

struct PendingEducatorsView_Previews: PreviewProvider {
    static var previews: some View {
        PendingEducatorsView()
    }
}

