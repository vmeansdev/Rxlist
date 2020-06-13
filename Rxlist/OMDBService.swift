import Alamofire
import RxAlamofire
import RxSwift

final class OMDBService {

    private let apiKey = "16fa0e9f"

    private let baseURL = "https://www.omdbapi.com"

    func getMoviesByTitle(_ title: String) -> Observable<[Movie]> {
        guard let url = URL(string: "\(baseURL)/?t=\(title)&apiKey=\(apiKey)") else {
            return Observable.just([])
        }
        return RxAlamofire.requestJSON(.get, url).map { (_, data) -> Data? in
            guard let data = (data as? [String: Any]) else {
                return nil
            }
            return try? JSONSerialization.data(withJSONObject: data, options: [])
        }.map { data -> [Movie] in
            guard let data = data else {
                return []
            }
            return (try? JSONDecoder().decode([Movie].self, from: data)) ?? []
        }
    }

}
