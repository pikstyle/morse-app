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
    let flashlight = AVCaptureDevice.default(for: .video)
    let morseDictionnary: [String:String] = [
        "a": ".-",
        "b": "-...",
        "c": "-.-.",
        "d": "-..",
        "e": ".",
        "f": "..-.",
        "g": "--.",
        "h": "....",
        "i": "..",
        "j": ".---",
        "k": "-.-",
        "l": ".-..",
        "m": "--",
        "n": "-.",
        "o": "---",
        "p": ".--.",
        "q": "--.-",
        "r": ".-.",
        "s": "...",
        "t": "-",
        "u": "..-",
        "v": "...-",
        "w": ".--",
        "x": "-..-",
        "y": "-.--",
        "z": "--.."
    ]
    @State private var morseCode = [String]()
        
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
                    .frame(height: 100)
                    .scrollContentBackground(.hidden)
                    .background(Color(red: 0.1, green: 0.1, blue: 0.1))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .padding()
                
                Spacer()
                
                Text("Text en morse : \(morseCode.joined(separator: " "))")
                
                Spacer()
                
                Button {
                    convert()
                    if flashlight?.torchMode == .on {
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
                .tint(.red)
                .font(.title)
                                                
                Spacer()
                
            }
            .padding()
            .foregroundColor(.white)
        }
    }
    
    // Flashlight Control
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                device.torchMode = on ? .on : .off
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        }
    }
    
    // Convert text to an array of letters
    
    func convertTextToLetters(text: String) -> [String] {
        var letterArray = [String]()
        for letter in text {
            letterArray.append(letter.lowercased())
        }
        return letterArray
    }
    
    // Convert the array of letters to an array of string, where each string represent the letter by it's morse representation
    
    func convertLettersToMorse(letters: [String]) -> [String] {
        var morseArray = [String]()
        for letter in letters {
            for (key, value) in morseDictionnary where key == letter {
                morseArray.append(value)
            }
        }
        return morseArray
    }
    
    // Return the final conversion
    
    func convert() {
        let letters = convertTextToLetters(text: textInput)
        morseCode = convertLettersToMorse(letters: letters)
        print(morseCode)
    }
}

#Preview {
    ContentView()
}
