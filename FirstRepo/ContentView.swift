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
        switch intensity {
        case 8...:
            return "way too much"
        case 5..<8:
            return "a bit much"
        default:
            return "barely there"
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
    @State private var sillyStatus: String = "nothing is happening, which is honestly fine"
    @State private var tapCount = 0
    @State private var fakeWisdom = "the button has not spoken yet"
    
    let compliments: [Line] = [
        Line(text: "you seem nice in a way that doesn't try too hard.", intensity: 3),
        Line(text: "you probably hold the door for people and then pretend it was accidental.", intensity: 4),
        Line(text: "you give off the energy of someone who knows where their keys are.", intensity: 5),
        Line(text: "you are, against all odds, kind of a reassuring person.", intensity: 6),
        Line(text: "you look like you would remember birthdays without making it weird.", intensity: 7),
        Line(text: "you feel like the kind of person who says 'no worries' and means it.", intensity: 4),
        Line(text: "you are probably better at things than you admit.", intensity: 5),
        Line(text: "your vibe is weirdly comforting.", intensity: 6),
        Line(text: "you seem like you could survive a group project with minimal damage.", intensity: 7),
        Line(text: "you are doing just fine, and honestly that's kind of impressive.", intensity: 8)
    ]
    
    let insults: [Line] = [
        Line(text: "you have the energy of a chair with bad news.", intensity: 4),
        Line(text: "respectfully, your decisions are a little suspicious.", intensity: 5),
        Line(text: "you seem like the type to say 'one sec' and ghost forever.", intensity: 6),
        Line(text: "you probably open ten tabs and call it organization.", intensity: 7),
        Line(text: "you move like you are always mildly lost.", intensity: 4),
        Line(text: "your thought process feels like it needs subtitles.", intensity: 5),
        Line(text: "you look like you would click the wrong button and blame the screen.", intensity: 6),
        Line(text: "you could probably start a fire by trying to make toast.", intensity: 7),
        Line(text: "you have the confidence of someone who absolutely should not.", intensity: 8),
        Line(text: "you are one of those people who makes simple tasks feel ceremonial.", intensity: 9)
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                Circle()
                    .fill(isInsultMode ? Color.red.opacity(0.85) : Color.green.opacity(0.85))
                    .frame(width: 96, height: 96)
                    .overlay(
                        Text(isInsultMode ? ":/" : ":)")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.white)
                    )
                    .padding(.top, 12)
                
                Text("the button that does not matter")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text(sillyStatus)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Toggle(
                    isInsultMode ? "mean mode" : "nice mode",
                    isOn: $isInsultMode
                )
                .padding(.horizontal)
                
                if let line = lastLine {
                    VStack(alignment: .leading, spacing: 8) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(isInsultMode ? Color.red : Color.green)
                            .frame(width: CGFloat(line.intensity) * 18, height: 12)
                        
                        Text(line.intensityLabel)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)
                }
                
                Button {
                    generateLine()
                } label: {
                    Text(isInsultMode ? "be rude for no reason" : "say something nice for no reason")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isInsultMode ? Color.red : Color.green)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)
                
                Text(lastLine?.text ?? "press the button. it won't help, but it will do something.")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer(minLength: 8)
                
                List {
                    Section("things that happened") {
                        if history.isEmpty {
                            Text("nothing yet. the app is still thinking about it.")
                        } else {
                            ForEach(history, id: \.self) { entry in
                                Text(entry)
                            }
                        }
                    }
                }
                .frame(height: 220)
                
                NavigationLink {
                    DetailView(
                        compliments: $tally.compliments,
                        insults: $tally.insults,
                        isInsultMode: $isInsultMode
                    )
                } label: {
                    HStack {
                        Text("look at stats nobody asked for")
                        Spacer()
                    }
                    .padding()
                }
                .padding(.horizontal)
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
                    Button("huh") {
                        sillyStatus = "that button was decorative. classic."
                    }
                }
            }
        }
    }
    
    func pickRandomLine(from lines: [Line]) -> Line {
        lines.randomElement() ?? Line(text: "the void was unavailable.", intensity: 1)
    }
    
    func calculateMoodScore(intensity: Int, bonus: Int) -> Int {
        let raw = (intensity * 7) + bonus - 2
        return raw % 101
    }
    
    func generateLine() {
        tapCount += 1
        
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
        
        if isInsultMode {
            switch line.intensity {
            case 8...:
                sillyStatus = "that was kinda wild. maybe chill a little."
            case 5..<8:
                sillyStatus = "rude, but in a conversational way."
            default:
                sillyStatus = "barely a roast. emotionally undercooked."
            }
        } else {
            switch line.intensity {
            case 8...:
                sillyStatus = "okay wait that was actually sweet."
            case 5..<8:
                sillyStatus = "solid compliment. emotionally edible."
            default:
                sillyStatus = "tiny compliment. little guy."
            }
        }
        
        fakeWisdom = tapCount.isMultiple(of: 3)
        ? "the third tap has special powers. scientifically untrue, but still."
        : "the button remains committed to being unhelpful."
        
        let type = isInsultMode ? "roast" : "compliment"
        let number = tally.compliments + tally.insults
        let entry = "\(type) #\(number): \(line.text) — score \(score)"
        
        history.insert(entry, at: 0)
    }
    
    func resetEverything() {
        tally.compliments = 0
        tally.insults = 0
        lastLine = nil
        history.removeAll()
        tapCount = 0
        sillyStatus = "reset complete. nothing learned."
        fakeWisdom = "the button has not spoken yet"
    }
}


#Preview {
    ContentView()
}
