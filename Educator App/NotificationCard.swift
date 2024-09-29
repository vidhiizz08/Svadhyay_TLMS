//
//  NotificationCard.swift
//  TLMS-admin
//
//  Created by Abcom on 12/07/24.
//

import SwiftUI

struct NotificationCard: View {
    @State var course : Course
    @State var courseService = CourseServices()
    var onUpdate: () -> Void
    
    var body: some View {
            HStack{
                CoursethumbnailImage(imageURL: course.courseImageURL, width: 50, height: 50)
                    .frame(width: 50, height: 50)
                    .clipShape(.circle)
//                Spacer()
                VStack(alignment: .leading , spacing: 10){
                    Text(course.courseName)
                        .font(.headline)
                        .bold()
                        .foregroundColor(.black)
                        .lineLimit(1)
                    Text(course.courseDescription)
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                Spacer()
                Divider()
                    Button(action : {
                        courseService.updateCourseState(course : course, newState: "processing") { error in
                             if let error = error {
                                 print("Error updating course state: \(error.localizedDescription)")
                                 print(course.courseID.uuidString)
                             } else {
                                 onUpdate()
                             }
                            
                         }
                    }) {
                        Text("Accept")
                    }
                        
                
            }.padding()
            .frame(width: 354, height: 100)
            .background(Color("noticationBoxColour"))
            .cornerRadius(12)
            .shadow(radius: 3)
    }
}


struct NotificationCard_Previews: PreviewProvider {
    static var previews: some View {
        let course = Course(courseID: UUID(), courseName: "Swift Fundamentals", courseDescription: "Discover SwiftUI's power in our immersive course! fcec ercerc reerc rfv fve", assignedEducator: Educator(firstName: "rgsdvc", lastName: "thegrsec", about: "trebsvec", email: "tbrsvdac", password: "tbdvsc", phoneNumber: "trbrvsda", profileImageURL: "brvsdc"), target: "tbvsdc", state: "bfvsd")
        
        NotificationCard(course: course, onUpdate: {})
    }
}
