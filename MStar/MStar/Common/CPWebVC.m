//
//  CPWebVC.m
//  PhoneRetrieve
//
//  Created by wangzhangchuan on 2018/2/6.
//  Copyright © 2018年 Captain. All rights reserved.
//

#import "CPWebVC.h"
#import <WebKit/WKWebView.h>

@interface CPWebVC ()<UIWebViewDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progress;

@end

@implementation CPWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.hidesBottomBarWhenPushed = YES;
    if (self.title == nil) {
        self.title = @"购买合同";
    }

//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(replyAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fenxiang"] style:UIBarButtonItemStylePlain target:self action:@selector(replyAction:)];
//    fenxiang
//    if (self.shouldHomeItem == NO) {
//        self.navigationItem.rightBarButtonItem = nil;
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIProgressView *)progress {
    
    if (nil == _progress) {
        _progress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREENWIDTH, 100)];
        _progress.trackTintColor = UIColor.clearColor;
    }
    
    return _progress;
}

- (WKWebView *)webView {
    if (_webView == nil) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - NAV_HEIGHT)];
//        _webView.dataDetectorTypes = UIDataDetectorTypeAll;
//        _webView.backgroundColor = UIColor.whiteColor;
//        _webView.scalesPageToFit   = YES;
//
//        _webView.delegate = self;
        
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)setUrlStr:(NSString *)urlStr {
    
    _urlStr = urlStr;
    
//    {
//        NSString *html = [NSString stringWithFormat:@"<html><body><img src='%@' width=\'100%\' height='100%'></body></html>",_urlStr];
////        NSString *html = [NSString stringWithFormat:@"<img src='%@'>",_urlStr];
//
//        NSString *tempStr = [self webImageFitToDeviceSize:html.mutableCopy];
//
//        [self.webView loadHTMLString:html baseURL:nil];
//    }
    {
        
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [self.webView loadRequest:request];
    }
}

- (void)setContentStr:(NSString *)contentStr {
    
    _contentStr = [self webImageFitToDeviceSize:contentStr.mutableCopy];

//    _contentStr = contentStr;
    
    [self.webView loadHTMLString:_contentStr baseURL:nil];
}

- (NSMutableString *)webImageFitToDeviceSize:(NSMutableString *)strContent
{
    [strContent appendString:@"<html>"];
    [strContent appendString:@"<head>"];
    [strContent appendString:@"<meta charset=\"utf-8\">"];
    [strContent appendString:@"<meta id=\"viewport\" name=\"viewport\" content=\"width=device-width*0.9,initial-scale=1.0,maximum-scale=1.0,user-scalable=false\" />"];
    [strContent appendString:@"<meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />"];
    [strContent appendString:@"<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\" />"];
    [strContent appendString:@"<meta name=\"black\" name=\"apple-mobile-web-app-status-bar-style\" />"];
    [strContent appendString:@"<style>img{width:100%;}</style>"];
    [strContent appendString:@"<style>table{width:100%;}</style>"];
    [strContent appendString:@"<title>webview</title>"];
    return strContent;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.view bringSubviewToFront:self.progress];
    [self.progress setProgress:0.6 animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.progress setProgress:1 animated:YES];
    
//    获取网页title
    
//    NSString *htmlTitle = @"document.title";
//    NSString *titleHtmlInfo = [webView stringByEvaluatingJavaScriptFromString:htmlTitle];
//    [self setTitle:titleHtmlInfo];
//    if (titleHtmlInfo && titleHtmlInfo.length > 0) {
//        self.navigationItem.title = titleHtmlInfo;
//    }
//    NSString *js=@"var script = document.createElement('script');"
//    "script.type = 'text/javascript';"
//    "script.text = \"function ResizeImages() { "
//    "var myimg,oldwidth;"
//    "var maxwidth = 100%f;"
//    "for(i=0;i <document.images.length;i++){"
//    "myimg = document.images[i];"
//    "if(myimg.width > maxwidth){"
//    "oldwidth = myimg.width;"
//    "myimg.width = 100%f;"
//    "}"
//    "}"
//    "}\";"
//    "document.getElementsByTagName('head')[0].appendChild(script);";
//
//    js=[NSString stringWithFormat:js,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width-15];
//    [webView stringByEvaluatingJavaScriptFromString:js];
//    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
//
//    [self performSelector:@selector(hideProgress) withObject:nil afterDelay:1.0f];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.progress setProgress:1 animated:YES];
    [self performSelector:@selector(hideProgress) withObject:nil afterDelay:1.0f];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)hideProgress {
    [self.progress removeFromSuperview];
}

- (void)replyAction:(id)sender {
}

@end
