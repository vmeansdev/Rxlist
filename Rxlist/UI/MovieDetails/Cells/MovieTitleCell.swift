import SnapKit

final class MovieTitleCell: UITableViewCell {

    // MARK: Types

    struct Model: Equatable {

        let title: String

    }

    // MARK: Properties

    var model: Model? {
        didSet {
            guard model != oldValue else {
                return
            }
            updateUI()
        }
    }

    private let titleLabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.numberOfLines = 0
        $0.textColor = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        preservesSuperviewLayoutMargins = false
        contentView.addSubview(titleLabel)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods

    private func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-8)
            $0.bottom.equalToSuperview().offset(-8)
        }
    }

    private func updateUI() {
        titleLabel.text = model?.title
    }

}

