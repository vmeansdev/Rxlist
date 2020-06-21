import SnapKit

class AppInitializationViewController: UIViewController {

    // MARK: Properties

    private let viewModel: AppInitializationViewModel

    private lazy var launchScreenController =
        instantiateViewController(
            controllerIdentifier: "LaunchScreenIdentifier",
            storyboardIdentifier: "LaunchScreen"
        )

    // MARK: Initialization

    init(viewModel: AppInitializationViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        attachChild(launchScreenController)
        configureLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.reloadIfNeeded()
    }

    // MARK: Layout

    private func configureLayout() {
        launchScreenController.view.snp.makeConstraints {
            [$0.leading, $0.top, $0.trailing, $0.bottom].forEach { $0.equalToSuperview() }
        }
    }

    // MARK: Status Bar

    override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: Orientation

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

}

// MARK: -

private func instantiateViewController(controllerIdentifier: String, storyboardIdentifier: String) -> UIViewController {
    let storyboard = UIStoryboard(name: storyboardIdentifier, bundle: .main)
    return storyboard.instantiateViewController(withIdentifier: controllerIdentifier)
}

