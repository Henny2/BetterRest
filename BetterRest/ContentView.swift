//
//  ContentView.swift
//  BetterRest
//
//  Created by Henrieke Baunack on 10/20/23.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUpTime = defaultWakeTime
    @State private var coffeCups = 1
    @State private var hoursSleep = 8.0
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    var body: some View {
        NavigationView{
            Form{
                VStack(alignment: .leading, spacing: 0)
                {
                    Text("What time would you like to get up?").font(.headline)
                    DatePicker("Please a wake up time", selection: $wakeUpTime,displayedComponents: .hourAndMinute).labelsHidden()
                }
                VStack(alignment: .leading, spacing: 0)
                {
                    Text("How many hours of sleep do you think you need?").font(.headline)
                    Stepper("\(hoursSleep.formatted()) hours of sleep", value: $hoursSleep, in: 4...12, step: 0.25)
                }
                VStack(alignment: .leading, spacing: 0)
                {
                    Text("How many cups of coffee did you have?").font(.headline)
                    Stepper("^[\(coffeCups) cup](inflect : true)", value: $coffeCups, in: 1...20, step: 1)
                }
            }.navigationTitle("BetterRest").toolbar{
                Button("Calculate", action: calculateBedTime)
            }
        }.alert(alertTitle, isPresented: $showAlert) {
            Button("Ok"){
            }
        }
        message: {
               Text(alertMessage)
            }
        
        
    }
    func calculateBedTime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            // getting the inputs ready
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUpTime)
            let minutes = ( components.minute ?? 0 ) * 60
            let hours = ( components.hour ?? 0 ) * 60 * 60
            
            let prediction = try model.prediction(wake: Int64(minutes + hours), estimatedSleep: hoursSleep, coffee: Int64(coffeCups))
            
            let sleepTime = wakeUpTime - prediction.actualSleep
            alertTitle = "Your ideal bedtime is..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
            print(sleepTime.formatted(date: .omitted, time: .shortened))
            
        }
        catch{
            alertTitle = "Error!"
            alertMessage = "Sorry, something went wrong!"
        }
        showAlert = true
        
    }
}

#Preview {
    ContentView()
}
