//
//  ChallengeView.swift
//  BetterRest
//
//  Created by Henrieke Baunack on 10/21/23.
//

import CoreML
import SwiftUI

struct ChallengeView: View {
    @State private var wakeUpTime = defaultWakeTime
    @State private var coffeCupsVal = 1
    @State private var hoursSleep = 8.0
    var actualCoffeeCups: Int {
        coffeCupsVal + 1
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    var body: some View {
        NavigationView{
            Form{
                Section("What time would you like to get up?")
                {
                    DatePicker("Please a wake up time", selection: $wakeUpTime,displayedComponents: .hourAndMinute).labelsHidden()
                }
                Section("How many hours of sleep do you think you need?")
                {
                    Stepper("\(hoursSleep.formatted()) hours of sleep", value: $hoursSleep, in: 4...12, step: 0.25)
                }
                Section("How many cups of coffee did you have?")
                {
                    Picker("^[\(actualCoffeeCups) cup](inflect : true)", selection: $coffeCupsVal){
                        ForEach(1..<20){
                            Text("\($0)")
                        }
                    }
                }
                Section("You're recommened bed time"){
                    Text("\(calculateBedTime())").font(.title)
                }
            }
            .navigationTitle("BetterRest")
        }
    }
    func calculateBedTime() -> String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            // getting the inputs ready
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUpTime)
            let minutes = ( components.minute ?? 0 ) * 60
            let hours = ( components.hour ?? 0 ) * 60 * 60
            
            let prediction = try model.prediction(wake: Int64(minutes + hours), estimatedSleep: hoursSleep, coffee: Int64(actualCoffeeCups))
            
            let sleepTime = wakeUpTime - prediction.actualSleep
            return sleepTime.formatted(date: .omitted, time: .shortened)
            
        }
        catch{
            return "Error"
        }
        
    }
}
#Preview {
    ChallengeView()
}
