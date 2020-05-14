//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Barry Martin on 5/14/20.
//  Copyright © 2020 Barry Martin. All rights reserved.
//
// Challenge from Hacking with Swift
// make a brain training game that challenges players to win or lose at rock, paper, scissors
// https://www.hackingwithswift.com/guide/ios-swiftui/2/3/challenge

import SwiftUI

struct ContentView: View {
    private var moves = ["Rock", "Paper", "Scissors"]
    
    @State private var appChoice = Int.random(in: 0..<3)
    
    // should the player try to win or lose
    @State private var shouldWin = Bool.random()
    
    @State private var score: Int = 0
    @State private var roundCount: Int = 0
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var alertDismissText = ""
    @State private var alertAction = {}
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.yellow, .red]), startPoint: .top, endPoint: .bottom)
            VStack {
                Text("Rock Paper Scissors")
                    .font(.largeTitle)
                    .foregroundColor(Color.blue)
                    .padding()
                
                Text("App chose \(moves[appChoice])")
                
                Text(shouldWin ? "and you need to win." : "and you need to lose.")
                
                Text("Pick your move!")
                    .padding()
                
                Spacer()
                
                HStack {
                    ForEach(0 ..< moves.count) { num in
                        Button(action: {
                            self.buttonTapped(num)
                        }) {
                            Text(self.moves[num])
                                .fontWeight(.semibold)
                                .padding(.horizontal, 25)
                                .padding(.vertical, 25)
                                .background(Color.blue)
                                .foregroundColor(.white)
                        }
                    }
                }
                
                Spacer()
                
                Text("Round # \(roundCount)")
                
                Text("Score: \(score)")
                    .fontWeight(.semibold)
                    .padding()
                
                
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle),
                  message: Text(alertMessage),
                  dismissButton: .default(Text(alertDismissText)) {
                    self.alertAction()
            })
        }
    }
    
    // MARK: - Methods
    func buttonTapped(_ button: Int) {
        
        // simplify logic
        // thing A beats thing B if it’s one place to the right of it,
        // taking into account wrapping around the end of the array.
        // So, paper (position 1) beats rock (position 0), scissors (position 2)
        // beats paper (position 1), and scissors (position 2) beats
        // paper (wrap around to position 0. You go the other way for losing.
        
        switch roundCount {
        case 0 ..< 10:
            var computedWinIndex: Int {
                if appChoice + 1 == 3 {
                    return 0
                } else {
                    return appChoice + 1
                }
            }
            
            var computedLoseIndex: Int {
                if appChoice - 1 == -1 {
                    return 2
                } else {
                    return appChoice - 1
                }
            }
            
            if button == computedWinIndex && shouldWin {
                score += 1
                alertTitle = "You are correct!"
            } else if button == computedLoseIndex && !shouldWin {
                score += 1
                alertTitle = "You are correct!"
            } else {
                score -= 1
                alertTitle = "Sorry, You are incorrect."
            }
            
            alertMessage = "Your score is \(score)"
            alertDismissText = "Continue"
            alertAction = resetRound
            showAlert = true
            
        case 10:
            alertTitle = "Game is over!"
            alertMessage = "Your final score is \(score)"
            alertDismissText = "Restart Game"
            alertAction = resetGame
            showAlert = true
            
        default:
            return
        }
    }
    
    func resetRound() {
        roundCount += 1
        appChoice = Int.random(in: 0..<3)
        shouldWin = Bool.random()
    }
    
    func resetGame() {
        roundCount = 0
        score = 0
        resetRound()
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
