//
//  ContentView.swift
//  morse-app
//
//  Created by Simon Mounier on 2026-01-10.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @State private var textInput = ""
    @State private var morseCodeArray: [String] = []
    @State private var isFlashlightOn: Bool = false
    @State private var flashlightTask: Task<Void, Never>?
    @FocusState private var isFocus: Bool
    

    let flashlight = AVCaptureDevice.default(for: .video)
    let morseDictionary: [String:String] = [
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
        "z": "--..",
        " ": "/"
    ]
    
    let ditDuration: Double = 0.2
    let dahDuration: Double = 0.6
    let characterSpaceDuration: Double = 0.6
    let wordSpaceDuration: Double = 1.4
    private let darkGray = Color(red: 0.1, green: 0.1, blue: 0.1)
    private let lightGray = Color(red: 0.11, green: 0.11, blue: 0.11)


                
    var body: some View {
        ZStack {
            darkGray
                .ignoresSafeArea()
            
            VStack() {
                                
                Text("Text To Morse")
                    .font(.largeTitle)

                Spacer()
                                
                TextField("Text here :", text: $textInput)
                    .padding()
                    .background(lightGray.cornerRadius(20))
                    .focused($isFocus)
                    .onSubmit {
                        isFocus = false
                    }
                                
                Text("Text en Morse : \(morseCodeArray.joined(separator: " "))")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 20)
                Spacer()
                
                Button {
                    morseCodeArray = convertLettersToMorse(text: textInput)
                    flashlightTask = Task {
                        await flashlightMorse()
                    }
                } label: {
                    HStack {
                        Image(systemName: isFlashlightOn ? "flashlight.off.fill" : "flashlight.on.fill")
                           Text(isFlashlightOn ? "Flashing..." : "Convert")
                    }
                }
                .buttonStyle(.bordered)
                .tint(.green)
                .font(.title)
                .disabled(isFlashlightOn)
                                
                Button {
                    cancelFlashlightMorse()
                } label: {
                    HStack {
                        Image(systemName: "stop.circle.fill")
                        Text("Stop")
                    }
                }
                .buttonStyle(.bordered)
                .tint(.red)
                .font(.title)
                .disabled(!isFlashlightOn)
                                
            }
            .foregroundColor(.white)
            .padding(30)
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
    
    // Convert the text input of the user to an array of it's morse code
    
    func convertLettersToMorse(text: String) -> [String] {
        var morseArray = [String]()
        for letter in text.lowercased() {
            if let morseCode = morseDictionary[String(letter)] {
                morseArray.append(morseCode)
                morseArray.append("*")
            }
        }
        return morseArray
    }
    
    // Convert the morseCodeArry with the flashlight
    
    func flashlightMorse() async {
        
        isFlashlightOn = true
        
        for morseBloc in morseCodeArray {
            
            // Vérifie à chaque itération de bloc si on a stop
            
            if Task.isCancelled {
                toggleTorch(on: false)
                break
            }
            // Gérer les espaces entre les lettres et entre les mots
            
            if morseBloc == "*" {
                try? await Task.sleep(for: .seconds(characterSpaceDuration))
                
            } else if morseBloc == "/" {
                try? await Task.sleep(for: .seconds(wordSpaceDuration))
                
            } else {

                // Gérer les espaces dans le morse bloc
                
                for char in morseBloc {
                    
                    // Vérifie à chaque itération de char si on a stop
                    
                    if Task.isCancelled {
                        toggleTorch(on: false)
                        break
                    }
                    
                    if char == "." {
                        toggleTorch(on: true)
                        try? await Task.sleep(for: .seconds(ditDuration))
                        toggleTorch(on: false)
                        try? await Task.sleep(for: .seconds(0.2))
                        
                    } else if char == "-" {
                        toggleTorch(on: true)
                        try? await Task.sleep(for: .seconds(dahDuration))
                        toggleTorch(on: false)
                        try? await Task.sleep(for: .seconds(0.2))
                    }
                }
            }
        }
        isFlashlightOn = false
    }
    
    func cancelFlashlightMorse() {
        flashlightTask?.cancel()
        toggleTorch(on: false)
        isFlashlightOn = false
    }
}

#Preview {
    ContentView()
}
