
import UIKit
import RxSwift

class SideMenuViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let menus: [String] = ["menu1", "menu2", "menu3"]
    
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
        subscriptions.append(UserModel.getInstance().get("kazuhei0108") >- filter { userArray in userArray.count == 1 }
        >- subscribeNext {
            user in
            self.configureProfile(user[0])
        })
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
        return menus.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = menuTableView.dequeueReusableCellWithIdentifier("Menu", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = menus[indexPath.row]
        
        return cell
    }
}
