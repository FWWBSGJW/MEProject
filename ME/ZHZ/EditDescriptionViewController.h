//
//  EditDesctiptionViewController.h
//  ME
//
//  Created by qf on 14/8/15.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditDescriptionDelegate <NSObject>

- (void)commitDescription:(NSString *)text;

@end

@interface EditDescriptionViewController : UIViewController<UITextViewDelegate>
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic) id<EditDescriptionDelegate> delegate;
@end
