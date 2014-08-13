//
//  EditTableViewController.m
//  ME
//
//  Created by qf on 14/8/9.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "EditTableViewController.h"
#import "PKImagePickerViewController.h"
@interface EditTableViewController ()
@property (nonatomic,strong) PKImagePickerViewController *imagePicker;
@end

@implementation EditTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imagePicker = [[PKImagePickerViewController alloc] init];
}
- (IBAction)getPic:(id)sender {
//	[self presentViewController:self.imagePicker animated:YES completion:nil];
//	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"添加图片" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"" otherButtonTitles:@"从相册选择",@"拍照", nil];
//	[actionSheet show]
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	
}

@end
