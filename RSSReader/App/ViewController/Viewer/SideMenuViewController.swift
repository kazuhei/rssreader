
import UIKit
import RxSwift

class SideMenuViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userDescriptionLabel: UILabel!
    
    @IBOutlet weak var menuTableView: UITableView!
    
    override func viewDidLoad() {
        menuTableView.delegate = self
        menuTableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let user = getContext().user {
            self.configureProfile(user)
        } else {
            self.configureProfile()
        }
        menuTableView.reloadData()
    }
    
    private func configureProfile() {
        userNameLabel.text = "ゲストさん"
        userDescriptionLabel.text = "ログインしてください"
        
        // 画像の読み込みはサブのスレッドで非同期に行う
        let mainQueue = dispatch_get_main_queue()
        let subQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        self.profileImage.image = ImageLoader.sharedInstance.getPlaceHolder(self.profileImage.frame.size)
        self.view.setNeedsLayout()
    }
    
    private func configureProfile(user: UserEntity) {
        userNameLabel.text = user.id
        userDescriptionLabel.text = user.userDescription
        
        // 画像の読み込みはサブのスレッドで非同期に行う
        let mainQueue = dispatch_get_main_queue()
        let subQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        dispatch_async(subQueue) {
            if let image = ImageLoader.sharedInstance.get(NSURL(string: user.profileImageUrl)!, size: self.profileImage.frame.size) {
                dispatch_async(mainQueue) {
                    self.profileImage.image = image
                    self.view.setNeedsLayout()
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = menuTableView.dequeueReusableCellWithIdentifier("Menu", forIndexPath: indexPath) as! UITableViewCell
        if let user = getContext().user {
            cell.textLabel?.text = "ログアウト"
        } else {
            cell.textLabel?.text = "ログイン"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let user = getContext().user {
            getContext().user = nil
            self.viewWillAppear(false)
        } else {
            let loginStoryBoard = UIStoryboard(name: "Login", bundle: nil)
            let loginViewController = loginStoryBoard.instantiateInitialViewController() as! UIViewController
            self.presentViewController(loginViewController, animated: true, completion: nil)
        }
    }
}
