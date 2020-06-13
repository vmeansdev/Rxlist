import RxSwift

final class OMDBService: APIService {

    // MARK: Properties

    private let apiKey: String

    // MARK: Initialization

    init(baseURL: URL, apiKey: String) {
        self.apiKey = apiKey
        super.init(baseURL: baseURL)
    }

    // MARK: Implementation

    func getMoviesByTitle(_ title: String) -> Observable<SearchResult<Movie>> {
        guard let url = try? buildURL(path: "/", query: buildQuery(["s": title])) else {
            return Observable.error(RequestError.buildURL(urlString: "movies"))
        }
        debugPrint("[GET]: \(url)")
        return get(url: url)
    }

    // MARK: Utils

    override func buildQuery<T: LosslessStringConvertible>(_ params: [String: T]) -> [Foundation.URLQueryItem] {
        var query = super.buildQuery(params)
        query.append(Foundation.URLQueryItem(name: "apiKey", value: apiKey))
        return query
    }

}
