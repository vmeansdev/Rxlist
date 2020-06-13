import UIKit

final class SearchAssembly: BaseAssembly {

    func searchViewController() -> UIViewController {
        let service = configuration.serviceFactory.omdbService()
        let viewModel = SearchViewModel(service: service)
        return SearchViewController(viewModel: viewModel)
    }

}
