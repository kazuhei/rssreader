import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    var url: NSURL?
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        
        // ページの読み込み
        if let url = self.url {
            let request: NSURLRequest = NSURLRequest(URL: url)
            webView.loadRequest(request)
        }
    }
    
    @IBAction func goBack(sender: UIBarButtonItem) {
        webView.goBack()
    }

    @IBAction func goForward(sender: UIBarButtonItem) {
        webView.goForward()
    }
}