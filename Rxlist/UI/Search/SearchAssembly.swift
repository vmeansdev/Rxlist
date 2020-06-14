import UIKit

final class SearchAssembly: BaseAssembly {

    func searchViewController() -> UIViewController {
        let serviceFactory = configuration.serviceFactory
        let service = serviceFactory.omdbService()
        let router = SearchRouter(
            assemblyFactory: configuration.assemblyFactory,
            serviceFactory: serviceFactory
        )
        let viewModel = SearchViewModel(service: service)
        let searchViewController = SearchViewController(viewModel: viewModel, router: router)
        router.viewController = searchViewController
        return searchViewController
    }

}
