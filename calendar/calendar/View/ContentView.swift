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
        VStack {
            HStack {
                Text("\(contentViewModel.month) \(contentViewModel.year)")
                    .font(.title)
                Spacer()
                Button("Calendar") {
                    
                }
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
                VStack {
                    Text("Mon")
                    ZStack {
                        Button() {
                            contentViewModel.addDay(days: 0 - contentViewModel.dayIndex)
                            contentViewModel.dayIndex = 0
                        } label: {
                            Text(String(contentViewModel.sevenDay[0]))
                                .foregroundColor(.black)
                        }
                        Circle()
                            .fill(Color.pink.opacity(contentViewModel.dayIndex == 0 ? 0.25 : 0))
                            .frame(width: 30, height: 30)
                    }
                }
                Spacer()
                VStack {
                    Text("Tue")
                    ZStack {
                        Button() {
                            contentViewModel.addDay(days: 1 - contentViewModel.dayIndex)
                            contentViewModel.dayIndex = 1
                        } label: {
                            Text(String(contentViewModel.sevenDay[1]))
                                .foregroundColor(.black)
                        }
                        Circle()
                            .fill(Color.pink.opacity(contentViewModel.dayIndex == 1 ? 0.25 : 0))
                            .frame(width: 30, height: 30)
                    }
                }
                Spacer()
                VStack {
                    Text("Wed")
                    ZStack {
                        Button() {
                            contentViewModel.addDay(days: 2 - contentViewModel.dayIndex)
                            contentViewModel.dayIndex = 2
                        } label: {
                            Text(String(contentViewModel.sevenDay[2]))
                                .foregroundColor(.black)
                        }
                        Circle()
                            .fill(Color.pink.opacity(contentViewModel.dayIndex == 2 ? 0.25 : 0))
                            .frame(width: 30, height: 30)
                    }
                }
                Spacer()
                VStack {
                    Text("Thu")
                    ZStack {
                        Button() {
                            contentViewModel.addDay(days: 3 - contentViewModel.dayIndex)
                            contentViewModel.dayIndex = 3
                        } label: {
                            Text(String(contentViewModel.sevenDay[3]))
                                .foregroundColor(.black)
                        }
                        Circle()
                            .fill(Color.pink.opacity(contentViewModel.dayIndex == 3 ? 0.25 : 0))
                            .frame(width: 30, height: 30)
                    }
                }
                Spacer()
                VStack {
                    Text("Fri")
                    ZStack {
                        Button() {
                            contentViewModel.addDay(days: 4 - contentViewModel.dayIndex)
                            contentViewModel.dayIndex = 4
                        } label: {
                            Text(String(contentViewModel.sevenDay[4]))
                                .foregroundColor(.black)
                        }
                        Circle()
                            .fill(Color.pink.opacity(contentViewModel.dayIndex == 4 ? 0.25 : 0))
                            .frame(width: 30, height: 30)
                    }
                }
                Spacer()
                VStack {
                    Text("Sat")
                    ZStack {
                        Button() {
                            contentViewModel.addDay(days: 5 - contentViewModel.dayIndex)
                            contentViewModel.dayIndex = 5
                        } label: {
                            Text(String(contentViewModel.sevenDay[5]))
                                .foregroundColor(.black)
                        }
                        Circle()
                            .fill(Color.pink.opacity(contentViewModel.dayIndex == 5 ? 0.25 : 0))
                            .frame(width: 30, height: 30)
                    }
                }
                Spacer()
                VStack {
                    Text("Sun")
                    ZStack {
                        Button() {
                            contentViewModel.addDay(days: 6 - contentViewModel.dayIndex)
                            contentViewModel.dayIndex = 6
                        } label: {
                            Text(String(contentViewModel.sevenDay[6]))
                                .foregroundColor(.black)
                        }
                        Circle()
                            .fill(Color.pink.opacity(contentViewModel.dayIndex == 6 ? 0.25 : 0))
                            .frame(width: 30, height: 30)
                    }
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
            contentViewModel.renewCalendar(newDate: Date.now)
        }
    }
}

#Preview {
    ContentView()
}
