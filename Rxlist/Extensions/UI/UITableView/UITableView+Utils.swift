import UIKit

extension UITableView {

    func registerCell<Cell: UITableViewCell>(
        _ type: Cell.Type,
        withReuseIdentifier reuseIdenitifier: String = Cell.defaultReuseIdentifier
    ) {
        register(type, forCellReuseIdentifier: reuseIdenitifier)
    }

    func dequeueReusableCell<Cell: UITableViewCell>(
        _ type: Cell.Type,
        for indexPath: IndexPath,
        withReuseIdentifier reuseIdentifier: String = Cell.defaultReuseIdentifier
    ) -> UITableViewCell {
        self.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
    }

}
