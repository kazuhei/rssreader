
import Foundation
import UIKit
import RxSwift
import SVProgressHUD

class ArticleListViewController: PageViewController, UITableViewDataSource, UITableViewDelegate {
    
    var articles: [ArticleEntity] = []
    private var contentOffset : Variable<CGPoint> = Variable(CGPoint())
    private var pageIndex: Int = 1
    
    @IBOutlet weak var articleTableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // viewDidLoadの段階ではstoryboardからのview生成は終了しているので強制開示
        articleTableView!.delegate = self
        articleTableView!.dataSource = self
        let firstCell: UINib = UINib(nibName: "ArticleTableViewFirstCell", bundle: NSBundle(forClass: self.classForCoder))
        self.articleTableView!.registerNib(firstCell, forCellReuseIdentifier: "ArticleFirstCell")
        let nib: UINib = UINib(nibName: "ArticleTableViewCell", bundle: NSBundle(forClass: self.classForCoder))
        self.articleTableView!.registerNib(nib, forCellReuseIdentifier: "ArticleCell")
        
        // 最下部に到達した時にさらに30件取得する
        contentOffset
            >- filter {
                _ in
                self.articleTableView!.contentSize.height > 0
            } >- filter {
                topPosition in
                topPosition.y + self.articleTableView!.frame.height > self.articleTableView!.contentSize.height
            } >- subscribeNext {
                _ in
                if !SVProgressHUD.isVisible() {
                    self.fetchArticles()
                }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let refreshButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refresh")
        getContext().navigationController?.visibleViewController.navigationItem.setRightBarButtonItem(refreshButton, animated: false)
        refresh()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 再利用するCellを取得する.
        var cellIdentifier = "ArticleCell"
        if indexPath.row == 0 {
            cellIdentifier = "ArticleFirstCell"
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! BaseArticleTableViewCell
        cell.configure(articles[indexPath.row])
        
        return cell as! UITableViewCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if articles.count != 0  {
            var cellIdentifier = "ArticleCell"
            if indexPath.row == 0 {
                cellIdentifier = "ArticleFirstCell"
            }
            let stabCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! BaseArticleTableViewCell
            return stabCell.getHeight(articles[indexPath.row], width: tableView.frame.width)
        }
        return 100
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let articleDetailStoryboard = UIStoryboard(name: "ArticleDetail", bundle: nil)
        let articleDetailViewController = articleDetailStoryboard.instantiateInitialViewController() as! ArticleDetailViewController
        articleDetailViewController.articleId = articles[indexPath.row].id
        getContext().navigationController?.pushViewController(articleDetailViewController, animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        contentOffset.next(scrollView.contentOffset)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y < -40 {
            pullToRefresh()
        }
    }
    
    func refresh() {
        SVProgressHUD.show()
        subscriptions.append(ArticleModel.getInstance().get(1) >- filter {
            articles in
            articles.count > 0
            } >- subscribe(next:
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
    
    func pullToRefresh() {
        let tableView = articleTableView!
        // インジケータを表示
        tableView.userInteractionEnabled = false
        tableView.bounces = false
        view.frame = CGRectOffset(view.frame, 0, 40)
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.center = CGPointMake(tableView.frame.width / 2, -20)
        self.view.addSubview(indicator)
        indicator.startAnimating()
        
        subscriptions.append(ArticleModel.getInstance().get(1) >- filter {
            articles in
            articles.count > 0
        } >- subscribe(next:
            {
                articles in
                self.articles = articles
                self.articleTableView?.reloadData()
            }, error: {
                _ in

            }, completed: {
                // インジケータを非表示
                indicator.stopAnimating()
                indicator.removeFromSuperview()
                tableView.userInteractionEnabled = true
                tableView.bounces = true
                self.view.frame = CGRectOffset(self.view.frame, 0, -40)
            }
        ))
    }
    
    func fetchArticles() {
        pageIndex++
        SVProgressHUD.show()
        subscriptions.append(ArticleModel.getInstance().get(pageIndex) >- filter {
                articles in
                articles.count > 0
            } >- subscribe(next:
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