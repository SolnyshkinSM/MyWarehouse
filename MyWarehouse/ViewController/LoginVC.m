//
//  LoginVC.m
//  MyWarehouse
//
//  Created by Administrator on 25.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import "LoginVC.h"

#import <WebKit/WebKit.h>

#import "AccessToken.h"

@interface LoginVC () <WKNavigationDelegate>

@property (weak, nonatomic) WKWebView *webView;
@property (copy, nonatomic) LoginCompletionBlock completionBlock;

@end

@implementation LoginVC

- (instancetype)initWithCompletionBlock:(LoginCompletionBlock) completionBlock {
    self = [super init];
    if (self) {
        self.completionBlock = completionBlock;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configureView];
    
    [self loadRequestInView:self.webView];
    
}
#pragma mark - Configure

- (void)configureView {
    
    CGRect rectView = self.view.bounds;
    rectView.origin = CGPointZero;
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:rectView];
    
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:webView];
    
    self.webView = webView;
    self.webView.navigationDelegate = self;
    
}

#pragma mark - Actions

- (void)loadRequestInView:(WKWebView *) webView {
    
    NSString *urlString = @"https://oauth.vk.com/authorize?"
    "client_id=7497813&"
    "display=mobile&"
    "redirect_uri=https://oauth.vk.com/blank.html&"
    "scope=139286&"
    "response_type=token&"
    "v=5.107&"
    "state=123456";
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    [webView loadRequest:request];
    
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURL *urlRequest = navigationAction.request.URL;
    
    if ([[urlRequest description] rangeOfString:@"#access_token"].location != NSNotFound) {
        
        AccessToken *accessToken = [[AccessToken alloc] init];
        
        NSString *query = [urlRequest description];
        
        NSArray *separatedArray = [query componentsSeparatedByString:@"#"];
        
        if ([separatedArray count] > 1) {
            
            query = [separatedArray lastObject];
            
            NSArray *pairs = [query componentsSeparatedByString:@"&"];
            
            for (NSString *pair in pairs) {
                
                NSArray *keyValueArray = [pair componentsSeparatedByString:@"="];
                
                NSString *key = [keyValueArray firstObject];
                
                if ([key isEqualToString:@"access_token"]) {
                    accessToken.token = [keyValueArray lastObject];
                } else if ([key isEqualToString:@"expires_in"]) {
                    NSString *timeInterval = (NSString*)[keyValueArray lastObject];
                    accessToken.expirationDate = [NSDate dateWithTimeIntervalSinceNow:timeInterval.doubleValue];
                } else if ([key isEqualToString:@"user_id"]) {
                    accessToken.userID = [keyValueArray lastObject];
                }
            }
        }
        
        self.webView.navigationDelegate = nil;
        
        if (self.completionBlock) {
            self.completionBlock(accessToken);
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
    //NSThread
    if ([[NSThread currentThread] isMainThread]) {
        NSThread *thread = [[NSThread alloc] initWithBlock:^{
            decisionHandler(WKNavigationActionPolicyAllow);
        }];
        [thread start];
    }
    
}

@end
