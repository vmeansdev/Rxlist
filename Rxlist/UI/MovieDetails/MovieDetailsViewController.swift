import SnapKit

final class MovieDetailsViewController: UIViewController, UITableViewDataSource {

    // MARK: Properties

    private let viewModel: MovieDetailsViewModel

    // MARK: Subviews

    private lazy var tableView = UITableView().with {
        $0.dataSource = self
        $0.estimatedRowHeight = 250
        $0.rowHeight = UITableView.automaticDimension
        $0.separatorStyle = .none
        $0.tableFooterView = UIView()
    }

    // MARK: Initialization

    init(viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
        title = "Movie details"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        view.addSubview(tableView)

        registerCells()
        configureLayout()
        bindState()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.reloadIfNeeded()
    }

    private func registerCells() {
        tableView.registerCell(MoviePosterCell.self)
        tableView.registerCell(MovieTitleCell.self)
        tableView.registerCell(MoviePlotCell.self)
        tableView.registerCell(MovieInfoCell.self)
    }

    // MARK: UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.state.value.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        switch section(at: indexPath.row) {
        case .poster(let url):
            cell = tableView.dequeueReusableCell(MoviePosterCell.self, for: indexPath)
            (cell as? MoviePosterCell)?.model = .init(imageURL: url)
        case .title(let title):
            cell = tableView.dequeueReusableCell(MovieTitleCell.self, for: indexPath)
            (cell as? MovieTitleCell)?.model = .init(title: title)
        case .plot(let info):
            cell = tableView.dequeueReusableCell(MoviePlotCell.self, for: indexPath)
            (cell as? MoviePlotCell)?.model = .init(title: info.title, plot: info.details)
        case .info(let info):
            cell = tableView.dequeueReusableCell(MovieInfoCell.self, for: indexPath)
            (cell as? MovieInfoCell)?.model = .init(title: info.title, details: info.details)
        }
        cell.selectionStyle = .none
        return cell
    }

    // MARK: State

    private func bindState() {
        _ = viewModel.state.asObservable()
        .takeUntil(rx.deallocated)
        .distinctUntilChanged(==)
        .subscribeOn { [weak self] _ in
            self?.tableView.reloadData()
        }
    }

    // MARK: Layout

    private func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    // MARK: Private methods

    private func section(at index: Int) -> MovieDetailSection {
        guard let section = viewModel.state.value.items.element(at: index) else {
            fatalError("Out of bounds")
        }

        return section
    }

}
