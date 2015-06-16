
import UIKit

class LoginViewController: BaseViewController {
    
    @IBAction func toAuthPage(sender: UIButton) {
        let path = NSBundle.mainBundle().pathForResource("client_id", ofType: "txt")!
        let client_id = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)!
        let qiitaAuthUrlString = "http://qiita.com/api/v2/oauth/authorize?client_id=" + client_id + "&scope=read_qiita"
        let url = NSURL(string: qiitaAuthUrlString)
        UIApplication.sharedApplication().openURL(url!)
    }
}