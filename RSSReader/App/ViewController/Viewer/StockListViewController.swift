
import Foundation
import UIKit

class StockListViewController: PageViewController, UITableViewDataSource, UITableViewDelegate {
    
    var articles: [ArticleEntity] = []
    
    @IBOutlet weak var stockTableView: UITableView!
    
    override func navigationRightBarButtons() -> [UIBarButtonItem] {
        let refreshButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refresh")
        return [refreshButton]
    }
    
    override func viewDidLoad() {
        stockTableView.delegate = self
        stockTableView.dataSource = self
        let nib: UINib = UINib(nibName: "ArticleTableViewCell", bundle: nil)
        self.stockTableView.registerNib(nib, forCellReuseIdentifier: "ArticleCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.addModelObserve(ArticleModel.getInstance(), forKeyPath: "stocks", options: .New, context: nil){
            self.articles = ArticleModel.getInstance().stocks
            self.stockTableView.reloadData()
        }
        ArticleModel.getInstance().getStocks(1)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 再利用するCellを取得する.
        let cell = tableView.dequeueReusableCellWithIdentifier("ArticleCell", forIndexPath: indexPath) as! ArticleTableViewCell
        cell.configure(articles[indexPath.row])
        
        return cell as UITableViewCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if articles.count != 0  {
            let stabCell = tableView.dequeueReusableCellWithIdentifier("ArticleCell") as! ArticleTableViewCell
            return stabCell.getHeight(articles[indexPath.row], width: tableView.frame.width)
        }
        return 100
    }
    
    func refresh() {
        ArticleModel.getInstance().getStocks(1)
    }
}