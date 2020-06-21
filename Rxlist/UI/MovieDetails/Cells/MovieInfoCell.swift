import SnapKit

final class MovieInfoCell: UITableViewCell {

    // MARK: Types

    struct Model: Equatable {

        let title: String?
        let details: String

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

    // MARK: Subviews

    private let titleLabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.numberOfLines = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let detailsLabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .light)
        $0.numberOfLines = 0
        $0.textColor = .darkGray
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        preservesSuperviewLayoutMargins = false
        contentView.addSubviews(titleLabel, detailsLabel)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Layout

    private func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.top.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.bottom.lessThanOrEqualTo(detailsLabel.snp.top).offset(-8)
        }
        detailsLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.trailing.equalTo(titleLabel.snp.trailing)
            $0.bottom.equalToSuperview().offset(-8)
        }
    }

    // MARK: UI

    private func updateUI() {
        titleLabel.text = model?.title
        detailsLabel.text = model?.details
    }

}



