import UIKit
import WebKit

class NativeWebViewController: UIViewController, WKNavigationDelegate {

    static let sharedProcessPool = WKProcessPool()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    var webView: WKWebView!
    var urlString: String = ""
    var titleString: String = ""
    var closeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupWebView()
        setupDraggableCloseButton()
    }

    func setupWebView() {
        let config = WKWebViewConfiguration()
        config.processPool = NativeWebViewController.sharedProcessPool
        config.preferences.javaScriptEnabled = true
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []

        view.backgroundColor = .black

        webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        if urlString.hasPrefix("http://") || urlString.hasPrefix("https://"),
           let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        } else {
            webView.loadHTMLString(urlString, baseURL: nil)
        }
    }

    func setupDraggableCloseButton() {
        closeButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(named: "close_icon"), for: .normal)
        closeButton.backgroundColor = .clear
        closeButton.frame = CGRect(x: 20, y: 100, width: 48, height: 48)
        closeButton.imageView?.contentMode = .scaleAspectFit

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag(_:)))
        closeButton.addGestureRecognizer(panGesture)

        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)
    }

    @objc func handleDrag(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        if let button = gesture.view {
            var newCenter = CGPoint(x: button.center.x + translation.x,
                                    y: button.center.y + translation.y)
            newCenter.x = max(button.frame.width / 2, min(view.bounds.width - button.frame.width / 2, newCenter.x))
            newCenter.y = max(button.frame.height / 2 + 40, min(view.bounds.height - button.frame.height / 2, newCenter.y))
            button.center = newCenter
        }
        gesture.setTranslation(.zero, in: view)
    }

    /// ✅ 加了回调的缓存清理方法
    func clearWebViewCache(completion: @escaping () -> Void) {
        let dataStore = WKWebsiteDataStore.default()
        let types = WKWebsiteDataStore.allWebsiteDataTypes()
        dataStore.fetchDataRecords(ofTypes: types) { records in
            dataStore.removeData(ofTypes: types, for: records) {
                print("✅ WKWebView 缓存已清理")
                completion()
            }
        }
    }

    @objc func closeButtonTapped() {
        let alertView = CustomExitAlertView(title: "退出\(titleString)")
        alertView.onCancel = {
            // do nothing
        }
        alertView.onConfirm = {
            self.clearWebViewCache {
                self.dismiss(animated: true, completion: nil)
            }
        }

        // ✅ 兼容 iOS 13 以下
        if #available(iOS 13.0, *) {
            if let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow }) {
                window.addSubview(alertView)
            }
        } else {
            if let window = UIApplication.shared.keyWindow {
                window.addSubview(alertView)
            }
        }
    }

}