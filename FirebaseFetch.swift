import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

@MainActor
class FirebaseFetch: ObservableObject {
    @Published public var pendingEducators: [Educator] = []
    @Published public var educators: [Educator] = []
    @Published public var learners: [Learner] = []
    @Published public var courses: [Course] = []
    @Published public var searchText: String = ""
    @Published var isLoading = true
    @Published var assignedCourses: [Course] = []

    init() {
        fetchPendingEducators()
    }
    
    func fetchPendingEducators() {
        let db = Firestore.firestore()
        self.pendingEducators = []
        
        db.collection("Pending-Educators").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching pending educators: \(error.localizedDescription)")
            } else {
                self.pendingEducators = querySnapshot?.documents.compactMap { doc in
                    let data = doc.data()
                    return Educator(id : doc.documentID,
                                    firstName: data["FirstName"] as? String ?? "",
                                    lastName: data["LastName"] as? String ?? "",
                                    about: data["about"] as? String ?? "",
                                    email: data["email"] as? String ?? "",
                                    password: data["password"] as? String ?? "",
                                    phoneNumber: data["phoneNumber"] as? String ?? "",
                                    profileImageURL: data["profileImageURL"] as? String ?? ""
                    )
                } ?? []
            }
            
        }
    }
    
    func removeEducator(educator: Educator) {
            let db = Firestore.firestore()
            db.collection("Pending-Educators").document(educator.email).delete() { error in
                if let error = error {
                    print("Error removing document: \(error)")
                } else {
                    self.fetchPendingEducators()
                }
            }
        }
        
    func moveEducatorToApproved(educator: Educator) {
        let db = Firestore.firestore()
        var educatorData: [String: Any] = [
            "FirstName": educator.firstName,
            "LastName": educator.lastName,
            "about": educator.about,
            "email": educator.email,
            "password": educator.password,
            "phoneNumber": educator.phoneNumber,
            "profileImageURL": educator.profileImageURL,
            "role" : "educator",
            "assignedCoursesID" : []
        ]
        
        Auth.auth().createUser(withEmail: educator.email, password: educator.password) {
            authRes, error in if let _ = error {
                print("Error Creating a User. (Moving from Pending Educator to Educator Collection)")
            } else {
                guard let uid = authRes?.user.uid else {
                    print("Error retrieving user UID.")
                    return
                }
                educatorData["id"] = uid
                db.collection("Educators").document(uid).setData(educatorData) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        self.removeEducator(educator: educator)
                    }
                }
            }
        }
    }
    
    func fetchEducators() {
            let db = Firestore.firestore()
            db.collection("Educators").getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching educators: \(error.localizedDescription)")
                    return
                }

                self.educators = snapshot?.documents.compactMap { doc -> Educator? in
                    let data = doc.data()
                    let id = doc.documentID
                    let firstName = data["FirstName"] as? String ?? ""
                    let lastName = data["LastName"] as? String ?? ""
                    let profileImageURL = data["profileImageURL"] as? String ?? ""
                    return Educator(id : doc.documentID,
                                    firstName: data["FirstName"] as? String ?? "",
                                    lastName: data["LastName"] as? String ?? "",
                                    about: data["about"] as? String ?? "",
                                    email: data["email"] as? String ?? "",
                                    password: data["password"] as? String ?? "",
                                    phoneNumber: data["phoneNumber"] as? String ?? "",
                                    profileImageURL: data["profileImageURL"] as? String ?? ""
                    )
                } ?? []
            }
            
            var filteredEducators: [Educator] {
                if searchText.isEmpty {
                    return educators
                } else {
                    return educators.filter { $0.firstName.lowercased().contains(searchText.lowercased()) }
                }
            }
        }
     
    
    func fetchLearners() {
        let db = Firestore.firestore()
        db.collection("Learners").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching educators: \(error.localizedDescription)")
                return
            }
            
            self.learners = snapshot?.documents.compactMap { doc -> Learner? in
                let data = doc.data()
                let id = doc.documentID
                let firstName = data["FirstName"] as? String ?? ""
                let lastName = data["LastName"] as? String ?? ""
                return Learner(id : doc.documentID,
                               email: data["Email"] as? String ?? "",
                               firstName: data["FirstName"] as? String ?? "",
                               lastName: data["LastName"] as? String ?? "",
                               joinedDate: data["joinedData"] as? String ?? ""
                )
            } ?? []
        }
    }

    
    func fetchCourses() {
        let db = Firestore.firestore()
        db.collection("Courses").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching educators: \(error.localizedDescription)")
                return
            }
            
            self.courses = snapshot?.documents.compactMap { doc -> Course? in
                let data = doc.data()
                let id = doc.documentID
                let courseName = data["courseName"] as? String ?? ""
                let courseDescription = data["courseDescription"] as? String ?? ""
                let courseImageURL = data["courseImageURL"] as? String
                let releaseDate = (data["releaseDate"] as? Timestamp)?.dateValue()
                let assignedEducatorData = data["assignedEducator"] as? [String: Any] ?? [:]
                let assignedEducator = Educator(
                    firstName: assignedEducatorData["firstName"] as? String ?? "",
                    lastName: assignedEducatorData["lastName"] as? String ?? "",
                    about: assignedEducatorData["about"] as? String ?? "",
                    email: assignedEducatorData["email"] as? String ?? "",
                    password: assignedEducatorData["password"] as? String ?? "",
                    phoneNumber: assignedEducatorData["phoneNumber"] as? String ?? "",
                    profileImageURL: assignedEducatorData["profileImageURL"] as? String ?? ""
                )
                let target = data["target"] as? String ?? ""
                let state = data["state"] as? String ?? ""
                
                return Course(
                    courseID: UUID(),
                    courseName: courseName,
                    courseDescription: courseDescription,
                    courseImageURL: courseImageURL,
                    releaseDate: releaseDate,
                    assignedEducator: assignedEducator,
                    target: target,
                    state: state
                )
            } ?? []
        }
    }
    
    func fetchAssignedCourses(educatorID: String) {
        let db = Firestore.firestore()
        let educatorRef = db.collection("Educators").document(educatorID)
        
        self.assignedCourses.removeAll()
        
        educatorRef.getDocument { document, error in
            if let error = error {
                print("Error fetching educator: \(error.localizedDescription)")
                self.isLoading = false
                return
            }
            
            guard let document = document, document.exists,
                  let data = document.data(),
                  let assignedCourseIDs = data["assignedCourses"] as? [String] else {
                self.isLoading = false
                return
            }
            
            let coursesRef = db.collection("Courses")
            let dispatchGroup = DispatchGroup()
            
            for courseID in assignedCourseIDs {
                dispatchGroup.enter()
                
                coursesRef.whereField("courseID", isEqualTo: courseID).getDocuments { snapshot, error in
                    if let error = error {
                        print("Error fetching course: \(error.localizedDescription)")
                        dispatchGroup.leave()
                        return
                    }
                    
                    guard let documents = snapshot?.documents, let document = documents.first else {
                        dispatchGroup.leave()
                        return
                    }
                    
                    let data = document.data()
                    let courseIDString = data["courseID"] as? String ?? ""
                    guard let courseID = UUID(uuidString: courseIDString) else {
                        dispatchGroup.leave()
                        return
                    }
                    let courseName = data["courseName"] as? String ?? ""
                    let courseDescription = data["courseDescription"] as? String ?? ""
                    let courseImageURL = data["courseImageURL"] as? String
                    let releaseDate = (data["releaseDate"] as? Timestamp)?.dateValue()
                    let assignedEducatorData = data["assignedEducator"] as? [String: Any] ?? [:]
                    let assignedEducator = Educator(
                        firstName: assignedEducatorData["firstName"] as? String ?? "",
                        lastName: assignedEducatorData["lastName"] as? String ?? "",
                        about: assignedEducatorData["about"] as? String ?? "",
                        email: assignedEducatorData["email"] as? String ?? "",
                        password: assignedEducatorData["password"] as? String ?? "",
                        phoneNumber: assignedEducatorData["phoneNumber"] as? String ?? "",
                        profileImageURL: assignedEducatorData["profileImageURL"] as? String ?? ""
                    )
                    let target = data["target"] as? String ?? ""
                    let state = data["state"] as? String ?? ""
                    
                    let course = Course(
                        courseID: courseID,
                        courseName: courseName,
                        courseDescription: courseDescription,
                        courseImageURL: courseImageURL,
                        releaseDate: releaseDate,
                        assignedEducator: assignedEducator,
                        target: target,
                        state: state
                    )
                    
                    DispatchQueue.main.async {
                        print("Fetched course: \(course.courseName), \(course.courseID.uuidString)")
                        self.assignedCourses.append(course)
                        dispatchGroup.leave()
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                print("All courses fetched.")
                self.isLoading = false
            }
        }
    }
}
