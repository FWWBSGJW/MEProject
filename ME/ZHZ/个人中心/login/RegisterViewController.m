//
//  RegisterViewController.m
//  ME
//
//  Created by qf on 14/7/30.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "RegisterViewController.h"

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
