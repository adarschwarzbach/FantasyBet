//
//  SplashView.swift
//  final
//
//  Created by Adar Schwarzbach on 4/22/23.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color(red: 65/255, green: 65/255, blue: 65/255)
                .ignoresSafeArea()

            VStack {
                Image("splash_logo")
                    .resizable()
                    .frame(width: 200, height: 200)
                Text("Loading...")
                    .foregroundColor(Color(red: 65/255, green: 65/255, blue: 65/255))
                    .font(.title)
                    .bold()
            }
        }
    }
}


struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
