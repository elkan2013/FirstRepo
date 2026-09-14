//
//  ContentView.swift
//  FirstRepo
//
//  Created by Elkan Jee on 31/8/26.
//
import SwiftUI

struct Line: Identifiable {
    
    let id = UUID()
    
    var text: String
    var intensity: Int
    
    var intensityLabel: String {
        if intensity >= 8 {
            return "Brutal"
        } else if intensity >= 5 {
            return "Medium"
        } else {
            return "Mild"
        }
    }
}

struct Tally {
    
    var compliments = 0
    var insults = 0
    
    mutating func recordCompliment() {
        compliments += 1
    }
    
    mutating func recordInsult() {
        insults += 1
    }
}

struct ContentView: View {
    
    @State private var tally = Tally()
    @State private var isInsultMode = false
    @State private var lastLine: Line? = nil
    @State private var history: [String] = []
    
    let compliments: [Line] = [
        Line(text: "you open jars other people struggle with. legend", intensity: 3),
        Line(text: "you are good in everything", intensity: 5),
        Line(text: "ur the goat", intensity: 7),
        Line(text: "you are the most trustworthy guy", intensity: 6),
        Line(text: "honestly you're doing pretty well.", intensity: 4),
        Line(text: "you have good vibes. idk why.", intensity: 5),
        Line(text: "you'd probably survive a zombie apocalypse.", intensity: 7),
        Line(text: "you seem like you know what you're doing.", intensity: 4),
        Line(text: "your music taste is probably decent.", intensity: 5),
        Line(text: "you are surprisingly competent.", intensity: 6)
    ]
    
    let insults: [Line] = [
        Line(text: "when u walk u make earthquakes.", intensity: 8),
        Line(text: "if i gave you a penny for your thoughts, i'd get change back.", intensity: 6),
        Line(text: "i envy the people who have never met you.", intensity: 9),
        Line(text: "i've seen houseplants with a better sense of direction.", intensity: 4),
        Line(text: "you could lose an argument with a wall.", intensity: 5),
        Line(text: "your brain has left the group chat.", intensity: 7),
        Line(text: "you bring a very unique energy to the room.", intensity: 3),
        Line(text: "IF ART SCHOOL SAYS NEIN, EUROPE IS MEIN", intensity: 4),
        Line(text: "i would explain it but i don't have all day.", intensity: 6),
        Line(text: "you have the confidence of someone who definitely did not read the instructions.", intensity: 7),
        Line(text: "respectfully, what are you doing.", intensity: 5),
        Line(text: "your last thought was buffering.", intensity: 6),
        Line(text: "I didnt use ai to generate these btw trust", intensity: 7),
        Line(text: "somehow you made that more complicated.", intensity: 5),
        Line(text: "i'm not saying you're wrong. i'm just saying... yeah you're wrong.", intensity: 6)
    ]
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                Circle()
                    .fill(isInsultMode ? Color.red : Color.green)
                    .frame(width: 90, height: 90)
                    .overlay(
                        Text(isInsultMode ? ">:C gurr" : ":)")
                            .font(.system(size: 20))
                    )
                    .padding(.top, 12)
                
                Text("compliment / insult machine")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 8)
                
                Toggle("insult mode", isOn: $isInsultMode)
                    .padding()
                
                if let line = lastLine {
                    
                    Rectangle()
                        .fill(isInsultMode ? Color.red : Color.green)
                        .frame(
                            width: CGFloat(line.intensity) * 20,
                            height: 12
                        )
                        .cornerRadius(6)
                }
                
                Button {
                    generateLine()
                } label: {
                    
                    Text(isInsultMode ? "roast me" : "glaze me")
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            isInsultMode ? Color.red : Color.green
                        )
                        .foregroundStyle(.white)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 10)
                        )
                }
                .padding(.horizontal)
                
                Text(lastLine?.text ?? "click the button above")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()
                
                if let line = lastLine {
                    Text(line.intensityLabel)
                        .font(.footnote)
                        .foregroundStyle(.purple)
                }
                
                Spacer()
                
                List {
                    Section("previous") {
                        
                        if history.isEmpty {
                            Text("nothing yet")
                        } else {
                            ForEach(history, id: \.self) { entry in
                                Text(entry)
                            }
                        }
                    }
                }
                .frame(height: 200)
                
                NavigationLink {
                    
                    DetailView(
                        compliments: $tally.compliments,
                        insults: $tally.insults,
                        isInsultMode: $isInsultMode
                    )
                    
                } label: {
                    
                    HStack {
                        Text("view stats")
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationTitle("home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("reset") {
                        resetEverything()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("info") {
                        print("this button does absolutely nothing useful.")
                    }
                }
            }
        }
    }
    
    // MARK: - FUNCTIONS
    
    func pickRandomLine(from lines: [Line]) -> Line {
        
        let index = Int.random(in: 0..<lines.count)
        
        return lines[index]
    }
    
    func calculateMoodScore(intensity: Int, bonus: Int) -> Int {
        
        let raw = (intensity * 7) + bonus - 2
        
        let score = raw % 101
        
        return score
    }
    
    func generateLine() {
        
        let source = isInsultMode ? insults : compliments
        
        let line = pickRandomLine(from: source)
        
        lastLine = line
        
        if isInsultMode {
            tally.recordInsult()
        } else {
            tally.recordCompliment()
        }
        
        let score = calculateMoodScore(
            intensity: line.intensity,
            bonus: tally.compliments + tally.insults
        )
        
        if line.intensity >= 8 && isInsultMode {
            print("WARNING: that one was kinda harsh.")
        } else if line.intensity < 4 || !isInsultMode {
            print("low key line delivered.")
        } else {
            print("standard line delivered.")
        }
        
        let type = isInsultMode ? "insult" : "compliment"
        
        let number = tally.compliments + tally.insults
        
        let entry = "\(type) #\(number): \(line.text) — score \(score)"
        
        history.append(entry)
    }
    
    func resetEverything() {
        
        tally.compliments = 0
        tally.insults = 0
        
        lastLine = nil
        history.removeAll()
        
        print("everything reset. we are back to square one.")
    }
}

// MARK: - DETAIL VIEW

struct DetailView: View {
    
    @Binding var compliments: Int
    @Binding var insults: Int
    @Binding var isInsultMode: Bool
    
    var total: Int {
        compliments + insults
    }
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            Text("stats")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("compliments: \(compliments)")
            
            Text("insults: \(insults)")
            
            Text("total: \(total)")
            
            if total == 0 {
                Text("you haven't done anything yet")
            } else if compliments > insults {
                Text("you've been nice")
            } else if insults > compliments {
                Text("you've been kinda mean")
            } else {
                Text("perfectly balanced")
            }
            
            Spacer()
            
            Button("switch mode") {
                isInsultMode.toggle()
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .padding()
        .navigationTitle("stats")
    }
}

#Preview {
    ContentView()
}
