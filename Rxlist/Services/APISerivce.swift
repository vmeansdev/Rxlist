import Alamofire
import RxAlamofire
import RxSwift

enum RequestError: Error {

    case buildURL(urlString: String)

}

extension RequestError: CustomDebugStringConvertible {

    public var debugDescription: String {
        switch self {
        case .buildURL(let urlString):
            return "RequestError.buildURL: \(urlString)"
        }
    }

}

enum ResponseError: Error {

    case decoding

}

extension ResponseError: CustomDebugStringConvertible {

    public var debugDescription: String {
        switch self {
        case .decoding:
            return "ResponseError.decoding"
        }
    }

}

class APIService {

    // MARK: Properties

    let baseURL: URL

    // MARK: Initialization

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    // MARK: Implementation

    func get<T: Codable>(url: URL) -> Observable<T> {
        RxAlamofire.requestJSON(.get, url).map { (_, data) -> Data? in
            guard let data = (data as? [String: Any]) else {
                return nil
            }
            return try? JSONSerialization.data(withJSONObject: data, options: [])
        }.map { data -> Swift.Result<T, Error> in
            guard
                let data = data,
                let result = try? JSONDecoder().decode(T.self, from: data)
            else {
                return .failure(ResponseError.decoding)
            }
            return .success(result)
        }.skipNil()
    }

    // MARK: Utils

    func buildQuery<T: LosslessStringConvertible>(_ params: [String: T]) -> [Foundation.URLQueryItem] {
        var query: [Foundation.URLQueryItem] = []
        for (k, v) in params {
            query.append(Foundation.URLQueryItem(name: k, value: String(v)))
        }
        return query
    }

    func buildURL(path: String, query: [Foundation.URLQueryItem]?) throws -> URL {
        let absoluteURL = baseURL.appendingPathComponent(path)
        guard var components = Foundation.URLComponents(url: absoluteURL, resolvingAgainstBaseURL: true) else {
            throw RequestError.buildURL(urlString: absoluteURL.absoluteString)
        }
        if let query = query, !query.isEmpty {
            components.queryItems = (components.queryItems ?? []) + query
        }
        guard let result = components.url else {
            throw RequestError.buildURL(urlString: absoluteURL.absoluteString)
        }
        return result
    }

}
