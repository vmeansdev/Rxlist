import Foundation

class ServiceFactory {

    // MARK: Properties

    private let omdbBaseURL: URL

    private let omdbAPIKey: String

    // MARK: Initialization

    init(omdbBaseURL: URL, omdbAPIKey: String) {
        self.omdbBaseURL = omdbBaseURL
        self.omdbAPIKey = omdbAPIKey
    }

    // MARK: Implementation

    func omdbService() -> OMDBService {
        OMDBService(baseURL: omdbBaseURL, apiKey: omdbAPIKey)
    }

}
