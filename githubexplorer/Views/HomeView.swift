import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = RepositoryViewModel()
    @State private var selectedLanguage: String = ""
    private let languages = ["", "Swift","Kotlin", "Python", "Java", "JavaScript"]

    var body: some View {
        NavigationView {
            VStack {
                // Language filter picker
                Picker("Filter by Language", selection: $selectedLanguage) {
                    ForEach(languages, id: \.self) { language in
                        Text(language.isEmpty ? "All" : language).tag(language)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: selectedLanguage) { newValue in
                    viewModel.filterRepositories(by: newValue)
                }

                // Display loading, error, or repository list
                if viewModel.isLoading && viewModel.repositories.isEmpty {
                    ProgressView("Loading repositories...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    List(viewModel.filteredRepositories) { repo in
                        NavigationLink(destination: RepositoryDetailView(repository: repo)) {
                            VStack(alignment: .leading) {
                                Text(repo.name)
                                    .font(.headline)
                                Text(repo.description ?? "No description available")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("Language: \(repo.language ?? "Unknown")")
                                    .font(.footnote)
                            }
                        }
                        .onAppear {
                            // Trigger fetch for the next page when the last item is visible
                            if repo == viewModel.filteredRepositories.last && !viewModel.isLoading {
                                viewModel.fetchRepositories()
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Repositories")
            .onAppear {
                viewModel.fetchRepositories(reset: true)
            }
        }
    }
}

