//
//  MainScrene.swift
//  TLMS-admin
//
//  Created by Priyanshu Gupta on 03/07/24.
//

import Foundation
import SwiftUI

struct MainView:View{
    var body: some View{
        NavigationView{
            VStack{
                MainScreenView()
            }
           
        }
    }
    
}
struct Main_Preview:
    PreviewProvider{
    static var previews: some View{
        MainView()
    }
}

struct AdminButton:View {
    var title:String
    var body: some View {
        
        NavigationLink(destination: AdminScreen()){
        Text(title).font(.title2).foregroundColor(.white).frame(maxWidth: .infinity , maxHeight: 50).background(Color(UIColor(named: "PrimaryColour")!)).cornerRadius(8).padding(.vertical)
        
        }
        
    }
}
struct EducatorButton:View {
    var title:String
    var body: some View {
            NavigationLink(destination: EducatorScreen()){
            Text(title).font(.title2).foregroundColor(.white).frame(maxWidth: .infinity , maxHeight: 50).background(Color(UIColor(named: "PrimaryColour")!)).cornerRadius(8).padding(.vertical)
            
            }
    }
}
struct MainScreenView: View {
    var body: some View {
        NavigationView{
            ZStack{
                Color(UIColor(named: "BackgroundColour")!).edgesIgnoringSafeArea(.all)
                
                VStack{
                    Text("Welcome To \n" + "Svadhyaya").bold().font(.title).frame(maxWidth: .infinity , alignment: .leading).padding(.vertical)
                    Text("Countinuous Learning Made Easy").font(.title2).foregroundColor(Color(UIColor(named: "PrimaryColour")!)).frame(maxWidth: .infinity , alignment: .leading)
                    
                    Spacer()
                    Image(.mainScreen).resizable().frame(width:300,height: 200).scaledToFit()
                    Spacer()
                    AdminButton(title: "Login as Admin")
                    EducatorButton(title: "Login as Educator")
                    
                }.padding()
            }
        }
    }
}
