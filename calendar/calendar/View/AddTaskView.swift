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
    @State private var currentLocation: Bool = true
    @State private var showingAlertCheckWeather: Bool = false
    @State private var alertCheckWeatherContent: String = ""
    @State private var showingAlertCreateTask: Bool = false
    @State private var alertCreateTaskContent: String = ""

    @StateObject var weatherManager = WeatherManager()
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Task Name", text: $taskName)
                DatePicker("Date", selection: $taskDate, displayedComponents: .date)
                DatePicker("Start Time", selection: $taskBeginTime, displayedComponents: .hourAndMinute)
                DatePicker("End Time", selection: $taskEndTime, displayedComponents: .hourAndMinute)
                Toggle("Set Alert", isOn: $taskAlert)
                if taskAlert {
                    DatePicker("Alert Time", selection: $alertTime, displayedComponents: .hourAndMinute)
                }
                
                TextField("Description", text: $taskDescription)
                Toggle("Current Location", isOn: $currentLocation)
                HStack {
                    Text("Country")
                    Spacer()
                    TextField("Country", text: $weatherManager.country)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("City")
                    Spacer()
                    TextField("City", text: $weatherManager.city)
                        .multilineTextAlignment(.trailing)
                }
                Button(action: {
                    
                    // Call the fetchWeather function with a completion handler
                    weatherManager.fetchWeather(isCurrentLocation: currentLocation, country: weatherManager.country, cityName: weatherManager.city, date: taskDate, beginTime: taskBeginTime, endTime: taskEndTime) { success in
                        if success {
                            // The weather information is now available
                            print("success")
                        } else {
                            // Handle the case where the API call fails
                            // call the API again 1 more time
                            weatherManager.fetchWeather(isCurrentLocation: currentLocation, country: weatherManager.country, cityName: weatherManager.city, date: taskDate, beginTime: taskBeginTime, endTime: taskEndTime) { success in
                                if success {
                                    // The weather information is now available
                                    // You can update any UI components here if needed
                                    print("success")
                                } else {
                                    // Handle the case where the API call fails
                                    weatherManager.weather = ""
                                    weatherManager.temp = ""
                                    showingAlertCheckWeather = true
                                    alertCheckWeatherContent = "Can't find the weather at the location"
                                    print("fail")
                                }
                            }
                        }
                    }
                }) {
                    Text("Check Weather")
                }
                .alert(isPresented: $showingAlertCheckWeather) {
                    Alert(title: Text("Message"), message: Text(alertCheckWeatherContent), dismissButton: .default(Text("OK")))
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
                    if (taskBeginTime > taskEndTime) {
                        showingAlertCreateTask = true
                        return
                    }
                    
                    contentViewModel.addActivity(name: taskName, date: taskDate, beginTime: taskBeginTime, endTime: taskEndTime, alert: taskAlert, alertTime: alertTime, description: taskDescription, weather: weatherManager.weather, temp: weatherManager.temp)
                    showAddTaskView = false // Close the view
                }
                .alert(isPresented: $showingAlertCreateTask) {
                    Alert(title: Text("Message"), message: Text("Start Time should be earlier than End Time"), dismissButton: .default(Text("OK")))
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
//    @State var showAddTaskView = true // This simulates the binding
//    AddTaskView(contentViewModel: ContentViewModel(), showAddTaskView: $showAddTaskView)
//}
