import SwiftUI

struct AddTaskView: View {
    @ObservedObject var contentViewModel: ContentViewModel
    @Binding var showAddTaskView: Bool  // Binding to control visibility

    @State private var taskName: String = ""
    @State private var taskDate: Date = Date()
    @State private var taskBeginTime: Date = Date()
    @State private var taskEndTime: Date = Date()
    @State private var taskAlert: Bool = false
    @State private var alertTime: Date = Date()
    @State private var taskDescription: String = ""

    @StateObject var weatherManager = WeatherManager()
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Task Name", text: $taskName)
                DatePicker("Date", selection: $taskDate, displayedComponents: .date)
                DatePicker("Begin Time", selection: $taskBeginTime, displayedComponents: .hourAndMinute)
                DatePicker("End Time", selection: $taskEndTime, displayedComponents: .hourAndMinute)
                Toggle("Set Alert", isOn: $taskAlert)
                if taskAlert {
                    DatePicker("Alert Time", selection: $alertTime, displayedComponents: .hourAndMinute)
                }
                TextField("Description", text: $taskDescription)

                Button(action: {
                    // Call the fetchWeather function with a completion handler
                    weatherManager.fetchWeather(cityName: "Sydney", date: taskDate, time: taskBeginTime) { success in
                        if success {
                            // The weather information is now available
                            print("success")
                        } else {
                            // Handle the case where the API call fails
                            // call the API again 1 more time
                            weatherManager.fetchWeather(cityName: "Sydney", date: taskDate, time: taskBeginTime) { success in
                                if success {
                                    // The weather information is now available
                                    // You can update any UI components here if needed
                                    print("success")
                                } else {
                                    // Handle the case where the API call fails
                                    print("fail")
                                }
                            }
                        }
                    }
                }) {
                    Text("Fetch Weather")
                }
                
                HStack {
                    Text("Weather")
                    Spacer()
                    Text(weatherManager.weather)
                }
                HStack {
                    Text("Temperature")
                    Spacer()
                    Text("\(weatherManager.temp) °C" )
                }
                Button("Create Task") {
                    contentViewModel.addActivity(name: taskName, date: taskDate, beginTime: taskBeginTime, endTime: taskEndTime, alert: taskAlert, alertTime: alertTime, description: taskDescription, weather: weatherManager.weather, temp: weatherManager.temp)
                    showAddTaskView = false // Close the view
                }
            }
            .navigationBarTitle("Add Task", displayMode: .inline)
        }
        .onAppear() {
            taskDate = contentViewModel.date
        }
    }
}

//#Preview {
//    AddTaskView(contentViewModel: ContentViewModel())
//}
