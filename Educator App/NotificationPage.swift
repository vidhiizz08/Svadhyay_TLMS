import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct NotificationPage: View {
    @StateObject var firebaseFetch = FirebaseFetch()

    var educatorID: String

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if firebaseFetch.isLoading {
                        ProgressView("Loading...")
                    } else {
                        ForEach(firebaseFetch.assignedCourses.filter { $0.state == "created" }) { course in
                            NotificationCard(course: course, onUpdate: {
                                firebaseFetch.fetchAssignedCourses(educatorID: educatorID)
                            })
                                .border(.black, width: 0.2)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Notification")
            .font(.custom("Poppins-Regular", size: 16))
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                firebaseFetch.fetchAssignedCourses(educatorID: educatorID)
                print("Assigned Courses are : ",firebaseFetch.assignedCourses)
            }
        }
    }
}


struct NotificationPage_Preview: PreviewProvider {
    static var previews: some View {
        NotificationPage(educatorID: "someEducatorID")
    }
}
