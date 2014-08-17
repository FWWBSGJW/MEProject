//
//  EditDesctiptionViewController.m
//  ME
//
//  Created by qf on 14/8/15.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "EditDescriptionViewController.h"
#import "CAlertLabel.h"
@interface EditDescriptionViewController ()

@end

@implementation EditDescriptionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
		_textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320,SCREEN_HEIGHT-64 - 142)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveDescription)];
	self.navigationItem.rightBarButtonItem = save;
	self.navigationController.navigationBarHidden = NO;
	UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
	self.navigationItem.leftBarButtonItem = cancel;
	_textView.font = [UIFont systemFontOfSize:17];
//	_textView.textColor = [UIColor lightGrayColor];
	[self.view addSubview:_textView];
}

- (void)textViewDidChange:(UITextView *)textView{
	if (textView.text.length >=200) {
		CAlertLabel *alert = [CAlertLabel alertLabelWithAdjustFrameForText:@"字数不能超过100"];
		[alert showAlertLabel];
	}
}


- (void)cancel{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveDescription{
	if (_textView.text.length >=200) {
		CAlertLabel *alert = [CAlertLabel alertLabelWithAdjustFrameForText:@"字数不能超过200"];
		[alert showAlertLabel];
	}else{
		[self dismissViewControllerAnimated:YES completion:nil];
		[self.delegate commitDescription:_textView.text];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
