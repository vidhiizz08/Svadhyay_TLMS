
import Foundation
import SwiftUI

struct EducatorListView: View {
    @State private var check = false
    @State private var selectedSegment = 0
    @State private var searchText = ""
    private let segments = ["Educators", "Learners"]
    @Environment(\.colorScheme) var colorScheme

    @ObservedObject var firebaseFetch = FirebaseFetch()
    
    var body: some View {
        
        VStack(alignment: .center){
                Picker("Select Segment", selection: $selectedSegment) {
                    ForEach(0..<segments.count) { index in
                        Text(segments[index])
                            .tag(index)
                    }
                }.padding()
                .pickerStyle(SegmentedPickerStyle())
               
                
               
            HStack {
                TextField("Search User", text: $searchText)
                    .padding(.horizontal, 40)
                    .padding(7)
                    .shadow(color: .gray, radius: 3)
                    .background(Color(.white))
                    .cornerRadius(8)
                    .overlay(
                        HStack {
                            Spacer()
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.trailing,320)
                        }
                    )
                
                Spacer()
            }.shadow(radius: 6)
                .padding(10)
                        
               
                   
     
     

                if selectedSegment == 0 {
                    GeometryReader { geometry in
                        ScrollView {
                            VStack(spacing: 10) {
                                let filteredEducators = searchText.isEmpty ? firebaseFetch.educators : firebaseFetch.educators.filter {
                                    $0.firstName.lowercased().contains(searchText.lowercased()) ||
                                    $0.lastName.lowercased().contains(searchText.lowercased()) ||
                                    $0.about.lowercased().contains(searchText.lowercased())
                                }
                                
                                if filteredEducators.isEmpty {
                                    Text("No results found")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.4)
                                } else {
                                    ForEach(filteredEducators) { educator in
                                        EducatorsListCard(educator: educator)
                                           
                                            .background(Color("color 3"))
                                            .cornerRadius(12)
                                            .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 5)
                                            .padding(10)
                                            
                                    }
                                }
                            }
                        }.padding(10)
                        
                    }
                } else if selectedSegment == 1 {
                    GeometryReader { geometry in
                        ScrollView {
                            VStack(spacing: 5) {
                                let filteredLearners = searchText.isEmpty ? firebaseFetch.learners : firebaseFetch.learners.filter {
                                    $0.firstName!.lowercased().contains(searchText.lowercased()) ||
                                    $0.lastName!.lowercased().contains(searchText.lowercased())
                                }
                                
                                if filteredLearners.isEmpty {
                                    Text("No results found")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.4)
                                } else {
                                    ForEach(filteredLearners) { learner in
                                        LearnerListCard(learner: learner)
                                         
                                        .background(Color("color 3"))
                                        .cornerRadius(12)
                                        .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 5)
                                        .padding(10)
                                    }
                                }
                            }
                        }.padding(10)
                       
                    }
                }
        }
        
     
            .onAppear {
                firebaseFetch.fetchEducators()
                firebaseFetch.fetchLearners()
            }
            .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct EducatorsListCard: View {
    var educator: Educator
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationLink(destination: EducatorProfile(educator: educator)) {
            HStack(spacing: 10) {
                ProfileCircleImage(imageURL: educator.profileImageURL, width: 60, height: 60)

                VStack(alignment: .leading) {
                    Text(educator.firstName + " " + educator.lastName)
                        .font(.custom("Poppins-Medium", size: 18))
                        .foregroundColor(.primary)
                    Text(educator.about)
                        .lineLimit(2)
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding(10)

            .frame(height: 100)

        }
        .navigationTitle("User")
    }
}

struct LearnerListCard: View {
    var learner: Learner
    

    var body: some View {
//        NavigationLink(destination: EducatorProfile()) {
            HStack(spacing: 10) {
                ProfileCircleImage(imageURL: learner.firstName!, width: 60, height: 60)

                VStack(alignment: .leading) {
                    Text(learner.firstName! + " " + learner.lastName!)
                        .font(.custom("Poppins-Medium", size: 18))
                        .foregroundColor(.primary)
                    Text("Since \(learner.joinedDate!)")
                        .lineLimit(2)
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding(10)
            .frame(width: 354, height: 100)
//        }
        .navigationTitle("Learners")
    }
}

#Preview {
    EducatorsListCard(educator: Educator(id: "Dummyq", firstName: "rhdgsvdgr", lastName: "hdvsx", about: "hregsdvz", email: "htdfbvsc", password: "grdsc", phoneNumber: "bfdvcsxa", profileImageURL: "ngbdvs"))
}

