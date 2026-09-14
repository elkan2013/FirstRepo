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
        Line(text: "You open jars other people struggle with. Legend.", intensity: 3),
        Line(text: "Your gameplay? goated.", intensity: 5),
        Line(text: "You play football? goat.", intensity: 7),
        Line(text: "Dogs trust you, prolly cuz they know ur good.", intensity: 6),
        Line(text: "You are the human equivalent of a perfectly fit object.", intensity: 9)
    ]

    let insults: [Line] = [
        Line(text: "When u walk u make earthquakes.", intensity: 8),
        Line(text: "If I gave you a penny for your thoughts, I'd get change back.", intensity: 6),
        Line(text: "I envy the people who have never met you. ", intensity: 9),
        Line(text: "I’ve seen houseplants with a better sense of direction.", intensity: 4),
        Line(text: "Every room you walk into instantly becomes a disappointment to everyone already inside it.", intensity: 10)
    ]

    var body: some View {
        NavigationStack {
            VStack {

                Circle()
                    .fill(isInsultMode ? Color.red : Color.green)
                    .frame(width: 90, height: 90)
                    .overlay(
                        Text(isInsultMode ? "😈" : "😇")
                            .font(.system(size: 40))
                    )
                    .padding(.top, 12)

                Text("Compliment / Insult Machine")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 8)

                Toggle("Insult Mode", isOn: $isInsultMode)
                    .padding()

                if let line = lastLine {
                    Rectangle()
                        .fill(isInsultMode ? Color.red : Color.green)
                        .frame(width: CGFloat(line.intensity) * 20, height: 12)
                        .cornerRadius(6)
                }

                Button {
                    generateLine()
                } label: {
                    Text(isInsultMode ? "ROAST ME" : "HYPE ME UP")
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isInsultMode ? Color.red : Color.green)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal)

                Text(lastLine?.text ?? "Tap the button above.")
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
                    Section("History") {
                        ForEach(history, id: \.self) { entry in
                            Text(entry)
                        }
                    }
                }
                .frame(height: 200)

                NavigationLink {
                    DetailView(compliments: $tally.compliments, insults: $tally.insults, isInsultMode: $isInsultMode)
                } label: {
                    HStack {
                        Text("View Stats")
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationTitle("Home View")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        resetEverything()
                    } label: {
                        Text("Reset")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        print("This button does absolutely nothing useful.")
                    } label: {
                        Text("Info")
                    }
                }
            }
        }
    }

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

        let score = calculateMoodScore(intensity: line.intensity, bonus: tally.compliments + tally.insults)

        if line.intensity >= 8 && isInsultMode {
            print("WARNING: high intensity roast delivered.")
        } else if line.intensity < 4 || !isInsultMode {
            print("Low key line delivered.")
        } else {
            print("Standard line delivered.")
        }

        let entry = "\(isInsultMode ? "Insult" : "Compliment") #\(tally.compliments + tally.insults): \(line.text) — score \(score)"
        history.append(entry)
    }

    func resetEverything() {
        tally.compliments = 0
        tally.insults = 0
        lastLine = nil
        history.removeAll()
    }
}

#Preview {
    ContentView()
}

