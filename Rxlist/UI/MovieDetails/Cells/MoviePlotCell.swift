import SnapKit

final class MoviePlotCell: UITableViewCell {

    // MARK: Types

    struct Model: Equatable {

        let title: String
        let plot: String?

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
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let plotLabel = UILabel().with {
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        preservesSuperviewLayoutMargins = false
        contentView.addSubviews(titleLabel, plotLabel)
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
            $0.bottom.equalTo(plotLabel.snp.top).offset(-8)
        }
        plotLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.bottom.lessThanOrEqualTo(contentView.snp.bottom).offset(-8)
        }
    }

    // MARK: UI

    private func updateUI() {
        titleLabel.text = model?.title
        plotLabel.text = model?.plot
    }

}


