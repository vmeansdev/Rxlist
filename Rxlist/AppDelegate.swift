import RxSwift
import RxRelay
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var disposeBag = DisposeBag()
    private let isInitialized = BehaviorRelay(value: false)
    private var initializationViewModel: AppInitializationViewModel?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        startApplication()
        return true
    }

    private func startApplication() {
        let initializationManager = AppInitializationManager()
        let initializationViewModel = AppInitializationViewModel(initializationManager: initializationManager)
        self.initializationViewModel = initializationViewModel
        isInitialized.accept(false)
        initializationManager.state.asObservable()
            .subscribeOn { [weak self] state in
                self?.continueAppLaunch(state: state, model: initializationViewModel)
            }
            .disposed(by: disposeBag)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = AppInitializationViewController(viewModel: initializationViewModel)
        window?.makeKeyAndVisible()
    }

    private func continueAppLaunch(state: AppInitializationState, model: AppInitializationViewModel) {
        switch state {
        case .notInitialized, .initializing, .error:
            break
        case .initialized(let serviceFactory, let assemblyFactory):
            showRootViewController(
                assemblyFactory: assemblyFactory,
                serviceFactory: serviceFactory
            )
            isInitialized.accept(true)
        }
    }

    private func showRootViewController(assemblyFactory: AssemblyFactory, serviceFactory: ServiceFactory) {
        let rootController = assemblyFactory.searchAssembly()
            .searchViewController()
            .withNavigation()
        window?.rootViewController = rootController
    }

}

