## List in UICollectionView 
在 iOS 14 中，我们可以很轻松通过下面的三步来实现一个默认的列表。
* 设置 collectionView 的 configuration 和 layout。
* 配置 ListCell。
* 设置 DiffableDataSource。

### 设置 configuration 和 layout
通过 UICollectionLayoutListConfiguration、UICollectionViewCompositionalLayout来配置，仅需三行代码。
```
func makeCollectionView() -> UICollectionView {
    // step1
    let config = UICollectionLayoutListConfiguration(appearance: .plain)
    // step2
    let layout = UICollectionViewCompositionalLayout.list(using: config)
    return UICollectionView(frame: view.bounds, collectionViewLayout: layout)
}
```

代码说明：
#### UICollectionLayoutListConfiguration
step1：设置 collectionView list 风格的config。

UICollectionLayoutListConfiguration 包含 Appearance、HeaderMode、FooterMode 三个 enum。
* Appearance：用于设置列表的格式。
* HeaderMode：用于设置头视图的类型。
* FooterMode：用于设置尾视图的类型。

除了👆的三个枚举，它还包含👇两个比较重要的属性：
* leadingSwipeActionsConfigurationProvider：左向清扫的事件集合。
* trailingSwipeActionsConfigurationProvider：右向清扫的事件集合。

#### UICollectionViewCompositionalLayout
step2：将 config 赋值给 UICollectionViewCompositionalLayout

### 配置 ListCell
设置完 collectionView ，下面来配置下 UICollectionViewListCell 。该类是 iOS 14 新推出的，专门针对 list 视图。
```
func makeCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Contact> {
    UICollectionView.CellRegistration { cell, indexPath, contact in
        // step1 
        var config = cell.defaultContentConfiguration()
        // step2 
        config.text = contact.name
        config.secondaryText = contact.email
        // step3
        cell.contentConfiguration = config
        // step4
        cell.accessories = [.disclosureIndicator()]
    }
}
```

代码说明：
* step1：获取 cell 默认的 config。注意，该 config 有默认的样式但没有任何数据。
* step2：给 config 设置内容。
* step3：仅获取默认的 config，并给该 config 赋值是不够的的，还需给 `contentConfiguration` 赋值。
* step4：设置指示器。

### 设置 DiffableDataSource
最后一步，配置数据源。

```
func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Contact> {
    let cellRegistration = makeCellRegistration()
    return UICollectionViewDiffableDataSource<Section, Contact>(
        collectionView: collectionView) { (view, indexPath, item) -> UICollectionViewCell? in
        view.dequeueConfiguredReusableCell(
            using: cellRegistration,
            for: indexPath,
            item: item)
    }
}
```
至此，我们即可通过 collectionView 完成一个列表视图。

### 总结
通过设置config + layout、配置 cell、添加数据源三步即可实现一个列表。主要使用到的类：
* UICollectionLayoutListConfiguration、UICollectionViewCompositionalLayout：配置 collectionView。
* UICollectionViewListCell： 配置 cell。
* UICollectionViewDiffableDataSource：数据源。

### 完整代码
```
import UIKit

class ViewController: UIViewController {
    private let viewModel = ContactListViewModel()
    private lazy var collectionView = makeCollectionView()
    private lazy var dataSource = makeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = dataSource
        view.addSubview(collectionView)
        updateList()
    }
}

private extension ViewController {
    func makeCollectionView() -> UICollectionView {
        let config = UICollectionLayoutListConfiguration(appearance: .sidebarPlain)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return UICollectionView(frame: view.bounds, collectionViewLayout: layout)
    }
    
    func makeCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Contact> {
        UICollectionView.CellRegistration { cell, indexPath, contact in
            var config = cell.defaultContentConfiguration()
            config.text = contact.name
            config.secondaryText = contact.email
            cell.contentConfiguration = config
            cell.accessories = [.disclosureIndicator()]
        }
    }
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Contact> {
        let cellRegistration = makeCellRegistration()
        return UICollectionViewDiffableDataSource<Section, Contact>(
            collectionView: collectionView) { (view, indexPath, item) -> UICollectionViewCell? in
            view.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item)
        }
    }
    
    func updateList() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Contact>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(viewModel.favorites, toSection: .favorites)
        snapshot.appendItems(viewModel.all, toSection: .all)
        dataSource.apply(snapshot)
    }
}

struct ContactListViewModel {
    var favorites = [Contact(name: "jack", email: "jack-email"), Contact(name: "rose", email: "rose-email")]
    var all = [Contact(name: "mark", email: "mark-email"), Contact(name: "jerry", email: "jerry-emial")]
}

enum Section: CaseIterable {
    case favorites
    case all
}

struct Contact: Hashable {
    var name: String
    var email: String
}
```

仅需 60 多行即可实现一个列表，这样的代码它不香吗？