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
                    
                    Button(){
                        
                    } label: {
                        Image(systemName: "plus")
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
                                ForEach(schedules.activities) { data in
                                    if (data.dateString == contentViewModel.dateString) {
                                        HStack {
                                            Text(data.beginTime)
                                            Text("-")
                                            Text(data.endTime)
                                            Spacer()
                                            VStack {
                                                Text(data.name)
                                                HStack {
                                                    Text("\(data.weather) \(data.temp) °C")
                                                }
                                            }
                                            Spacer()
                                            
                                        }
                                        .padding()
                                        .foregroundColor(.white)
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
                contentViewModel.renewCalendar(newDate:  contentViewModel.date)
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    ContentView()
}
