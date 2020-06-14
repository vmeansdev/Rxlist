import SnapKit

final class MovieDetailsViewController: UIViewController, UITableViewDataSource {

    // MARK: Properties

    private let viewModel: MovieDetailsViewModel

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
        tableView.register(MoviePosterCell.self, forCellReuseIdentifier: MoviePosterCell.defaultReuseIdentifier)
        tableView.register(MovieTitleCell.self, forCellReuseIdentifier: MovieTitleCell.defaultReuseIdentifier)
        tableView.register(MoviePlotCell.self, forCellReuseIdentifier: MoviePlotCell.defaultReuseIdentifier)
        tableView.register(MovieInfoCell.self, forCellReuseIdentifier: MovieInfoCell.defaultReuseIdentifier)
    }

    // MARK: UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.state.value.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        switch section(at: indexPath.row) {
        case .poster(let url):
            cell = tableView.dequeueReusableCell(
                withIdentifier: MoviePosterCell.defaultReuseIdentifier,
                for: indexPath
            )
            configurePosterCell(cell, url: url)
        case .title(let title):
            cell = tableView.dequeueReusableCell(
                withIdentifier: MovieTitleCell.defaultReuseIdentifier,
                for: indexPath
            )
            configureTitleCell(cell, title: title)
        case .plot(let info):
            cell = tableView.dequeueReusableCell(
                withIdentifier: MoviePlotCell.defaultReuseIdentifier,
                for: indexPath
            )
            configurePlotCell(cell, info: info)
        case .info(let info):
            cell = tableView.dequeueReusableCell(
                withIdentifier: MovieInfoCell.defaultReuseIdentifier,
                for: indexPath
            )
            configureInfoCell(cell, info: info)
        }
        cell.selectionStyle = .none
        return cell
    }

    // MARK: Private methods

    private func section(at index: Int) -> MovieDetailSection {
        guard let section = viewModel.state.value.items.element(at: index) else {
            fatalError("Out of bounds")
        }

        return section
    }

    func configurePosterCell(_ cell: UITableViewCell, url: URL?) {
        guard let cell = cell as? MoviePosterCell else {
            return
        }
        cell.model = .init(imageURL: url)
    }

    func configureTitleCell(_ cell: UITableViewCell, title: String) {
        guard let cell = cell as? MovieTitleCell else {
            return
        }
        cell.model = .init(title: title)
    }

    func configurePlotCell(_ cell: UITableViewCell, info: MovieDetailInfo) {
        guard let cell = cell as? MoviePlotCell else {
            return
        }
        cell.model = .init(title: info.title, plot: info.details)
    }

    func configureInfoCell(_ cell: UITableViewCell, info: MovieDetailInfo) {
        guard let cell = cell as? MovieInfoCell else {
            return
        }
        cell.model = .init(title: info.title, details: info.details)
    }

    private func bindState() {
        _ = viewModel.state.asObservable()
        .takeUntil(rx.deallocated)
        .distinctUntilChanged(==)
        .subscribeOn { [weak self] _ in
            self?.tableView.reloadData()
        }
    }

    private func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

}
