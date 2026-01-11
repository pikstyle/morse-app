//
//  ContentView.swift
//  morse-app
//
//  Created by Simon Mounier on 2026-01-10.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @State private var textInput: String = ""
    let device = AVCaptureDevice.default(for: .video)
    
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
                    if device?.torchMode == .on {
                        toggleTorch(on: false)
                    } else {
                        toggleTorch(on: true)
                    }
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
    
    // Fonction qui permet d'aller ou éteindre la lampe torche
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                if on {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        }
    }
}

#Preview {
    ContentView()
}
