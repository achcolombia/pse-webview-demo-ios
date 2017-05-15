//
//  ViewController.m
//  pse-webview-demo
//
//  Created by Iván Galaz-Jeria on 5/15/17.
//  Copyright © 2017 ach. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

#define START_URL @"https://www.psepagos.co/PSEHostingUI/ShowTicketOffice.aspx?ID=4748"

@interface ViewController () <WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (weak, nonatomic) IBOutlet UIProgressView *webProgress;
@property (weak, nonatomic) IBOutlet UIView *browserNavigationContainer;
@property (weak, nonatomic) IBOutlet UIView *browserContainer;
@property (weak, nonatomic) IBOutlet UITextField *navigationInformationTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    [self configureBrowserNavigation];
    [self configureBrowser];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) configureBrowserNavigation {
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.browserNavigationContainer.bounds];
    self.browserNavigationContainer.layer.masksToBounds = NO;
    self.browserNavigationContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    self.browserNavigationContainer.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    self.browserNavigationContainer.layer.shadowOpacity = 0.5f;
    self.browserNavigationContainer.layer.shadowPath = shadowPath.CGPath;
    
}

- (void) configureBrowser {
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero
                                      configuration:[[WKWebViewConfiguration alloc]init]];
    
    [self.webView.scrollView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeInteractive];
    [self.webView setAllowsBackForwardNavigationGestures:YES];
    
    [self.webView setUIDelegate:self];
    [self.webView setNavigationDelegate:self];
    
    [self.webView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [[self browserContainer] addSubview:self.webView];
    
    [[self browserContainer] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[webView]|"
                                                                                    options:NSLayoutFormatAlignAllLeft
                                                                                    metrics:nil
                                                                                      views:@{@"webView": self.webView}]];
    [[self browserContainer] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[webView]|"
                                                                                    options:NSLayoutFormatAlignAllLeft
                                                                                    metrics:nil
                                                                                      views:@{@"webView": self.webView}]];
    
    [[self webView] addObserver:self
                     forKeyPath:@"loading"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
    [[self webView] addObserver:self
                     forKeyPath:@"estimatedProgress"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
    
    
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:START_URL]]];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    
    NSMutableAttributedString* mutableAttributedString = [self.navigationInformationTextField.attributedText mutableCopy];
    
    [mutableAttributedString.mutableString replaceCharactersInRange:NSMakeRange(0, mutableAttributedString.mutableString.length)
                                                         withString:[[webView.URL host] stringByReplacingOccurrencesOfString:@"www." withString:@""]];
    
    [self.navigationInformationTextField setAttributedText:mutableAttributedString];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if ([keyPath isEqual:@"loading"]) {
        
        NSLog(@"loading");
    } else if ([keyPath isEqual:@"estimatedProgress"]) {
        
        [[self webProgress] setHidden: self.webView.estimatedProgress == 1];
        [[self webProgress] setProgress:self.webView.estimatedProgress];
    }
}

- (IBAction)goBack:(id)sender {
    
    [self.webView goBack];
}

- (IBAction)stop:(id)sender {
    
    [self.webView stopLoading];
}

- (IBAction)reload:(id)sender {
    
    [self.webView reload];
}

- (IBAction)goForward:(id)sender {
    
    [self.webView goForward];
}
@end
