import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var ctx
    @Query var events: [Event]
    @Query var eventTasks: [EventTask]
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }
    
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    var body: some View {
        NavigationStack {
            if events.isEmpty {
                ZStack {
                    Text("Add new event '+'")
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("iTravelary")
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        NavigationLink(destination: CalendarView()) {
                            Image(systemName: "square").imageScale(.large)
                        }
                        NavigationLink(destination: AddEventView()) {
                            Image(systemName: "plus").imageScale(.large)
                        }
                    }
                }
            }else {
                List {
                    Section {
                        Text("SwiftData").fontWeight(.semibold).foregroundStyle(.gray)
                    }.listSectionSpacing(.custom(0)).listRowBackground(Color.clear)
                    
                    Section {
                        ForEach(events) { data in
                            NavigationLink(destination: DetailView(events: data)) {
                                HStack(spacing: 25) {
                                    Image(systemName: data.symbolImage).foregroundColor(Color(data.symbolImageColor)).imageScale(.large)
                                    VStack(alignment: .leading){
                                        Text(data.name).fontWeight(.semibold)
                                        Text("\(dateFormatter.string(from: data.date)) \(timeFormatter.string(from: data.time))").font(.footnote).foregroundStyle(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(data.tasks.count.description).foregroundStyle(.gray)
                                }
                            }
                            .swipeActions {
                                Button {
                                    ctx.delete(data)
                                    try? ctx.save()
                                } label: {
                                    Image(systemName: "trash.fill")
                                }.tint(.red)
                                
                                NavigationLink(destination: EditEventView(events: data)) {
                                    Image(systemName: "pencil").tint(.orange)
                                }
                            }
                        }
                    }
                    
                    Section {
                        Text("Next 7 Days").fontWeight(.semibold).foregroundStyle(.gray)
                    }.listSectionSpacing(.custom(0)).listRowBackground(Color.clear)
                    
                    Section {
                        ForEach(filteredEvents(for: .upcoming)) { data in
                            NavigationLink(destination: DetailView(events: data)) {
                                HStack(spacing: 25) {
                                    Image(systemName: data.symbolImage).foregroundColor(Color(data.symbolImageColor)).imageScale(.large)
                                    VStack(alignment: .leading){
                                        Text(data.name).fontWeight(.semibold)
                                        Text("\(dateFormatter.string(from: data.date)) \(timeFormatter.string(from: data.time))").font(.footnote).foregroundStyle(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(data.tasks.count.description).foregroundStyle(.gray)
                                }
                            }
                            .swipeActions {
                                Button {
                                    ctx.delete(data)
                                    try? ctx.save()
                                } label: {
                                    Image(systemName: "trash.fill")
                                }.tint(.red)
                                
                                NavigationLink(destination: EditEventView(events: data)) {
                                    Image(systemName: "pencil").tint(.orange)
                                }
                            }
                        }
                    }
                    
                    Section {
                        Text("Next 30 Days").fontWeight(.semibold).foregroundStyle(.gray)
                    }.listSectionSpacing(.custom(0)).listRowBackground(Color.clear).padding(.top)
                    
                    Section {
                        ForEach(filteredEvents(for: .within30Days)) { data in
                            NavigationLink(destination: DetailView(events: data)) {
                                HStack(spacing: 25) {
                                    Image(systemName: data.symbolImage).foregroundColor(Color(data.symbolImageColor)).imageScale(.large)
                                    VStack(alignment: .leading){
                                        Text(data.name).fontWeight(.semibold)
                                        Text("\(dateFormatter.string(from: data.date)) \(timeFormatter.string(from: data.time))").font(.footnote).foregroundStyle(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(data.tasks.count.description).foregroundStyle(.gray)
                                }
                            }
                            .swipeActions {
                                Button {
                                    ctx.delete(data)
                                    try? ctx.save()
                                } label: {
                                    Image(systemName: "trash.fill")
                                }.tint(.red)
                                
                                NavigationLink(destination: EditEventView(events: data)) {
                                    Image(systemName: "pencil").tint(.orange)
                                }
                            }
                        }
                    }
                    
                    Section {
                        Text("Past").fontWeight(.semibold).foregroundStyle(.gray)
                    }.listSectionSpacing(.custom(0)).listRowBackground(Color.clear).padding(.top)
                    
                    Section {
                        ForEach(filteredEvents(for: .past)) { data in
                            NavigationLink(destination: DetailView(events: data)) {
                                HStack(spacing: 25) {
                                    Image(systemName: data.symbolImage).foregroundColor(Color(data.symbolImageColor)).imageScale(.large)
                                    VStack(alignment: .leading){
                                        Text(data.name).fontWeight(.semibold)
                                        Text("\(dateFormatter.string(from: data.date)) \(timeFormatter.string(from: data.time))").font(.footnote).foregroundStyle(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(data.tasks.count.description).foregroundStyle(.gray)
                                }
                            }
                            .swipeActions {
                                Button {
                                    ctx.delete(data)
                                    try? ctx.save()
                                } label: {
                                    Image(systemName: "trash.fill")
                                }.tint(.red)
                                
                                NavigationLink(destination: EditEventView(events: data)) {
                                    Image(systemName: "pencil").tint(.orange)
                                }
                            }
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("iTravelary")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(destination: AddEventView()) {
                            Image(systemName: "plus").imageScale(.large)
                        }
                    }
                }
            }
        }
    }
    
    enum FilterType {
            case upcoming, within30Days, past
        }
    
    func filteredEvents(for filter: FilterType) -> [Event] {
            let now = Date()
            switch filter {
            case .upcoming:
                return events.filter { $0.date > now && Calendar.current.dateComponents([.day], from: now, to: $0.date).day ?? 0 <= 6 }
            case .within30Days:
                return events.filter { $0.date > now.addingTimeInterval(60*60*24*7) && Calendar.current.dateComponents([.day], from: now, to: $0.date).day ?? 0 <= 30 }
            case .past:
                return events.filter { $0.date < now }
            }
        }
}

#Preview {
    ContentView()
}

struct AddEventView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var ctx
    @Query var events: [Event]
    @State private var name = ""
    @State private var symbolImage = ""
    @State var date = Date()
    @State var time = Date()
    
    @FocusState private var names: Bool
    
    @State var taskText: String = ""
    @FocusState private var isFocused: Bool
    @State var isCompleted: Bool = false
    
    @AppStorage("selectedColors") var selectedColors = 0
    @AppStorage("selectedImage") var selectedImage = "house.fill"
    
    @State var isColored = false
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading){
                    HStack(spacing: 15){
                        TextField("Title", text: $name)
                            .focused($names)
                    }
                    HStack {
                        DatePicker(selection: $date, displayedComponents: .date , label: { Text("") }).labelsHidden()
                        DatePicker(selection: $time, displayedComponents: .hourAndMinute , label: { Text("") }).labelsHidden()
                    }
                }
                
                Text("Events").fontWeight(.bold)
                
                Section {
                    HStack {
                        Button {
                            isCompleted.toggle()
                        } label: {
                            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(isCompleted ? .green : .gray)
                        }
                        .buttonStyle(.plain)

                        TextField("Event description", text: $taskText)
                            .focused($isFocused)

                        Spacer()
                    }
                    .padding(.vertical, 10)
                }
                Button {
                    
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Event")
                    }
                }.buttonStyle(.borderless)
            }
            Button {
                
            } label: {
                HStack {
                    Text("Generate AI Event")
                }
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add") {
                    Task {
                        let newEventTask = EventTask(text: taskText, isCompleted: false, isNew: false)
                        let newData = Event(name: name, symbolImage: symbolImage, symbolImageColor: eventColors[selectedColors], date: date, time: time, tasks: [newEventTask])
                        ctx.insert(newData)
                        try? ctx.save()
                        
                        presentationMode.wrappedValue.dismiss()
                        
                    }
                }
            }
        }
        /*.sheet(isPresented: $isColored) {
            SFSymbolView()
        }*/
        .onAppear {
            symbolImage = selectedImage
            names.toggle()
        }
        .onDisappear {
            symbolImage = selectedImage
        }
    }
}

struct EditEventView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var ctx
    @Bindable var events: Event
    @AppStorage("selectedColors") var selectedColors = 0
    @AppStorage("selectedImage") var selectedImage = "house.fill"
    
    @State var isColored = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading){
                    HStack(spacing: 15){
                        TextField("", text: $events.name)
                    }
                    HStack {
                        DatePicker(selection: $events.date, displayedComponents: .date , label: { Text("") }).labelsHidden()
                        DatePicker(selection: $events.time, displayedComponents: .hourAndMinute , label: { Text("") }).labelsHidden()
                    }
                }
                
                Text("Events").fontWeight(.bold)
                
                Section {
                    ForEach(events.tasks) { items in
                        HStack {
                            Button {
                                items.isCompleted.toggle()
                            } label: {
                                Image(systemName: items.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(items.isCompleted ? .green : .gray)
                            }
                            .buttonStyle(.plain)

                            TextField("", text: Binding(get: { items.text },
                                                        set: { newValue in
                                items.text = newValue
                            }))
                                .focused($isFocused)

                            Spacer()
                        }
                        .swipeActions {
                            Button {
                                deleteTask(task: items, from: $events.wrappedValue)
                            } label: {
                                Image(systemName: "trash.fill")
                            }.tint(.red)
                        }
                    }
                    .padding(.vertical, 10)
                }
                Button {
                    events.tasks.append(EventTask(text: "", isCompleted: false, isNew: false))
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Task")
                    }
                }.buttonStyle(.borderless)
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    Task {
                        try? ctx.save()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        /*.sheet(isPresented: $isColored) {
            SFSymbolView()
        }*/
        .onAppear {
            selectedImage = events.symbolImage
            eventColors[selectedColors] = events.symbolImageColor
        }
        .onChange(of: selectedImage) {
            events.symbolImage = selectedImage
            events.symbolImageColor = eventColors[selectedColors]
        }

    }
    
    func deleteTask(task: EventTask, from event: Event) {
            if let index = event.tasks.firstIndex(of: task) {
                event.tasks.remove(at: index)
                // Save the updated event
                try? ctx.save()
            }
        }
    
}

struct DetailView: View {
    var events: Event
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    var body: some View {
        List {
            Section {
                HStack {
                    Image(systemName: events.symbolImage).foregroundColor(Color(events.symbolImageColor))
                    Text(events.name).foregroundStyle(.black)
                }
                Text("\(dateFormatter.string(from: events.date)) \(timeFormatter.string(from: events.time))")
                
                Text("Tasks").foregroundStyle(.black).fontWeight(.semibold)
                
                ForEach(events.tasks) { task in
                    Text(task.text).foregroundStyle(.black)
                }
            }
            .navigationTitle("Detail")
        }
    }
}
