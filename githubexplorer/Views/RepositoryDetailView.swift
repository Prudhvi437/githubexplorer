import SwiftUI

struct RepositoryDetailView: View {
    let repository: Repository

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(repository.name)
                .font(.title)
                .bold()

            if let description = repository.description {
                Text(description)
                    .font(.body)
            } else {
                Text("No description available")
                    .italic()
            }

            Text("Language: \(repository.language ?? "Unknown")")
                .font(.subheadline)

            Text("Stars: \(repository.stargazersCount)")
                .font(.subheadline)

            Text("Forks: \(repository.forks)")
                .font(.subheadline)

            Text("Last Updated: \(repository.updatedAt)")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding()
        .navigationTitle("Details")
    }
}

