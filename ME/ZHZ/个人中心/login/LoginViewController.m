//
//  LoginViewController.m
//  Online_learning
//
//  Created by qf on 14/7/9.
//  Copyright (c) 2014年 qf. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "UserCenterTableViewController.h"
#import "User.h"
@interface LoginViewController ()
@property (nonatomic,weak) IBOutlet UITextField *usernameText;
@property (nonatomic,weak) IBOutlet UITextField *userpwdText;
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		_showCencel = YES;
    }
    return self;
}

- (id)init{
	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LoginViewController" owner:self options:nil];
	self = nib[0];
	_showCencel = YES;
	return self;
}

- (IBAction)login:(id)sender{
	User *user = [User sharedUser];
	if ([_usernameText.text  isEqualToString:@""] || [_userpwdText.text isEqualToString:@""]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"用户名和密码不能为空" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		return;
	}
	if ([user loginWith:[_usernameText text] Password:[_userpwdText text]] && !user.currentVC){
		
//		UserCenterTableViewController *utc = [[UserCenterTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
		[self.navigationController popViewControllerAnimated:YES];
		user.justLogin = YES;
	}
	
}
- (IBAction)userRegister:(id)sender {
	RegisterViewController *rvc = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:[NSBundle mainBundle]];
	[self.navigationController pushViewController:rvc animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	if (textField.tag == 1) {
		[self login:nil];
	}else{
		[_userpwdText becomeFirstResponder];
	}
	return YES;
}

- (void)cencel{
	self.tabBarController.selectedIndex = 0;
	[self.parentViewController dismissViewControllerAnimated:YES completion:^{	}];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	//键盘类型
	_usernameText.keyboardType = UIKeyboardTypeAlphabet;
//	设置边框类型：
	[_usernameText setBorderStyle:UITextBorderStyleRoundedRect];
////	设置默认文案：
//	_usernameText.placeholder = TEXT_LOGIN_NAME_PLACEHOLDER;//，给用户友好提示。
//	设置控件内容的对齐方式：
	_usernameText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//	设置首字符是否默认大写：
	_usernameText.autocapitalizationType = UITextAutocapitalizationTypeNone;
//	设置是否开启纠错提醒：
	_usernameText.autocorrectionType = UITextAutocorrectionTypeNo;
//	设置何时提供clear按钮：
	_usernameText.clearButtonMode = UITextFieldViewModeWhileEditing;
//	设置成为焦点：
	[_usernameText becomeFirstResponder];//当界面中除了输入框和登录按钮外，最好一开始就让输入框成为响应者，好让键盘遮掉空白部分。
//	设置是否密文显示：
	_userpwdText.secureTextEntry = YES;
//	设置回车键类型：
	_usernameText.returnKeyType = UIReturnKeyNext;
	_userpwdText.returnKeyType = UIReturnKeyDone;
	_usernameText.delegate = self;
	_userpwdText.delegate = self;
	_userpwdText.tag = 1;
	if (_showCencel ) {
		UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cencel)];
		self.navigationItem.leftBarButtonItem = barButton;
	}
	
	self.navigationItem.title = @"请登录";
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
