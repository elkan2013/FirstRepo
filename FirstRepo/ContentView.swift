//
//  ContentView.swift
//  FirstRepo
//
//  Created by Elkan Jee on 31/8/26.
//
import SwiftUI

struct Line: Identifiable {
    let id = UUID()
    let text: String
    let intensity: Int

    var intensityLabel: String {
        if intensity >= 8 {
            return "strong"
        } else if intensity >= 5 {
            return "medium"
        } else {
            return "small"
        }
    }
}

struct Tally {
    var compliments = 0
    var insults = 0
}

struct ContentView: View {
    @State private var tally = Tally()
    @State private var insultMode = false
    @State private var currentLine: Line?
    @State private var history: [String] = []
    @State private var message = "tap the button"

    let compliments = [
        Line(text: "you remember people's coffee orders and that's a real skill", intensity: 5),
        Line(text: "you text back like an actual functioning adult", intensity: 3),
        Line(text: "you'd probably notice if a friend was having a bad day", intensity: 6),
        Line(text: "you're the one who actually reads the group chat", intensity: 4),
        Line(text: "you give surprisingly good advice for someone who never takes their own", intensity: 7),
        Line(text: "you make people feel normal about being weird", intensity: 8)
    ]

    let insults = [
        Line(text: "you left the group project chat on read for two days", intensity: 5),
        Line(text: "you have 6 unread badge counts you're never clearing", intensity: 3),
        Line(text: "you say 'one sec' and disappear for the rest of the night", intensity: 6),
        Line(text: "you still haven't watched the thing everyone talked about last year", intensity: 4),
        Line(text: "you argue with the GPS like it can hear you", intensity: 7),
        Line(text: "you've rewritten the same text message four times and still sent it wrong", intensity: 8)
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                Circle()
                    .fill(insultMode ? .red : .green)
                    .frame(width: 96, height: 96)
                    .overlay {
                        Text(insultMode ? ":/" : ":)")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.white)
                    }

                Text("Compliment or Insult")
                    .font(.title2)
                    .bold()

                Text(message)
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Toggle(
                    insultMode ? "Mean Mode" : "Nice Mode",
                    isOn: $insultMode
                )
                .padding(.horizontal)

                if let line = currentLine {
                    VStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(insultMode ? .red : .green)
                            .frame(width: CGFloat(line.intensity) * 18, height: 12)

                        Text(line.intensityLabel)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Button {
                    makeLine()
                } label: {
                    Text(insultMode ? "Roast Me" : "Hype Me Up")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(insultMode ? .red : .green)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)

                Text(currentLine?.text ?? "tap the button")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Spacer()

                List {
                    Section("History") {
                        if history.isEmpty {
                            Text("nothing yet")
                        } else {
                            ForEach(history, id: \.self) { item in
                                Text(item)
                            }
                        }
                    }
                }
                .frame(height: 220)

                NavigationLink {
                    DetailView(
                        compliments: $tally.compliments,
                        insults: $tally.insults,
                        isInsultMode: $insultMode
                    )
                } label: {
                    Text("View Stats")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Reset") {
                        reset()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("?") {
                        message = "that button does nothing, sorry"
                    }
                }
            }
        }
    }

    func makeLine() {
        let list = insultMode ? insults : compliments

        guard let line = list.randomElement() else {
            return
        }

        currentLine = line

        if insultMode {
            tally.insults += 1
            message = "sent"
        } else {
            tally.compliments += 1
            message = "sent"
        }

        let total = tally.compliments + tally.insults
        let score = (line.intensity * 7 + total - 2) % 101

        let type = insultMode ? "insult" : "compliment"
        let item = "\(type) #\(total): \(line.text) - score \(score)"

        history.insert(item, at: 0)
    }

    func reset() {
        tally = Tally()
        currentLine = nil
        history.removeAll()
        message = "tap the button"
    }
}


#Preview {
    ContentView()
}
