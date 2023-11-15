//
//  ContentView.swift
//  MyMomii
//
//  Created by jaelyung kim on 11/7/23.
//

import SwiftUI

struct ContentView: View {
    @State var isSettingMainView = false
    @State var isTargetMainView = false
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Button(action: {
                    self.isSettingMainView = true
                }, label: {
                    Text("SettingMainView")
                })
                .navigationDestination(isPresented: $isSettingMainView) {
                    SettingMainView()
                }

                Button(action: {
                    self.isTargetMainView = true
                }, label: {
                    Text("TargetMainView")
                })
                .navigationDestination(isPresented: $isTargetMainView) {
                    TargetMainView()
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
