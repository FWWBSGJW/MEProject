//
//  QAViewController.m
//  移动教育1.0
//
//  Created by yato_kami on 14-7-4.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "QAViewController.h"

@interface QAViewController ()
@property (strong, nonatomic) UIWebView *webView;
@end

@implementation QAViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"问答";
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:webView];
    webView.scalesPageToFit = YES;
    NSString *urlStr =[NSString stringWithFormat:@"%@MobileEducation/qa",kBaseURL];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    self.webView = webView;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleBordered  target:self action:@selector(webGoback)];
    self.navigationItem.leftBarButtonItem = backItem;
    
}

- (void)webGoback
{
    [self.webView goBack];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touche
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
