//
//  WKWebViews.swift
//  StockPrice
//
//  Created by Babak Rezai on 06/02/2023.
//

import WebKit

class SVGImageView: WKWebView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setStyle()
    }
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        setStyle()
    }
    
    /// A private method to set the style of the view
    private func setStyle() {
        // Disable bouncing in the scroll view
        scrollView.bounces = false
        // Disable scrolling in the scroll view
        scrollView.isScrollEnabled = false
        // Set the corner radius of the layer to half the height of the frame
        layer.cornerRadius = frame.height / 2
        // Mask the layer to its bounds
        layer.masksToBounds = true
    }
    
    /// A method to set the image of the view from a URL string.
    func setImage(withUrl url: String) {
        // Create a HTML string with a viewport meta tag and an img element
        let htmlString = "<html><head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></head><body style='margin:0;'><img src='\(url)' style='width:100%;height:100%;'/></body></html>"
        // Load the HTML string into the web view
        loadHTMLString(htmlString, baseURL: nil)
    }
}

