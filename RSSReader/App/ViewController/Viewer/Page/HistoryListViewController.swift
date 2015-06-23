
import Foundation
import UIKit

class HistoryListViewController: PageViewController {
    var articles: [ArticleEntity] = []

    @IBOutlet weak var articleTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib: UINib = UINib(nibName: "ArticleTableViewCell", bundle: NSBundle(forClass: self.classForCoder))
        self.articleTableView.registerNib(nib, forCellReuseIdentifier: "ArticleCell")
        articleTableView.delegate = self
        articleTableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        articles = ArticleModel.getInstance().histories()
        articleTableView.reloadData()
    }
    
}

extension HistoryListViewController: UITableViewDelegate, UITableViewDataSource {
    
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
    
}