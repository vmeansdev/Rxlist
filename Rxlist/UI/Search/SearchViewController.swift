import RxCocoa
import RxDataSources
import RxSwift
import SnapKit

class SearchViewController: UIViewController {

    // MARK: Properties

    private let router: SearchRouter

    private let viewModel: SearchViewModel

    private lazy var dataSource = RxTableViewSectionedReloadDataSource<MoviesSection>(configureCell: {
        [weak self] dataSource, tableView, indexPath, movie in
        let cell = tableView.dequeueReusableCell(MovieCell.self, for: indexPath)
        cell.selectionStyle = .none
        (cell as? MovieCell)?.model = .init(imageLink: movie.poster, title: movie.title)
        return cell
    })

    // MARK: Subviews

    private var searchBar = UISearchBar().with {
        $0.placeholder = "Type some movie title here"
    }

    private let tableView = UITableView(frame: .zero, style: .plain).with {
        $0.estimatedRowHeight = 250
        $0.keyboardDismissMode = .onDrag
        $0.rowHeight = UITableView.automaticDimension
        $0.separatorStyle = .none
        $0.tableFooterView = UIView()
    }

    // MARK: Initialization

    init(viewModel: SearchViewModel, router: SearchRouter) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
        title = "OMDB Movies Search"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubviews(searchBar, tableView)
        tableView.registerCell(MovieCell.self)

        configureLayout()

        /// This workaround is used to remove warning because of RxDatasources issue
        /// https://github.com/RxSwiftCommunity/RxDataSources/issues/331
        // FIXME: Remove workaround once issue is resolved
        DispatchQueue.main.async { [weak self] in
            self?.bindState()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.reloadIfNeeded()
    }

    // MARK: State

    private func bindState() {
        _ = searchBar.rx.text
            .orEmpty
            .takeUntil(rx.deallocated)
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.searchText)

        _ = viewModel.state.asObservable()
            .takeUntil(rx.deallocated)
            .distinctUntilChanged(==)
            .map { [MoviesSection(items: $0.items)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))

        _ = tableView.rx.itemSelected
            .asObservable()
            .takeUntil(rx.deallocated)
            .subscribeOn { [weak self] indexPath in
                guard let movie = self?.item(for: indexPath) else {
                    return
                }
                self?.router.openMovieDetails(movie)
            }
    }

    // MARK: Layout

    private func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(tableView.snp.top)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    // MARK: Private methods

    private func item(for indexPath: IndexPath) -> Movie? {
        viewModel.state.value.items.element(at: indexPath.row)
    }

}

