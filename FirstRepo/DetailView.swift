//
//  DetailView.swift
//  FirstRepo
//
//  Created by Goh Zhao En Bennett on 14/9/26.
//

import SwiftUI

struct DetailView: View {
    
    @Binding var compliments: Int
    @Binding var insults: Int
    @Binding var isInsultMode: Bool
    
    var total: Int {
        compliments + insults
    }
    
    var body: some View {
        
        VStack(spacing: 20) {
            Spacer()
            
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
        }
    }
}
#Preview {
    NavigationStack {
        DetailView(
            compliments: .constant(5),
            insults: .constant(2),
            isInsultMode: .constant(false)
        )
    }
}
