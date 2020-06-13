import RxSwift
import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private lazy var tableView = UITableView(frame: .zero, style: .plain).with {
        $0.dataSource = self
        $0.delegate = self
        $0.keyboardDismissMode = .onDrag
        $0.tableFooterView = UIView()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func bindState() {
        // TODO: use model to obtain data
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }

}

