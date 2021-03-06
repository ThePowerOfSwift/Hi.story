//
//  FeedViewController.swift
//  Hi.story
//
//  Created by bl4ckra1sond3tre on 03/10/2016.
//  Copyright © 2016 bl4ckra1sond3tre. All rights reserved.
//

import UIKit
import WebKit
import Hikit

final class FeedViewController: BaseViewController {
    
    var viewModel: FeedViewModel?
    
    fileprivate var messageHandlerName = "FeedHandler"
    
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.add(self, name: self.messageHandlerName)
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.allowsLinkPreview = true
        webView.navigationDelegate = self
        webView.uiDelegate = self
        //webView.scrollView.contentInset.top = 64.0
        
        return webView
    }()
    
    private lazy var detailsItem: UIBarButtonItem = UIBarButtonItem()
    
    private var popoverTransitioningDelegate: PopoverTransitioningDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsItem.image = UIImage.hi.navDetails
        navigationItem.rightBarButtonItem = detailsItem
        
        detailsItem.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.showsDetails()
            })
            .addDisposableTo(disposeBag)
        
        setupWebView()
        
        display()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupWebView() {
        
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        let views: [String: Any] = [
            "webView": webView,
        ]
        
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[webView]|", options: [], metrics: nil, views: views)
        
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[webView]|", options: [], metrics: nil, views: views)
        
        NSLayoutConstraint.activate(hConstraints)
        NSLayoutConstraint.activate(vConstraints)
    }
    
    private func showsDetails() {
        guard let viewModel = viewModel, let story = viewModel.feed.story else { return }
        
        let viewController = Storyboard.details.viewController(of: DetailsViewController.self)
        viewController.viewModel = DetailsViewModel(story: story)
        
        viewController.showsLocationAction = { [weak self] location in
            self?.hi.open(location)
        }
        
        viewController.modalPresentationStyle = .custom
        viewController.modalTransitionStyle = .crossDissolve
        
        let size: CGSize
        if story.location != nil {
            size = CGSize(width: view.bounds.width - 70.0, height: 300.0)
        } else {
            size = CGSize(width: view.bounds.width - 80.0, height: 250.0)
        }
        
        let shadowAlpha: CGFloat = (webView.scrollView.contentOffset.y > (view.bounds.height / 2.0) || story.attachment == nil) ? 0.3 : 0.4
        
        let shadow = PopoverPresentationShadow(radius: 32.0, color: UIColor.black.withAlphaComponent(shadowAlpha))
        let context = PopoverPresentationContext(presentedContentSize: size, cornerRadius: 16.0, chromeAlpha: 0.0, shadow: shadow)
        self.popoverTransitioningDelegate = PopoverTransitioningDelegate(presentationContext: context)
        
        viewController.transitioningDelegate = popoverTransitioningDelegate
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    private func display() {
        
        guard let feed = viewModel?.feed, let story = feed.story else { return }
        
        title = story.title
    
        display(story: story)
    }
    
    private func display(story: Story) {
        
        let html: String
        
        var markdown = Markdown()
        let outputHtml: String = markdown.transform(story.body)
        
        if let attachment = story.attachment, let imageData = CacheService.shared.retrieveImageInDiskCache(forKey: attachment.urlString) {
           
            let base64 = UIImageJPEGRepresentation(imageData, 1.0)?.base64EncodedString(options: .lineLength64Characters)
            
            let metadata = "data:image/png;base64,\(base64!)"
            html = header() + "<body><div><img src=\"\(metadata)\" /></div><article></h1><p>\(outputHtml)</p></article>" + dateContent(with: story.createdAt) + footer
        } else {
            html = header() + "<body><article><p>\(outputHtml)</p></article>" + dateContent(with: story.createdAt) + footer
        }
        
        webView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
    }
    
    private func header(forTheme theme: String = "k") -> String {
        let begin = "<html><head><title></title><meta charset='utf-8'><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no\"><style>"
        
        let end = "</style></head>"
        
        return begin + (styles(forTheme: theme) ?? "") + end
    }
    
    private var footer: String {
        return "</body></html>"
    }
    
    private func dateContent(with interval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: interval).hi.monthDayYear
        return "<div style=\"text-align:center;height:120px;margin-top:80px;color:#a8a8a8;font-size:12px\">\(date)</div>"
    }
    
    private func styles(forTheme theme: String) -> String? {
        if let url = Bundle.main.path(forResource: theme, ofType: "css").flatMap({ URL(fileURLWithPath: $0) }), let contents = try? String(contentsOf: url, encoding: .utf8) {
            return contents
        } else {
            return nil
        }
    }
}

extension FeedViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
}

extension FeedViewController: WKNavigationDelegate {
    
    
}

extension FeedViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if message.name == messageHandlerName {
            
        }
        print(message.name)
        print(message.body)
    }
}
