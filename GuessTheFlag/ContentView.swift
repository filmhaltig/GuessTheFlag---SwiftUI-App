//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Tim Marquardt on 16.11.20.
//  Copyright © 2020 Tim Marquardt. All rights reserved.
//

import SwiftUI

// Create Custom Modifier for blue title
struct BlueTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
    }
}

extension View {
    func title2Blue() -> some View {
        self.modifier(BlueTitle())
    }
}

// View Composition
struct FlagImage: View {
    var image: String
    
    var body: some View {
        Image(image)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color .black, lineWidth: 1))
            .shadow(color: .black, radius: 2.5)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.red, .orange]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                VStack{
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    
                    Text(countries[correctAnswer])
                    //  .foregroundColor(.white)
                    //  .font(.largeTitle)
                        .fontWeight(.black)
                    //  .title2Blue()
                }
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                    // Image stlying code replaced by custom modifier, kept here for future reference
                    /* Image(self.countries[number])
                            .renderingMode(.original)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color .black, lineWidth: 1))
                            .shadow(color: .black, radius: 2.5) */
                        FlagImage(image: self.countries[number])
                    }
                }
                Section() {
                    Text("Current Score: \(userScore)") }
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(userScore)"),
                  dismissButton: .default(Text("Continue")) {
                        self.askQuestion()
                    })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 10
        } else {
            scoreTitle = "Wrong, this is the flag of \(countries[number])"
            if userScore > 0 {
                userScore -= 10
            }
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
