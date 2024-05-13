//
//  ContentView.swift
//  calendar
//
//  Created by yuteng Lan on 2024/5/8.
//

import SwiftUI

struct ContentView: View {
    @StateObject var contentViewModel = ContentViewModel()
    @StateObject var schedules = Schedule()
    @State private var showAddTaskView = false


    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("\(contentViewModel.month) \(contentViewModel.year)")
                        .font(.title)
                    Spacer()
                    NavigationLink(
                        destination: CalendarView(date: contentViewModel.date, contentViewModel: contentViewModel),
                        label: {
                            Text("Calendar")
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)})
                                .padding()
                    
                    Button() {
                        showAddTaskView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $showAddTaskView) {
                        AddTaskView(contentViewModel: contentViewModel, showAddTaskView: $showAddTaskView)
                    }
                }
                HStack {
                    Button(){
                        contentViewModel.addDay(days: -7)
                    } label: {
                        Image(systemName: "arrowtriangle.left.fill")
                    }
                    
                    ForEach(0..<7) {index in
                        VStack {
                            Text(contentViewModel.dayDict1[index] ?? "")
                            ZStack {
                                Button() {
                                    contentViewModel.addDay(days: index - contentViewModel.dayIndex)
                                    contentViewModel.dayIndex = index
                                } label: {
                                    Text(String(contentViewModel.sevenDay[index]))
                                        .foregroundColor(.black)
                                }
                                Circle()
                                    .fill(Color.pink.opacity(contentViewModel.dayIndex == index ? 0.25 : 0))
                                    .frame(width: 30, height: 30)
                            }
                        }
                        Spacer()
                    }
                    Button(){
                        contentViewModel.addDay(days: 7)
                    } label: {
                        Image(systemName: "arrowtriangle.right.fill")
                    }
                }
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25.0)
                            .fill(.black)
                            .opacity(0.6)
                            .ignoresSafeArea()
                        ScrollView {
                            LazyVStack {
                                ForEach(contentViewModel.activities) { activity in
                                    if Calendar.current.isDate(activity.date, inSameDayAs: contentViewModel.date) {
                                        TaskView(activity: activity)
                                    }
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding()
            .onAppear {
                contentViewModel.renewCalendar(newDate: contentViewModel.date)
            }
        }
        .navigationBarHidden(true)
    }
}

struct TaskView: View {
    var activity: Activity

    var body: some View {
        VStack(alignment: .leading) {
            Text("Task: \(activity.name)")
            Text("Date: \(activity.date, formatter: dateFormatter)")
            Text("Starts: \(activity.beginTime, formatter: timeFormatter)")
            Text("Ends: \(activity.endTime, formatter: timeFormatter)")
            if activity.alert {
                Text("Alert set for: \(activity.alertTime, formatter: timeFormatter)")
            }
            Text("Description: \(activity.description)")
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
    }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
}()

let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter
}()

#Preview {
    ContentView()
}
