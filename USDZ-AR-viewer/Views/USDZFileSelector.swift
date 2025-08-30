import SwiftUI

struct USDZFileSelector: View {
    @State private var selectedFileURL: URL? = nil
    @State private var showingFileImporter = false
    
    var body: some View {
        VStack {
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
                ARUSDZView(usdzURL: url)
                    .aspectRatio(16/9, contentMode: .fit)
            }
        }
    }
}