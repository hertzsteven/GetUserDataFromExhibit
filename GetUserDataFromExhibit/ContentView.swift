//
//  ContentView.swift
//  GetUserDataFromExhibit
//
//  Created by Steven Hertz on 2/22/23.
//

import SwiftUI

struct ContentView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phoneNumber = ""
    @State private var schoolName = ""
    @FocusState private var usernameFieldIsFocused: Bool
    

    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
                TextField("First Name", text: $firstName)
                    .focused($usernameFieldIsFocused)
                TextField("Last Name", text: $lastName)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                               .textContentType(.emailAddress)
                TextField("Phone Number", text: $phoneNumber)
                    .keyboardType(.decimalPad)
                   
            }

            Section(header: Text("School Information")) {
                TextField("School Name", text: $schoolName)
            }
            
            Button(action: {
                let data = "\(firstName),\(lastName),\(email),\(phoneNumber),\(schoolName)\n".data(using: .utf8)

                if let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("data.csv") {
                    do {
                         let fileHandle: FileHandle
                         if FileManager.default.fileExists(atPath: fileURL.path) {
                             fileHandle = try FileHandle(forWritingTo: fileURL)
                         } else {
                             FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
                             fileHandle = try FileHandle(forWritingTo: fileURL)
                         }
                         defer {
                             fileHandle.closeFile()
                         }
                         fileHandle.seekToEndOfFile()
                         fileHandle.write(data!)
                        
                            // Reset the text field values
                            firstName = ""
                            lastName = ""
                            email = ""
                            phoneNumber = ""
                            schoolName = ""
                        
                        usernameFieldIsFocused = true

                     } catch {
                         print("Error writing to file: \(error)")
                     }                }
            }) {
                Text("Save")
            }
        }.font(.system(size: 16))
    }
}

struct HistoryView: View {
    @State private var rows = [String]()

    var body: some View {
        List {
            ForEach(rows, id: \.self) { row in
                NavigationLink(destination: DetailView(row: row)) {
                    Text(row)
                }

            }
        }
        .onAppear {
            if let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("data.csv") {
                do {
                    let fileContents = try String(contentsOf: fileURL)
                    rows = fileContents.components(separatedBy: "\n").filter { !$0.isEmpty }
                } catch {
                    print("Error reading file: \(error)")
                }
            }
        }
    }
}
    
    struct DetailView: View {
        let row: String

        var body: some View {
            let fields = row.components(separatedBy: ",")
            Form {
                Section(header: Text("Personal Information")) {
                    Text("First Name: \(fields[0])")
                    Text("Last Name: \(fields[1])")
                    Text("Email: \(fields[2])")
                    Text("Phone Number: \(fields[3])")
                }

                Section(header: Text("School Information")) {
                    Text("School Name: \(fields[4])")
                }
            }
            .navigationBarTitle("Details")
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
