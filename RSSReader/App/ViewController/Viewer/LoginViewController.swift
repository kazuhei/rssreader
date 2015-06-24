
import UIKit
import RxSwift

class LoginViewController: BaseViewController {
    
    @IBAction func toAuthPage(sender: UIButton) {
        let path = NSBundle.mainBundle().pathForResource("client_id", ofType: "txt")!
        let client_id = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)!
        let qiitaAuthUrlString = "http://qiita.com/api/v2/oauth/authorize?client_id=" + client_id + "&scope=read_qiita"
        let url = NSURL(string: qiitaAuthUrlString)
        UIApplication.sharedApplication().openURL(url!)
    }

    @IBAction func dummyLogin(sender: UIButton) {
        subscriptions.append(UserModel.getInstance().get("kazuhei0108") >- filter { userArray in userArray.count == 1 }
            >- subscribe(next: {
                    user in
                    self.getContext().user = user[0]
                }, error: {
                    error in
                    // エラー処理
                }, completed: {
                    self.dismissViewControllerAnimated(false, completion: nil)
                }
        ))
    }
    
    @IBAction func toPreviousPage(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}