import SwiftUI
import FirebaseAuth

struct TargetScreen: View {
    
    @EnvironmentObject var authViewModel : UserAuthentication
    @State var courseService = CourseServices()
    @State var targets : [String] = []
    @State private var isPresentingNewTarget = false
    @State private var isSelected = false
//    var course: Course
    @Environment(\.colorScheme) var colorScheme // Add this line to access color scheme

    @State var isRefreshing = false
    var body: some View {
        NavigationView {
            VStack(){
                    HStack(alignment: .center){
                        TitleLabel(text: "Target")
                        Spacer()
                        
                        Button(action: {
                            isPresentingNewTarget = true
                        }) {
                            
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundColor(colorScheme == .dark ? .white : Color(hex: "#6C5DD4")!)
                            
                            Text("Add Target")
                                .font(.subheadline)
                                .foregroundColor(colorScheme == .dark ? .white : Color(hex: "#6C5DD4")!)
                                .fontWeight(.bold)
                            
                        }
                    }.padding(20)

                    ScrollView{
                        if targets.isEmpty {
                            Text("No Target")
                                .foregroundColor(colorScheme == .dark ? .white : Color(hex: "#6C5DD4")!)
                                .font(.custom("headline", size: 24))
                                .fontWeight(.bold)
                                .padding(.top, 200)
                        } else {
                            ForEach(targets, id: \.self) { target in
                                TargetsCardView(targetName: target, onUpdate: {
                                    allTargets()
                                })
                            }
                            .navigationTitle("Our Target")
                            .navigationBarTitleDisplayMode(.inline)
                        }
                    }
//                    .padding()
                    .onChange(of : isRefreshing) {
                        allTargets()
                    }
                    .onAppear {
                        allTargets()
                    }
                    }
                
            
        }
        
        .sheet(isPresented: $isPresentingNewTarget, content: {
            NewTargetScreen()
        })
        
    }
    
    
    func allTargets() {
        courseService.fetchTargets { fetchedTargets in
            print("Fetched Targets : \(fetchedTargets)")
            self.targets = fetchedTargets
        }
    }
}
    

struct NewTargetScreen: View {
    
    @State var courseService = CourseServices()
    
    @State private var TargetTitle: String = ""
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Target")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.init(top: 0, leading: 40, bottom: 0, trailing: 0))
                Spacer()
                Button(action: {
                    if !TargetTitle.isEmpty {
                        courseService.uploadTarget(targetName: TargetTitle) {
                            success in
                            if success {
                                print("Successfully created a target.")
                            } else {
                                print("Couldn't create a target.")
                            }
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Done")
                        .font(.title3)
                }
            }
            .padding()
            
            Divider()
                .padding(.horizontal)
            
            TextField("Add Target Title", text: $TargetTitle)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    TargetScreen()
}
