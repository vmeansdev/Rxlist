final class SearchRouter: BaseRouter<SearchViewController> {

    func openMovieDetails(_ movie: Movie) {
        let movieDetailsViewController = assemblyFactory.movieDetailsAssembly()
            .movieDetailsViewController(movie: movie)
        viewController?.show(movieDetailsViewController, sender: self)
    }

}
