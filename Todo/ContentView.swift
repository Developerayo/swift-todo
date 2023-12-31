//
//  ContentView.swift
//  Todo
//
//  Created by Shodipo Ayomide on 27/09/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var tasks: [Task] = []
    @State private var newTask: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("New task...", text: $newTask, onCommit: addTask)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                
                List {
                    ForEach(tasks) { task in
                        HStack {
                            Text(task.name)
                                .strikethrough(task.isCompleted, color: .black)
                            Spacer()
                            if task.isCompleted {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        .swipeActions {
                            Button("Delete") {
                                if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                                    tasks.remove(at: index)
                                    saveTasks()
                                }
                            }
                            .tint(.red)
                            Button(task.isCompleted ? "Incomplete" : "Complete") {
                                toggleTaskCompletion(task)
                            }
                            .tint(task.isCompleted ? .orange : .green)
                        }
                    }
                }
            }
            .navigationTitle("To-Do List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .onAppear {
                loadTasks()
            }
        }
    }
    
    private func addTask() {
        let task = Task(name: newTask)
        tasks.append(task)
        saveTasks()
    }
    
    private func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
        saveTasks()
    }
    
    private func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            saveTasks()
        }
    }
    
    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "tasks")
        }
    }
    
    private func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: "tasks"),
           let decoded = try? JSONDecoder().decode([Task].self, from: data) {
            tasks = decoded
        }
    }
}

struct Task: Identifiable, Codable {
    let id = UUID()
    var name: String
    var isCompleted: Bool = false
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


#Preview {
    ContentView()
}
