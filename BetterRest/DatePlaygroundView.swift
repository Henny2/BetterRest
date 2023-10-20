//
//  ContentView.swift
//  BetterRest
//
//  Created by Henrieke Baunack on 10/19/23.
//

import SwiftUI

struct DatePlaygroundView: View {
    @State private var sleepAmount = 8.0
    @State private var selectedDate = Date.now
    var body: some View {
        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
        
        DatePicker("Please select a time", selection: $selectedDate, displayedComponents: .hourAndMinute)
        DatePicker("Please select a date and time", selection: $selectedDate, in: Date.now...) // one sided range
        Text(Date.now, format: .dateTime.hour().minute())
        Text(Date.now, format: .dateTime.day().month().year())
        Text(Date.now.formatted(date: .long, time: .shortened))

        
    }
}

#Preview {
    DatePlaygroundView()
}
