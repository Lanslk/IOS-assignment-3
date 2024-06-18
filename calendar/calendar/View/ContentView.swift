//
//  ContentView.swift
//  calendar
//
//  Created by yuteng Lan on 2024/5/8.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    
    @StateObject var contentViewModel = ContentViewModel()
    @State private var showAddTaskView = false
    
    @Query(sort: \Activity.beginTime) var activities: [Activity]
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
                            Image(systemName: "calendar")})
                    
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
                            .fill(.gray)
                            .opacity(0.6)
                            .ignoresSafeArea()
                        ScrollView {
                            LazyVStack {
                                ForEach(activities) { activity in
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
                contentViewModel.context = context
            }
        }
        .navigationBarHidden(true)
    }
}

struct TaskView: View {
    @Environment(\.modelContext) private var context
    var activity: Activity

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Task: \(activity.name)")
                Text("Starts: \(activity.beginTime, formatter: timeFormatter)")
                Text("Ends: \(activity.endTime, formatter: timeFormatter)")
                if activity.alert {
                    Text("Alert set for: \(activity.alertTime, formatter: timeFormatter)")
                }
                Text("Description: \(activity.taskDescription)")
                if activity.weather != "" {
                    Text("Weather: \(activity.weather)")
                }
                if activity.temp != "" {
                    Text("Temperature: \(activity.temp) °C")
                }
            }
            Spacer()
            Button(){
                context.delete(activity)
            } label: {
                Text("Delete")
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            GeometryReader { geometry in
                backgroundImage(for: activity.weather, size: geometry.size)
            }
        )
        .cornerRadius(10)
    }

    private func backgroundImage(for weather: String, size: CGSize) -> some View {
        let weatherComponents = weather.lowercased().split(separator: " to ").map { String($0) }
        
        return ZStack {
            if weatherComponents.count == 2 {
                let firstWeatherImage = image(for: weatherComponents[0])
                let secondWeatherImage = image(for: weatherComponents[1])
                
                firstWeatherImage
                    .resizable()
                    .frame(width: size.width, height: size.height)
                    .clipShape(DiagonalSplitShape(isLeft: true))
                secondWeatherImage
                    .resizable()
                    .frame(width: size.width, height: size.height)
                    .clipShape(DiagonalSplitShape(isLeft: false))
            } else {
                let weatherImage = image(for: weather)
                weatherImage
                    .resizable()
                    .frame(width: size.width, height: size.height)
            }
        }
    }

    private func image(for weather: String) -> Image {
        switch weather {
            case "clear sky":
                return Image("clear_sky")
            case "few clouds":
                return Image("few_clouds")
            case "scattered clouds":
                return Image("scattered_clouds")
            case "broken clouds":
                return Image("broken_clouds")
            case "overcast clouds":
            return Image("overcast_clouds")
            case "shower rain":
                return Image("shower_rain")
            case "rain":
                return Image("rain")
            case "thunderstorm":
                return Image("thunderstorm")
            case "snow":
                return Image("snow")
            case "mist":
                return Image("mist")
            default:
                return Image("default_background")
        }
    }
}

struct DiagonalSplitShape: Shape {
    var isLeft: Bool

    func path(in rect: CGRect) -> Path {
        var path = Path()
        if isLeft {
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.maxX, y: 0))
            path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        } else {
            path.move(to: CGPoint(x: rect.maxX, y: 0))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        }
        path.closeSubpath()
        return path
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

struct PreviewData {
    static var container: ModelContainer = {
        do {
            // Replace ModelContainer() with actual initialization code and entities
            let container = try ModelContainer(for: Activity.self)
            return container
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }()
}

#Preview {
    ContentView()
        .environment(\.modelContext, PreviewData.container.mainContext)
}
