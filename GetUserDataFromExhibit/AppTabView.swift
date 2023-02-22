//
//  AppTabView.swift
//  GetUserDataFromExhibit
//
//  Created by Steven Hertz on 2/22/23.
//

import SwiftUI

struct AppTabView: View {
    var body: some View {
        TabView {
            NavigationView {
                ContentView()
                    .navigationBarTitle("Add Contact")
            }
            .tabItem {
                Text("Add Contact")
            }

            NavigationView {
                HistoryView()
                    .navigationBarTitle("History")
            }
            .tabItem {
                Text("History")
            }
        }
    }}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
