import RxCocoa
import RxDataSources
import RxSwift
import SnapKit

class SearchViewController: UIViewController {

    // MARK: Properties

    private let viewModel: SearchViewModel

    private var searchBar = UISearchBar().with {
        $0.placeholder = "Type some movie title here"
    }

    private lazy var tableView = UITableView(frame: .zero, style: .plain).with {
        $0.estimatedRowHeight = 250
        $0.keyboardDismissMode = .onDrag
        $0.rowHeight = UITableView.automaticDimension
        $0.separatorStyle = .none
        $0.tableFooterView = UIView()
    }

    private lazy var dataSource = RxTableViewSectionedReloadDataSource<MoviesSection>(configureCell: {
        [weak self] dataSource, tableView, indexPath, item in
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.defaultReuseIdentifier, for: indexPath)
        self?.configureCell(cell, movie: item)
        return cell
    })

    // MARK: Initialization

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "OMDB Movies Search"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(searchBar, tableView)
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.defaultReuseIdentifier)

        configureLayout()
        bindState()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.reloadIfNeeded()
    }

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
            .map { [MoviesSection(header: "", items: $0.items)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
    }

    // MARK: Private methods

    private func configureCell(_ cell: UITableViewCell, movie: Movie) {
        guard let cell = cell as? MovieCell else {
            return
        }
        cell.selectionStyle = .none
        cell.model = .init(imageLink: movie.poster, title: movie.title)
    }

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

}

