
import Foundation
import UIKit
import RxSwift
import SVProgressHUD

class TagListViewController: PageViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tagListView: UITableView!
    var tags: [TagEntity] = []
    
    @IBAction func followingSwitchOnChange(sender: UISwitch, forEvent event: UIEvent) {
        // switchからタッチされたcellまで階層を遡る
        var cell = sender as UIView
        while !cell.isKindOfClass(TagCell) {
            cell = cell.superview!
        }
        
        let indexPath = tagListView.indexPathForCell(cell as! TagCell)
        if let index = indexPath?.row {
            let tag = tags[index]
            if sender.on {
                SVProgressHUD.showInfoWithStatus("タグをフォローしています")
                subscriptions.append(TagModel.getInstance().follow(tag.id) >- subscribe(next:
                    {
                        tags in
                        SVProgressHUD.showInfoWithStatus("完了しました")
                    }, error: {
                        error in
                        SVProgressHUD.showErrorWithStatus("失敗しました")
                        sender.setOn(false, animated: false)
                    }, completed: {
                        SVProgressHUD.dismiss()
                    }
                ))
            } else {
                SVProgressHUD.showInfoWithStatus("タグのフォローをやめます")
                subscriptions.append(TagModel.getInstance().unFollow(tag.id) >- subscribe(next:
                    {
                        tags in
                        SVProgressHUD.showInfoWithStatus("完了しました")
                    }, error: {
                        error in
                        SVProgressHUD.showErrorWithStatus("失敗しました")
                        sender.setOn(true, animated: false)
                    }, completed: {
                        SVProgressHUD.dismiss()
                    }
                ))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagListView.delegate = self
        tagListView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        SVProgressHUD.show()
        subscriptions.append(TagModel.getInstance().get(100) >- subscribe(next:
            {
                tags in
                self.tags = tags
                self.tagListView.reloadData()
            }, error: {
                error in
                println(error)
                SVProgressHUD.showErrorWithStatus("ロード失敗")
            }, completed: {
                SVProgressHUD.dismiss()
            }
        ))
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tag = tags[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("TagCell", forIndexPath: indexPath) as! TagCell
        cell.tagLabel.text = tag.id
        
        subscriptions.append(TagModel.getInstance().isFollowing(tag.id) >- subscribeNext({
            isFollowing in
            cell.followingSwitch.setOn(isFollowing, animated: false)
            }
        ))
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 47
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let articleSearchStoryboard = UIStoryboard(name: "ArticleSearch", bundle: nil)
        let articleSearchViewController = articleSearchStoryboard.instantiateInitialViewController() as! ArticleSearchViewController
        articleSearchViewController.keyword = tags[indexPath.row].id
        self.pushViewController = articleSearchViewController
    }
    
}