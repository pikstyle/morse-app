//
//  ContentView.swift
//  morse-app
//
//  Created by Simon Mounier on 2026-01-10.
//

import SwiftUI

struct ContentView: View {
    
    @State private var textInput: String = ""
    
    var body: some View {
        
        ZStack {
            
            Color(red: 0.1, green: 0.1, blue: 0.1)
                .ignoresSafeArea()
            
            VStack {
                
                Spacer()
                
                Text("Text To Morse")
                    .font(.largeTitle)
                
                Spacer()
                
                TextEditor(text: $textInput)
                    .foregroundColor(.white)
                    .scrollContentBackground(.hidden)
                    .frame(height: 120)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(red: 0.1, green: 0.1, blue: 0.1))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white, lineWidth: 1)
                    )
                    .padding(.horizontal)
                
                Spacer()
                
                Button {
                    // action
                } label: {
                    HStack {
                        Image(systemName: "flashlight.on.fill")
                        Text("Convert")
                    }
                    .padding()
                }
                .buttonStyle(.bordered)
                .tint(Color.red)
                .font(.title)
                Spacer()
                
            }
            .padding()
            .foregroundColor(Color.white)
        }
    }
}

#Preview {
    ContentView()
}
