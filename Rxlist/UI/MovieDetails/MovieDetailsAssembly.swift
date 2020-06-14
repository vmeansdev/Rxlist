import UIKit

final class MovieDetailsAssembly: BaseAssembly {

    func movieDetailsViewController(movie: Movie) -> UIViewController {
        let service = configuration.serviceFactory.omdbService()
        let viewModel = MovieDetailsViewModel(movie: movie, service: service)
        return MovieDetailsViewController(viewModel: viewModel)
    }

}
