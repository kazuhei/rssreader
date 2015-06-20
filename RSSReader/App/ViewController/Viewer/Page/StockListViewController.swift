
import Foundation
import UIKit
import RxSwift
import SVProgressHUD

class StockListViewController: PageViewController, UITableViewDataSource, UITableViewDelegate {
    
    var articles: [ArticleEntity] = []
    
    @IBOutlet weak var stockTableView: UITableView?
    
    override func navigationRightBarButtons() -> [UIBarButtonItem] {
        let refreshButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refresh")
        return [refreshButton]
    }
    
    override func viewDidLoad() {
        stockTableView!.delegate = self
        stockTableView!.dataSource = self
        let nib: UINib = UINib(nibName: "ArticleTableViewCell", bundle: nil)
        self.stockTableView!.registerNib(nib, forCellReuseIdentifier: "ArticleCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
     
        refresh()
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let articleDetailStoryboard = UIStoryboard(name: "ArticleDetail", bundle: nil)
        let articleDetailViewController = articleDetailStoryboard.instantiateInitialViewController() as! ArticleDetailViewController
        articleDetailViewController.articleId = articles[indexPath.row].id
        self.pushViewController = articleDetailViewController
    }
    
    func refresh() {
        SVProgressHUD.show()
        subscriptions.append(ArticleModel.getInstance().getStocks(1) >- subscribe(next:
            {
                articles in
                self.articles = articles
                self.stockTableView?.reloadData()
            }, error: {
                error in
                println(error)
                SVProgressHUD.showErrorWithStatus("ロード失敗")
            }, completed: {
                SVProgressHUD.dismiss()
            }
        ))
    }
}