import Foundation
import Combine

class RepositoryViewModel: ObservableObject {
    @Published var repositories: [Repository] = []
    @Published var filteredRepositories: [Repository] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    private var currentPage = 1
    private var selectedLanguage: String = ""

    func fetchRepositories(reset: Bool = false) {
        if isLoading { return }

        isLoading = true
        if reset {
            currentPage = 1
            repositories.removeAll()
            filteredRepositories.removeAll()
        }

        GitHubService.shared.fetchRepositories(language: selectedLanguage, page: currentPage) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let repos):
                    self?.repositories.append(contentsOf: repos)
                    self?.filterRepositories(by: self?.selectedLanguage ?? "")
                    self?.currentPage += 1
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    func filterRepositories(by language: String) {
        if language.isEmpty {
            filteredRepositories = repositories
        } else {
            filteredRepositories = repositories.filter { $0.language?.caseInsensitiveCompare(language) == .orderedSame }
        }
    }
}

