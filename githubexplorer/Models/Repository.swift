import Foundation

struct Repository: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let description: String?
    let language: String?
    let stargazersCount: Int
    let forks: Int
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case language
        case stargazersCount = "stargazers_count"
        case forks
        case updatedAt = "updated_at"
    }

    // `Equatable` conformance by comparing `id` (unique identifier for each repository)
    static func == (lhs: Repository, rhs: Repository) -> Bool {
        return lhs.id == rhs.id
    }
}

