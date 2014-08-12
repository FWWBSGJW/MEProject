//
//  QAViewController.m
//  移动教育1.0
//
//  Created by yato_kami on 14-7-4.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "QAViewController.h"
#import "User.h"
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
	[_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
	[_webView reload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"问答";
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    webView.scalesPageToFit = YES;
	NSInteger userid = [User sharedUser].info.userId;
    NSString *urlStr =[NSString stringWithFormat:@"%@MobileEducation/qa?userId=%li",kBaseURL,userid];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    self.webView = webView;
	[self.view addSubview:self.webView];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleBordered  target:self action:@selector(webGoback)];
    self.navigationItem.leftBarButtonItem = backItem;
    
}

- (void)webGoback
{
	if (![_url isEqualToString:[NSString stringWithFormat:@"%@MobileEducation/qa",kBaseURL]]) {
		_url = [NSString stringWithFormat:@"%@MobileEducation/qa",kBaseURL];
		[_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
		[_webView reload];
		return;
	}

	
    [self.webView goBack];
}

+ (instancetype)shareQA{
	static QAViewController *qa = nil;
	@synchronized(self){
		if (!qa) {
			qa = [[QAViewController alloc] init];
		}
	}
	return qa;
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
