//
//  ContentView.swift
//  USDZ-AR-viewer
//
//  Created by Remo on 30.08.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedFileURL: URL? = nil
    @State private var showingFileImporter = false
    @State private var useStereoscopic = false

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Toggle("Stereoscopic AR (FSBS)", isOn: $useStereoscopic)
                    .padding()

                Button("Import USDZ File") {
                    showingFileImporter = true
                }
                .fileImporter(
                    isPresented: $showingFileImporter,
                    allowedContentTypes: [.usdz],
                    allowsMultipleSelection: false
                ) { result in
                    switch result {
                    case .success(let urls):
                        selectedFileURL = urls.first
                    case .failure(let error):
                        print("Error selecting file: \(error)")
                    }
                }

                if let url = selectedFileURL {
                    if useStereoscopic {
                        StereoscopicARView(usdzURL: url)
                            .frame(width: 3840, height: 1080)
                            .background(Color.black)
                            .clipped()
                    } else {
                        ARUSDZView(usdzURL: url)
                            .aspectRatio(16/9, contentMode: .fit)
                            .background(Color.black)
                    }
                } else {
                    Text("Please select a USDZ file to view.")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .navigationTitle("USDZ AR Viewer")
        }
    }
}

#Preview {
    ContentView()
}
