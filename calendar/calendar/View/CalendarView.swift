//
//  calendarView.swift
//  calendar
//
//  Created by Mathew Blackwood on 12/5/2024.
//

import SwiftUI

struct CalendarView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var color: Color = .green // Changed color to a valid SwiftUI color
    @State var date: Date
    @ObservedObject var contentViewModel: ContentViewModel
    let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    @State private var days: [Date] = []
    var body: some View {
        VStack {
            LabeledContent("Calendar Color") {
                ColorPicker("", selection: $color, supportsOpacity: false)
            }
            LabeledContent("Date/Time") {
                DatePicker("", selection: $date)
            }
            
            HStack {
                ForEach(daysOfWeek.indices, id: \.self) { index in
                    Text(daysOfWeek[index])
                        .fontWeight(.black)
                        .foregroundStyle(color)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding()
            
            LazyVGrid(columns: columns) {
                ForEach(days, id: \.self) { day in
                    if day.monthInt != date.monthInt {
                        Text("")
                    } else {
                        Text(day.formatted(.dateTime.day()))
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(
                                Circle()
                                    .foregroundColor(
                                        
                                        //Background for current day
                                        date.startOfDay == day.startOfDay
                                        ? Color.red.opacity(0.2):
                                            
                                        // Background modifies for each date
                                        color.opacity(0.2))
                            )
                        .onTapGesture {
                            contentViewModel.date = day.startOfDay
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
            .padding()
            .onAppear {
                days = date.calendarDisplayDays }
            
            // Refreshes and watches for day changes
            .onChange(of: date) {days = date.calendarDisplayDays}
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(date: Date(), contentViewModel: ContentViewModel())
    }
}
