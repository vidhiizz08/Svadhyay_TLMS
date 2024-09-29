//
//  CompleteCourses.swift
//  TLMS-admin
//
//  Created by Mac on 18/07/24.
//

import SwiftUI

struct CompleteCourse: View {
    @State var courseService = CourseServices()
    var course : Course
    @State var modules : [Module] = []
    private let segments = ["Content", "Quiz"]
    @State private var selectedSegment = 0
    @State private var isNavigatingToChat = false
    var body: some View {
        ScrollView{
            HStack(alignment: .center){CoursethumbnailImage(imageURL: course.courseImageURL, width: 354, height: 200)}
                .padding(.top, 20)
            VStack(alignment: .leading, spacing: 10){
                
                Text(course.courseName)
                    .font(.custom("Poppins-SemiBold", size: 24))
                Text(course.courseDescription)
                    .font(.custom("Poppins-Regular", size: 18))
                
                Picker("Select Segment", selection: $selectedSegment) {
                    ForEach(0..<segments.count) { index in
                        Text(segments[index])
                            .tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if selectedSegment == 0 {
                    VideoModuleSection(course: course, modules: modules)
                }
                else if selectedSegment == 1{
                    VideoModuleSection(course: course, modules: modules)
                }
                
                
            }.padding(20)
                .navigationTitle("Course Name")
                .navigationBarTitleDisplayMode(.inline)
            VStack {
                NavigationLink(destination:Chatview(), isActive: $isNavigatingToChat) {
                    CustomButton(label: "Discussion", action: {
                        isNavigatingToChat = true
                    })
                }
            }
            .onAppear() {
                allModules()
            }
        }
        
    }
        
        func allModules() {
            courseService.fetchModules(course: course) { modules in
                self.modules = modules
            }
        }
    }
    
    
    
    
    struct VideoModuleSection: View {
        @State var courseService = CourseServices()
        var course : Course
        var modules : [Module]
        
        var body: some View {
            ForEach(modules, id: \.id){ module in
                VStack(alignment: .leading){
                    Text(module.title)
                        .font(.custom("Poppins-SemiBold", size: 18))
                    VideoModuleCard()
                }
            }
        }
    }
    
    
    struct VideoModuleCard: View {
        
        var body: some View {
            
            VStack(alignment: .center, spacing: 0){
                
                HStack(spacing: 10){
                    Image("SwiftLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 50)
                    
                    Text("Video Title")
                        .font(.custom("Poppins-Medium", size: 18))
                        .lineLimit(1)
                    Spacer()
                    
                }
                .frame(width: 354)
                .padding(10)
                Divider()
                //Video Review Card
                HStack(spacing: 10){
                    Image("SwiftLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 50)
                    
                    Text("Notes Title")
                        .font(.custom("Poppins-Medium", size: 18))
                        .lineLimit(1)
                    Spacer()
                    
                    
                }.padding(10)
                
            }.background(Color("color 3"))
                .cornerRadius(12)
        }
    }

    
    #Preview {
        PublishCourse(course: Course(courseID: UUID(), courseName: "afdsf", courseDescription: "sdfs", assignedEducator: Educator(firstName: "sdfsd", lastName: "sdfsd", about: "sdfsd", email: "fsdf", password: "sdfsdf", phoneNumber: "sdfsd", profileImageURL: "sdfsdf"), target: "fasd", state: "asdfa"))
    }

