//
//  WebViewController.swift
//  ImageFeed
//
//  Created by Nikolay Kozlov on 27.07.2023.
//
import WebKit
import UIKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController {
    private struct QueryKeys {
        static let clientId = "client_id"
        static let redirectURI = "redirect_uri"
        static let responseType = "response_type"
        static let accessScope = "scope"
    }
    //MARK: - Properties
    weak var delegate: WebViewViewControllerDelegate?
    
    //MARK: - IBOutlets
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var progressView:  UIProgressView!
    
    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil
        )
        updateProgress()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        loadWebView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        webView.removeObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            context: nil
        )
    }
    
    //MARK: - Private methods
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    //MARK: - IBAtcions
    @IBAction private func didTapBackButton(_ sender: Any?) {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

private extension WebViewViewController {
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    func loadWebView() {
        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)
        urlComponents?.queryItems = [
            URLQueryItem(name: QueryKeys.clientId, value: AccessKey),
            URLQueryItem(name: QueryKeys.redirectURI, value: RedirectURI),
            URLQueryItem(name: QueryKeys.responseType, value: "code"),
            URLQueryItem(name: QueryKeys.accessScope, value: AccessScope)
        ]
        
        if let url = urlComponents?.url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func fetchCode(from navigationAction: WKNavigationAction) -> String? {
        guard
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let codeItem = urlComponents.queryItems?.first(where: { $0.name == "code"})
        else { return nil }
        
        return codeItem.value
    }
}


//MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = fetchCode(from: navigationAction) {
            decisionHandler(.cancel)
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
        } else {
            decisionHandler(.allow)
        }
    }
}
