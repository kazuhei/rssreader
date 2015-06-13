
import Foundation
import UIKit

class TagListViewController: PageViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var tagListView: UICollectionView!
    var tags: [TagEntity] = []
    
    override func viewDidLoad() {
        tagListView.delegate = self
        tagListView.dataSource = self
        self.addModelObserve(TagModel.getInstance(), forKeyPath: "tags", options: .New, context: nil){
            self.tags = TagModel.getInstance().tags
            self.tagListView.reloadData()
        }
        TagModel.getInstance().get(100)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = tagListView.dequeueReusableCellWithReuseIdentifier("TagCell", forIndexPath: indexPath) as! TagCell
        cell.configure(tags[indexPath.row])
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        tagListView.deselectItemAtIndexPath(indexPath, animated: false)
        let articleSearchStoryboard = UIStoryboard(name: "ArticleSearch", bundle: nil)
        let articleSearchViewController = articleSearchStoryboard.instantiateInitialViewController() as! ArticleSearchViewController
        articleSearchViewController.keyword = tags[indexPath.row].id
        self.pushViewController = articleSearchViewController
    }
}