//
//  RegisterViewController.h
//  ME
//
//  Created by qf on 14/7/30.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
@property (nonatomic,weak) IBOutlet UITextField *accountTF;
@property (nonatomic,weak) IBOutlet UITextField	*nickNameTF;
@property (nonatomic,weak) IBOutlet UITextField *pwdTF;
@property (nonatomic,weak) IBOutlet UITextField *checkingTF;
@end
