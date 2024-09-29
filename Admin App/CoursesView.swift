import SwiftUI

struct CoursesView: View {
    @State private var showModal = false
    @State private var navigateToCoursesCreation = false
    @StateObject private var viewModel = CoursesListViewModel()
    @StateObject private var viewModelForPublishedCourse = PublishedCoursesListViewModel()
    @State var selectedTarget: String
    @State var shouldShowOnboard : Bool = true
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                    GeometryReader { geometry in
                            VStack(){
                                if viewModel.courses.isEmpty {
                                    Text("No Courses")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(.black))
                                        .opacity(0)
                                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.4)
                                } else {
                                   
                                    VStack {
                                        
                                        HStack {
                                                    Text("Ongoing Courses")
                                                        .font(.system(size: 20))
                                                        .fontWeight(.bold)
                                                    Spacer()
                                                }
                                                .padding(.horizontal)
                                                .padding(.top)
                                        
                                        
                                        ScrollView(.horizontal ){
                                            HStack(alignment: .center, spacing: 10){
                                                ForEach(viewModel.courses){
                                                    course in
                                                    CourseCardView(course: course)
                                                    
                                                }
                                                .onAppear(){
                                                    viewModel.fetchCourses(targetName: selectedTarget)
                                            }
                                            }.padding(20)
                                            
                                        }
                                        
                                        
                                        HStack {
                                                    Text("Published Courses")
                                                        .font(.system(size: 20))
                                                        .fontWeight(.bold)
                                                    Spacer()
                                                }
                                                .padding(.horizontal)
                                                .padding(.top)
                                        
                                        
                                        ScrollView(.vertical){
                                            VStack( spacing: 10){
                                                ForEach(viewModelForPublishedCourse.courses){
                                                    course in
                                                    HorizontalCardView(course: course)
                                                }
                                                .onAppear(){
                                                    viewModelForPublishedCourse.fetchCourses(targetName: selectedTarget)
                                            }
                                            }.padding(.top , 10)
                                               
                                    
                                        }
                              
                                    }
                                }
                            }
                        
                    }
                


                Image("homescreenWave")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.bottom)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showModal.toggle()
                    }) {
                        HStack {
                            Text(selectedTarget)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            Image(systemName: "chevron.down")
                                .foregroundColor(.black)
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CourseCreationView(targetName: selectedTarget), isActive: $navigateToCoursesCreation) {
                        Button(action: {
                            navigateToCoursesCreation = true
                            print("Plus button tapped")
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 15))
                                .fontWeight(.bold)
                        }
                    }
                }
            }
            .navigationBarHidden(false)
            .edgesIgnoringSafeArea(.bottom)
            .sheet(isPresented: $showModal) {
                DomainSelectionView(selectedTarget: $selectedTarget, showModal: $showModal)
                    .presentationDetents([.height(270)]) // Adjust the height based on the content
            }
            .onAppear {
                viewModel.fetchCourses(targetName: selectedTarget)
                viewModelForPublishedCourse.fetchCourses(targetName: selectedTarget)
            }
            .onChange(of: selectedTarget) { newTarget in
                viewModel.fetchCourses(targetName: newTarget)
                viewModelForPublishedCourse.fetchCourses(targetName: selectedTarget)
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct HorizontalCardView: View {
    @State var course : Course
    @State var courseService = CourseServices()
   
    
    var body: some View {
            HStack{
                CoursethumbnailImage(imageURL: course.courseImageURL, width: 50, height: 50)
                    .frame(width: 50, height: 50)
                    .clipShape(.circle)

        
                VStack(alignment: .leading , spacing: 10){
                    Text(course.courseName)
                        .font(.headline)
                        .bold()
                        .foregroundColor(.black)
                        .lineLimit(1)
                    Text(course.courseDescription.limitedWords(to: 8))
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                }
              
            }
            .frame(width: 354, height: 100)
            .background(Color("noticationBoxColour"))
            .cornerRadius(12)
            .shadow(radius: 3)
    }
    
    
}
extension String {
    func limitedWords(to wordLimit: Int) -> String {
        let words = self.split(separator: " ")
        if words.count <= wordLimit {
            return self
        } else {
            return words.prefix(wordLimit).joined(separator: " ") + "..."
        }
    }
}

struct DomainSelectionView: View {
    @Binding var selectedTarget: String
    @Binding var showModal: Bool
    @State var targets: [String] = []
    @State var courseService = CourseServices()

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(targets, id: \.self) { target in
                        Button(action: {
                            selectedTarget = target
                            showModal.toggle()
                        }) {
                            Text(target)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .cornerRadius(8)
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            allTargets()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }

    func allTargets() {
        courseService.fetchTargets { fetchedTargets in
            print("Fetched Targets: \(fetchedTargets)")
            self.targets = fetchedTargets
        }
    }
}

class CoursesListViewModel: ObservableObject {
    @Published var courses: [Course] = []
    private let courseService = CourseServices()

    func fetchCourses(targetName: String) {
        courseService.fetchCoursesByTarget(targetName: targetName) { courses, error in
            if let error = error {
                print("Error fetching courses: \(error.localizedDescription)")
                return
            }
            
            if let courses = courses {
                DispatchQueue.main.async {
                    self.courses = courses
                }
            }
        }
    }
}
class PublishedCoursesListViewModel: ObservableObject {
    @Published var courses: [Course] = []
    private let courseService = CourseServices()

    func fetchCourses(targetName: String) {
        courseService.fetchCoursesByTargetAndState(targetName: targetName) { courses, error in
            if let error = error {
                print("Error fetching courses: \(error.localizedDescription)")
                return
            }
            
            if let courses = courses {
                DispatchQueue.main.async {
                    self.courses = courses
                }
            }
        }
    }
}



struct CourseView_Previews: PreviewProvider {
    static var previews: some View {
        CoursesView(selectedTarget: "HAHA! Joker")
    }
}
