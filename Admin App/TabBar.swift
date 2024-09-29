import SwiftUI

struct TabBar: View {
    @State private var selectedTabIndex = 1 // Default to CoursesView (index 1)
    var target: String
    @Environment(\.colorScheme) var colorScheme

    var body: some View {

        

            VStack {
                CustomTabBarAppearance() // Apply custom tab bar appearance
                    .frame(height: 0) // Hide the actual tab bar
                    .hidden()

                TabView(selection: $selectedTabIndex) {
                    NavigationStack{
                        NotificationView()}
                        .tabItem {
                            Image(systemName: "bell")
                            Text("Notification")
                        }
                        .tag(0) // Tag for NotificationView

                    NavigationStack{
                        CoursesView(selectedTarget: target)}

                        .tabItem {
                            Image(systemName: "book")
                            Text("Courses")
                        }
                        .tag(1) // Tag for CoursesView

                    NavigationStack{
                        EducatorListView()}

                        .tabItem {
                            Image(systemName: "person.3.fill")
                            Text("users")
                        }

                        .tag(2) // Tag for ProfileView
                    NavigationStack{
                        StatsView()}
                        .tabItem {
                            Image(systemName: "chart.bar.xaxis")
                            Text("Enrolments")
                        }
                        .tag(3)
                
               
                .navigationBarBackButtonHidden(true)}
            

        }
        .navigationBarHidden(true)
    }
}

struct CustomTabBarAppearance: UIViewControllerRepresentable {
    @Environment(\.colorScheme) var colorScheme

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = colorScheme == .dark ? UIColor.black : UIColor.white // Adjust background color for dark mode

        // Customize tab bar item colors
        let itemAppearance = UITabBarItemAppearance()
        let selectedColor = UIColor(Color(hex: "#6C5DD4") ?? Color(.black))
        let normalColor = UIColor(Color(hex: "#6C5DD4")?.opacity(0.7) ?? Color(.black))

        itemAppearance.normal.iconColor = normalColor
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: normalColor]
        itemAppearance.selected.iconColor = selectedColor
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: selectedColor]
        tabBarAppearance.stackedLayoutAppearance = itemAppearance

        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No update needed
    }
}


struct ProfileView: View {
    var body: some View {
        Text("Educators")
            .foregroundColor(.primary) // Adjust text color for dark mode
    }
}

//struct EducatorListView: View {
//    var body: some View {
//        Text("Educators List")
//            .foregroundColor(.primary) // Adjust text color for dark mode
//    }
//}

//#Preview {
//    TabBar(target: "HAHA! ")
//}
