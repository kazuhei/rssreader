
import Foundation
import UIKit
import RxSwift
import SVProgressHUD

class ArticleListViewController: PageViewController, UITableViewDataSource, UITableViewDelegate {
    
    var articles: [ArticleEntity] = []
    private var contentOffset : Variable<CGPoint> = Variable(CGPoint())
    var pageIndex: Int = 1
    
    @IBOutlet weak var articleTableView: UITableView?
    // navigationBarの設定
    override func navigationRightBarButtons() -> [UIBarButtonItem] {
        let refreshButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refresh")
        return [refreshButton]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // viewDidLoadの段階ではstoryboardからのview生成は終了しているので強制開示
        articleTableView!.delegate = self
        articleTableView!.dataSource = self
        let firstCell: UINib = UINib(nibName: "ArticleTableViewFirstCell", bundle: NSBundle(forClass: self.classForCoder))
        self.articleTableView!.registerNib(firstCell, forCellReuseIdentifier: "ArticleFirstCell")
        let nib: UINib = UINib(nibName: "ArticleTableViewCell", bundle: NSBundle(forClass: self.classForCoder))
        self.articleTableView!.registerNib(nib, forCellReuseIdentifier: "ArticleCell")
        
        // 最上部で更に下に引っ張った時に最新の記事を取得する
        contentOffset
            >- filter { $0.y < 0 }
            >- subscribeNext {
                _ in
                if !SVProgressHUD.isVisible() {
                    self.refresh()
                }
            }
        
        // 最下部に到達した時にさらに30件取得する
        contentOffset
            >- filter {
                topPosition in
                topPosition.y + self.articleTableView!.frame.height > self.articleTableView!.contentSize.height
            } >- subscribeNext {
                _ in
                if !SVProgressHUD.isVisible() {
                    self.fetchArticles()
                }
        }
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
        var cellIdentigier = "ArticleCell"
        if indexPath.row == 0 {
            cellIdentigier = "ArticleFirstCell"
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentigier, forIndexPath: indexPath) as! BaseArticleTableViewCell
        cell.configure(articles[indexPath.row])
        
        return cell as! UITableViewCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if articles.count != 0  {
            var cellIdentigier = "ArticleCell"
            if indexPath.row == 0 {
                cellIdentigier = "ArticleFirstCell"
            }
            let stabCell = tableView.dequeueReusableCellWithIdentifier(cellIdentigier) as! BaseArticleTableViewCell
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
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        contentOffset.next(scrollView.contentOffset)
    }
    
    func refresh() {
        SVProgressHUD.show()
        subscriptions.append(ArticleModel.getInstance().get(1) >- subscribe(next:
            {
                articles in
                self.articles = articles
                self.articleTableView?.reloadData()
            }, error: {
                error in
                println(error)
                SVProgressHUD.showErrorWithStatus("ロード失敗")
            }, completed: {
                SVProgressHUD.dismiss()
            }
        ))
    }
    
    func fetchArticles() {
        pageIndex++
        SVProgressHUD.show()
        subscriptions.append(ArticleModel.getInstance().get(pageIndex) >- subscribe(next:
            {
                articles in
                self.articles += articles
                self.articleTableView?.reloadData()
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