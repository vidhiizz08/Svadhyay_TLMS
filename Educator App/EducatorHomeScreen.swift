

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct EducatorHomeScreen: View {
    @EnvironmentObject var authViewModel: UserAuthentication
    @ObservedObject var firebaseFetch = FirebaseFetch()
    @State var navAhead : Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                VStack {
                                    Text("Hi, Educator 👋")
                                        .font(.title)
                                        .fontWeight(.bold)
                                    Text("Start teaching!")
                                }
                                Spacer()
                                HStack {
                                  
            
                                    Button(action: {
                                        navAhead = true
                                    }) {
                                        Image(systemName: "bell.fill")
                                            .font(.title2)
                                            .foregroundColor(Color("color 1"))
                                    }
                                    NavigationLink(destination : NotificationPage(educatorID: Auth.auth().currentUser!.uid), isActive: $navAhead) {
                                        EmptyView()
                                    }
                                    .padding(.horizontal,2)
                               
                                    Button(action: {
                                        do {
                                            try Auth.auth().signOut()
                                            authViewModel.signOut()
                                        } catch let signOutError as NSError {
                                            print("Error signing out: %@", signOutError)
                                        }
                                    }) {
                                        Image(systemName: "rectangle.portrait.and.arrow.right")
                                            .font(.title2)
                                            .foregroundColor(Color("color 1"))
                                    }
                                    
                                    
                                }
                            }
                                .font(.subheadline)
                            Text("Enrollments")
                                .font(.subheadline).padding(.top)
                            
                            
                        }
                        Spacer()
                        
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // Enrollments
                    HStack {
                        EnrollmentCard(title: "Total Courses", count: firebaseFetch.assignedCourses.filter({$0.state != "created"}).count, color: Color(hexc: "A69EE5"), icon: "book.fill")
                        EnrollmentCard(title: "Ongoing Courses", count: firebaseFetch.assignedCourses.filter({$0.state == "processing"}).count, color: Color(hexc: "98CCF2"), icon: "play.rectangle.fill")
                    }
                    .padding(.horizontal)
                    
                    
                    // Ongoing Courses
                    SectionHeader(title: "Ongoing Courses")
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(firebaseFetch.assignedCourses.filter{$0.state == "processing"}){ course in
                                CourseCard(course : course)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // My Courses
                    SectionHeader2(title: "My Courses")
                    
                    VStack(spacing: 10) {

                        ForEach(firebaseFetch.assignedCourses.filter{$0.state == "published"}){ course in
                            MyCourseCard(course : course)
                        }

                    }
                    .padding(.horizontal)
                }
                .onAppear() {
                    firebaseFetch.fetchAssignedCourses(educatorID: Auth.auth().currentUser!.uid)
                }
            }
            .navigationBarHidden(true)
        }

    }
}

struct EnrollmentCard: View {
    var title: String
    var count: Int
    var color: Color
    var icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .font(.title)
                Spacer()
                Text("\(count)")
                    .font(.title)
                    .fontWeight(.bold)
            }
            Text(title)
                .font(.subheadline)
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(10)
        
    }
}



struct CourseCard: View {
    var course : Course
    
    var body: some View {
        NavigationLink(destination: CourseUploadFile(course : course)) {
            VStack(alignment: .leading) {
                CoursethumbnailImage(imageURL: course.courseImageURL, width: 150, height: 130)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(10)
                Text(course.courseName)
                    .font(.body)
                    .foregroundColor(.black)
                Spacer()
            }
            .frame(width: 150)
        }
    }
}

struct MyCourseCard: View {
    var course : Course
    @State var mycourse = false
    var body: some View {
        NavigationLink( destination: CompleteCourse(course: course)){
            HStack {
                CoursethumbnailImage(imageURL: course.courseImageURL, width: 60 ,height: 60)
                VStack(alignment: .leading) {
                    Text(course.courseName)
                        .font(.headline)
                    Text("1000 Enrollments")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
    }
}

struct SectionHeader: View {
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
            Spacer()
            Text("See All")
                .foregroundColor(.blue)
        }
        .padding(.horizontal)
    }
}

struct SectionHeader2: View {
    var title: String
 
    
    var body: some View {
            HStack {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                
                   
                
            }
            .padding(.horizontal)
      
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EducatorHomeScreen()
    }
}
