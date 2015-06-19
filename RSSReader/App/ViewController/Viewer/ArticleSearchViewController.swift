
import Foundation
import UIKit

// ViewControllerのライフサイクルについてはメイン部分に記述する
class ArticleSearchViewController: BaseViewController {
    
    var articles: [ArticleEntity] = []
    var keyword: String = ""
    
    @IBOutlet weak var articleTableView: UITableView!
    
    override func viewDidLoad() {
        self.title = keyword + "の検索結果"
        
        // ここの部分だけtableViewの記述が入ってしまっている
        // そもそもdelegateとdetaSourceってstoryboardでも定義できるのでそちらのほうが良い？
        articleTableView.delegate = self
        articleTableView.dataSource = self
        
        let nib: UINib = UINib(nibName: "ArticleTableViewCell", bundle: nil)
        self.articleTableView.registerNib(nib, forCellReuseIdentifier: "ArticleCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.addModelObserve(ArticleModel.getInstance(), forKeyPath: "articles", options: .New, context: nil){
            self.articles = ArticleModel.getInstance().articles
            self.articleTableView.reloadData()
        }
        ArticleModel.getInstance().get(keyword, page: 1)
    }
    
    func refresh() {
        ArticleModel.getInstance().get(keyword, page: 1)
    }
}


// tableViewControllerとしての挙動はextensionを使って分けて記述する
extension ArticleSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        self.navigationController?.pushViewController(articleDetailViewController, animated: true)
    }
    
}