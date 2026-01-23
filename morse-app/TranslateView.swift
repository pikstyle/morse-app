//
//  ContentView.swift
//  morse-app
//
//  Created by Simon Mounier on 2026-01-10.
//

import SwiftUI
import AVFoundation

struct TranslateView: View {
    
    @State var textInput = ""
    @State private var morseCodeArray: [String] = []
    @State private var isFlashlightOn: Bool = false
    @State private var flashlightTask: Task<Void, Never>?
    @FocusState private var isFocus: Bool
    @State private var mulitlier: Double = 1
    @State private var showCreateSheet: Bool = false

    let flashlight = AVCaptureDevice.default(for: .video)
    let morseDictionary: [String:String] = [
        // Lettres
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
        
        // Chiffres
        "0": "-----",
        "1": ".----",
        "2": "..---",
        "3": "...--",
        "4": "....-",
        "5": ".....",
        "6": "-....",
        "7": "--...",
        "8": "---..",
        "9": "----.",
        
        // Poncutation
        ".": ".-.-.-",
        ",": "--..--",
        "?": "..--..",
        "!": "-.-.--",
        "'": ".----.",
        "\"": ".-..-.",
        ":": "---...",
        ";": "-.-.-.",
        "-": "-....-",
        "/": "-..-.",
        "(": "-.--.",
        ")": "-.--.-",
        
        // Caractères spéciaux
        "@": ".--.-.",
        "&": ".-...",
        "=": "-...-",
        "+": ".-.-.",
        
        // Accents
        "à": ".--.-",
        "è": ".-..-",
        "é": "..-..",
        "ç": "-.-..",
        "ô": "---.",
        "ù": "..--",
        
        // Espace
        " ": "/"
    ]
    
    let ditDuration: Double = 0.2
    let dahDuration: Double = 0.6
    let characterSpaceDuration: Double = 0.6
    let wordSpaceDuration: Double = 1.4
    private let darkGray = Color(red: 0.1, green: 0.1, blue: 0.1)
    private let lightGray = Color(red: 0.11, green: 0.11, blue: 0.11)


                
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                darkGray
                    .ignoresSafeArea()
                
                VStack {
                                                        
                    HStack {
                        TextField("Text here :", text: $textInput)
                            .padding()
                            .background(lightGray.cornerRadius(20))
                            .focused($isFocus)
                            .onSubmit {
                                isFocus = false
                            }
                        
                        Button {
                            showCreateSheet.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                        .buttonStyle(.bordered)
                        
                    }
                    
                    VStack {
                        Text("Text en morse : ")
                            .frame(maxWidth: .infinity, alignment: .leading)

                        ScrollView {
                            Text(morseCodeArray.joined())
                                .frame(maxWidth: .infinity, alignment: .leading)

                        }
                        .frame(height: 200)
                        
                        Button {
                            copyToClipboard()
                        } label: {
                            Text("Copy to clipboard")
                        }
                        .buttonStyle(.bordered)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    
                    Spacer()
                    
                    VStack() {
                        Text(String(format: "Vitesse : %.1f", mulitlier))
                        Slider(value: $mulitlier, in: 0.1...2 ,step: 0.1)
                            .disabled(isFlashlightOn)
                    }
                    .padding(.bottom, 30)
                    
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
                .sheet(isPresented: $showCreateSheet) {
                    SaveTextView { save in
                        print("Save text !")
                        dump(save)
                    }
                }
            }
            .navigationTitle("Translate")
            .toolbarColorScheme(.dark, for: .navigationBar)
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
                morseArray.append(" ")
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
            
            if morseBloc == " " {
                try? await Task.sleep(for: .seconds(characterSpaceDuration * mulitlier))
                
            } else if morseBloc == "/" {
                try? await Task.sleep(for: .seconds(wordSpaceDuration * mulitlier))
                
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
                        try? await Task.sleep(for: .seconds(ditDuration * mulitlier))
                        toggleTorch(on: false)
                        try? await Task.sleep(for: .seconds(ditDuration * mulitlier))
                        
                    } else if char == "-" {
                        toggleTorch(on: true)
                        try? await Task.sleep(for: .seconds(dahDuration * mulitlier))
                        toggleTorch(on: false)
                        try? await Task.sleep(for: .seconds(ditDuration * mulitlier))
                    }
                }
            }
        }
        isFlashlightOn = false
    }
    
    // Fonction pour arrêter l'exécution de la flashlight et de la traduction
    
    func cancelFlashlightMorse() {
        flashlightTask?.cancel()
        toggleTorch(on: false)
        isFlashlightOn = false
    }
    
    // Fonction pour copier
    
    func copyToClipboard() {
        UIPasteboard.general.string = morseCodeArray.joined()
    }
    
}

#Preview {
    TranslateView()
}
