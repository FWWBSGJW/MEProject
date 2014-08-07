//
//  RegisterViewController.m
//  ME
//
//  Created by qf on 14/7/30.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "RegisterViewController.h"
#import "CAlertLabel.h"
#import "OLNetManager.h"
@interface RegisterViewController (){
	NSString *account;
	NSString *nickName;
	NSString *passWord;
	BOOL accountIsRight;
	BOOL nickNameIsRight;
	BOOL passWordIsRight;
}

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		account = nil;
		nickName = nil;
		passWord = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	_accountTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
	[_accountTF becomeFirstResponder];
	
	_pwdTF.secureTextEntry = YES;
	_checkingTF.secureTextEntry = YES;

	_accountTF.delegate = self;
	_nickNameTF.delegate = self;
	_pwdTF.delegate = self;
	_checkingTF.delegate = self;
	
	_accountTF.tag = 1;
	_nickNameTF.tag	= 2;
	_pwdTF.tag = 3;
	_checkingTF.tag = 4;
	
}
- (IBAction)userRegister:(id)sender {
	if (![_checkingTF.text length]
		|| ![_pwdTF.text length]
		|| ![_accountTF.text length]
		|| ![_nickNameTF.text length]) {
		[[CAlertLabel alertLabelWithAdjustFrameForText:@"信息不完整"] showAlertLabel];
		return;
	}
	if (![_pwdTF.text isEqualToString:_checkingTF.text]) {
		[[CAlertLabel alertLabelWithAdjustFrameForText:@"两次密码输入不一致"] showAlertLabel];
		return;
	}
	NSInteger result = [OLNetManager userRegisterWithUserName:_nickNameTF.text userAccount:_accountTF.text andUserPwd:_pwdTF.text];
	switch (result) {
		case -4:
			[[CAlertLabel alertLabelWithAdjustFrameForText:@"-4用户信息不完全"] showAlertLabel];
			break;
		case -3:
			[[CAlertLabel alertLabelWithAdjustFrameForText:@"-3昵称已存在"] showAlertLabel];
			break;
		case -2:
			[[CAlertLabel alertLabelWithAdjustFrameForText:@"-2账号已存在"] showAlertLabel];
			break;
		case 1:
		{
			UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"注册成功" message:@"欢迎使用" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			[a show];
		}
			break;
		default:
			break;
	}
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
	switch (textField.tag) {
		case 1:
			[_nickNameTF becomeFirstResponder];
			break;
		case 2:
			[_pwdTF becomeFirstResponder];
			break;
		case 3:
			[_checkingTF becomeFirstResponder];
			break;
		case 4:
			[self userRegister];
			break;
		default:
			break;
	}
	return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)showLast{
	if (!accountIsRight) {
		_accountTF.text = nil;
	}
	if (!nickNameIsRight) {
		_nickNameTF.text = nil;
	}
	_pwdTF.text = nil;
	_checkingTF.text = nil;
}

- (void)userRegister{
	account = _accountTF.text;
	nickName = _nickNameTF.text;
	passWord = _pwdTF.text;
	if (![passWord isEqualToString:_checkingTF.text]) {
		
		return ;
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
