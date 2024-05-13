import SwiftUI

struct AddTaskView: View {
    @ObservedObject var contentViewModel: ContentViewModel
    @Binding var showAddTaskView: Bool // Binding to control visibility

    @State private var taskName: String = ""
    @State private var taskDate: Date = Date()
    @State private var taskBeginTime: Date = Date()
    @State private var taskEndTime: Date = Date()
    @State private var taskAlert: Bool = false
    @State private var alertTime: Date = Date()
    @State private var taskDescription: String = ""

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
                Button("Create Task") {
                    contentViewModel.addActivity(name: taskName, date: taskDate, beginTime: taskBeginTime, endTime: taskEndTime, alert: taskAlert, alertTime: alertTime, description: taskDescription)
                    showAddTaskView = false // Close the view
                }
            }
            .navigationBarTitle("Add Task", displayMode: .inline)
        }
    }
}
