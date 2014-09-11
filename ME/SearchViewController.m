//
//  SearchViewController.m
//  ME
//
//  Created by yato_kami on 14-8-15.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//


#import "SearchViewController.h"

enum{
    SearchType_Baidu = 0,
    SearchType_Course,
    SearchType_User
};

@interface SearchViewController ()

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation SearchViewController

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64.0, SCREEN_WIDTH, SCREEN_HEIGHT-64-44)];
        _webView.scalesPageToFit = YES;
    }
    return _webView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"搜索";
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.toolBar.frame = CGRectMake(0, SCREEN_HEIGHT-44.0, SCREEN_WIDTH, 44.0);
    [self.view addSubview:self.toolBar];
    [self.searchButton addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)search
{
    [self.searchTextField resignFirstResponder];
    if (self.searchTextField.text.length>0) {
        switch (self.segementControl.selectedSegmentIndex) {
//在这边扩展
            case SearchType_Baidu:
            {
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.baidu.com/s?wd=%@",self.searchTextField.text]]];
                [self.webView loadRequest:request];
                [self.view addSubview:self.webView];
            }
                break;
             
            case SearchType_Course:
            {
                //搜索课程
                
            }
                break;
            case  SearchType_User:
            {
                //搜索用户
            }
                break;
            default:
                break;
        }
    }else{
        self.searchTextField.placeholder = @"输入内容才能搜索!";
    }
}

- (IBAction)webBack:(id)sender {
    if (self.segementControl.selectedSegmentIndex == SearchType_Baidu) {
        [self.webView goBack];
    }
}

- (IBAction)webGo:(id)sender {
    if (self.segementControl.selectedSegmentIndex == SearchType_Baidu) {
        [self.webView goForward];
    }
}

- (IBAction)webHome:(id)sender {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    [self.webView loadRequest:request];
}

- (IBAction)webRefresh:(id)sender {
    if (self.segementControl.selectedSegmentIndex == SearchType_Baidu) {
        [self.webView reload];
    }
}
@end
