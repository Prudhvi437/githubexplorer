import Foundation

class GitHubService {
    static let shared = GitHubService()
    private let baseURL = "https://api.github.com/users/google/repos"

    func fetchRepositories(language: String?, page: Int, completion: @escaping (Result<[Repository], Error>) -> Void) {
        var urlString = "\(baseURL)?per_page=20&page=\(page)"
        if let language = language, !language.isEmpty {
            // Note: /users/{username}/repos does not support filtering by language directly.
            // You'd need to filter manually after fetching.
        }

        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 400, userInfo: nil)))
                return
            }

            do {
                // Decode directly to an array of Repository objects
                let repositories = try JSONDecoder().decode([Repository].self, from: data)
                completion(.success(repositories))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

