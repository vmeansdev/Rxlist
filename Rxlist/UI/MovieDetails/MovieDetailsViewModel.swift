import RxCocoa
import RxSwift


// MARK: -

struct MovieDetailInfo: Equatable {

    let title: String
    let details: String

}

// MARK: -

enum MovieDetailSection: Equatable {

    case poster(URL?)
    case title(String)
    case plot(MovieDetailInfo)
    case info(MovieDetailInfo)

    static func == (lhs: MovieDetailSection, rhs: MovieDetailSection) -> Bool {
        switch (lhs, rhs) {
        case (.poster(let lurl), .poster(let rurl)):
            return lurl == rurl
        case (.title(let ltitle), .title(let rtitle)):
            return ltitle == rtitle
        case (.plot(let lplot), .plot(let rplot)):
            return lplot == rplot
        case (.info(let linfo), .info(let rinfo)):
            return linfo == rinfo
        default:
            return false
        }
    }

}

// MARK: -

struct MovieDetailsViewModelState: LoadableState, Equatable {

    // MARK: Properties

    var loadingState: LoadingState

    var movie: Movie?

    var items: [MovieDetailSection]

    var hasData: Bool {
        return !items.isEmpty
    }

    // MARK: Initialization

    init(movie: Movie? = nil, items: [MovieDetailSection] = [], loadingState: LoadingState = .idle) {
        self.movie = movie
        self.items = items
        self.loadingState = loadingState
    }

    // MARK: Updates

    func updated(withLoadingState loadingState: LoadingState) -> MovieDetailsViewModelState {
        MovieDetailsViewModelState(movie: movie, items: items, loadingState: loadingState)
    }

    // MARK: Equatable

    static func == (lhs: MovieDetailsViewModelState, rhs: MovieDetailsViewModelState) -> Bool {
        lhs.items == rhs.items &&
        lhs.loadingState == rhs.loadingState
    }

}

// MARK: -

final class MovieDetailsViewModel: Loadable {

    // MARK: Types

    typealias State = MovieDetailsViewModelState

    // MARK: Properties

    private let movie: Movie

    private let service: OMDBService

    private let disposeBag = DisposeBag()

    // MARK: Initialization

    init(movie: Movie, service: OMDBService) {
        self.movie = movie
        self.service = service
    }

    // MARK: Loadable

    private let _state = BehaviorRelay(value: State())

    private(set) lazy var state = ReadOnlyVariable(_state)

    @discardableResult
    func reload() -> Bool {
        reload(startingWith: .loading)
    }

    func pulledToRefresh() -> Bool {
        reload(startingWith: .pulledToRefresh)
    }

    private func reload(startingWith loadingState: LoadingState) -> Bool {
        if [.loading, .pulledToRefresh].contains(_state.value.loadingState) {
            return false
        }

        _state.accept(_state.value.updated(withLoadingState: loadingState))

        _ = service.getMovieDetailsById(movie.id)
            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInitiated))
            .do(onNext: { debugPrint("Movie details found: \($0)") })
            .map { self.state(for: $0) }
            .observeOn(MainScheduler.asyncInstance)
            .catchError { [weak self] in
                debugPrint("Error happened: \($0)")
                var state = State()
                state.loadingState = .error($0)
                self?._state.accept(state)
                return Observable.just(state)
            }.bind(to: _state)
            .disposed(by: disposeBag)

        return true
    }

    // MARK: Implementation

    private func state(for movie: Movie) -> State {
        let plot: MovieDetailSection? = movie.plot.map { .plot(.init(title: "Plot", details: $0)) }
        let actors: MovieDetailSection? = movie.actors.map { .info(.init(title: "Actors", details: $0)) }
        let year: MovieDetailSection? = movie.year.map { .info(.init(title: "Year", details: String($0))) }
        let genre: MovieDetailSection? = movie.genre.map { .info(.init(title: "Genre", details: $0)) }
        let runtime: MovieDetailSection? = movie.runtime.map { .info(.init(title: "Runtime", details: $0)) }
        let director: MovieDetailSection? = movie.director.map { .info(.init(title: "Director", details: $0)) }
        let country: MovieDetailSection? = movie.country.map { .info(.init(title: "Country", details: $0)) }
        let items: [MovieDetailSection] = [
            .poster(movie.poster.flatMap { URL(string: $0) }),
            .title(movie.title),
            genre,
            plot,
            actors,
            runtime,
            year,
            director,
            country,
        ].compactMap { $0 }
        return State(movie: movie, items: items)
    }

}

