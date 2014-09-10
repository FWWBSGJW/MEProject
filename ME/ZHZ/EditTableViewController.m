
//  EditTableViewController.m
//  ME
//
//  Created by qf on 14/8/9.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "EditTableViewController.h"
#import "UserInfo.h"
#import "User.h"
#import "UIImageView+WebCache.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "EditDescriptionViewController.h"
#import "OLNetManager.h"
#import "CAlertLabel.h"
#import "AFNetworking.h"
#import "UILabel+dynamicSizeMe.h"
#define ORIGINAL_MAX_WIDTH 640.0f

#define kCommit_portrait @""
#define kCommit_info	@"http://121.197.10.159:8080/MobileEducation/modifyUser"
#define kCommit_description @"http://121.197.10.159:8080/MobileEducation/modifyUser"
@interface EditTableViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate,EditDescriptionDelegate>{
	BOOL portraitHaveChange;
	BOOL nameHaveChange;
	BOOL sexHaveChange;
	AFHTTPClient *_httpClient;
	NSOperationQueue *_queue;
}
@end

@implementation EditTableViewController

- (id)initWithUser:(User *)user
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
		_user = user;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationItem.rightBarButtonItem.title = @"编辑";
//	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getPic:)];
//    [self.portraitView addGestureRecognizer:singleTap];
	self.userNameTextFied.text = _user.info.name;
	_userNameTextFied.enabled = NO;
	_userNameTextFied.textColor = [UIColor lightGrayColor];
	if (!_user.info.sex) {
		self.femaleImage.highlighted = YES;
	}else{
		self.maleImage.highlighted = YES;
	}
	self.describtion.text = _user.info.describe;
	[self.describtion resizeToFit];
//	[self.describtion resizeToFit];
	{
        [_portraitView.layer setCornerRadius:(_portraitView.frame.size.height/2)];
        [_portraitView.layer setMasksToBounds:YES];
        [_portraitView setContentMode:UIViewContentModeScaleAspectFill];
        [_portraitView setClipsToBounds:YES];
        _portraitView.layer.shadowColor		= [UIColor blackColor].CGColor;
        _portraitView.layer.shadowOffset	= CGSizeMake(4, 4);
        _portraitView.layer.shadowOpacity	= 0.5;
        _portraitView.layer.shadowRadius	= 2.0;
        _portraitView.layer.borderColor		= [[UIColor blackColor] CGColor];
        _portraitView.layer.borderWidth		= 2.0f;
        _portraitView.userInteractionEnabled = YES;
        _portraitView.backgroundColor		= [UIColor blackColor];
	}
	[self.portraitView setImageWithURL:[NSURL URLWithString:kUrl_image(_user.info.imageUrl)]];
	portraitHaveChange	= NO;
	nameHaveChange		= NO;
	sexHaveChange		= NO;
	NSURL *url = [NSURL URLWithString:@"http://121.197.10.159:8080/"];
	_httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
	_queue = [[NSOperationQueue alloc] init];
}
//- (IBAction)getPic:(id)sender {
////	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"添加图片" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"拍照", nil];
////	[actionSheet showInView:self.view];
//	[self presentViewController:self.imagePicker animated:YES completion:nil];
//}

- (void)viewWillAppear:(BOOL)animated{
	if (!_user.info.isLogin) {
		self.navigationItem.rightBarButtonItem = nil;
	}
}

- (IBAction)selectMale:(id)sender {
	if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"编辑"]) {
		return;
	}
	self.maleImage.highlighted = YES;
	self.femaleImage.highlighted = NO;
	sexHaveChange = YES;
}
- (IBAction)selectFemale:(id)sender {
	if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"编辑"]) {
		return;
	}
	self.maleImage.highlighted = NO;
	self.femaleImage.highlighted = YES;
	sexHaveChange = YES;
}
- (void)editSet{
	if (_userNameTextFied.enabled) {
		_userNameTextFied.enabled = NO;
		self.navigationItem.rightBarButtonItem.title = @"编辑";
	}else{
		_userNameTextFied.enabled = YES;
		self.navigationItem.rightBarButtonItem.title = @"提交";
	}
}
//提交头像，性别，昵称
- (IBAction)commitChange:(id)sender {
	if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"编辑"]) {
		[self editSet];
		return;
	}
	
	
	BOOL infoResult;
	if (portraitHaveChange) {
//		NSData *imageData = UIImagePNGRepresentation(_userData.portrait);
//		NSDictionary *dic = [[OLNetManager netRequestWithUrl:kCommit_portrait andPostDataBody:imageData] objectFromJSONData];
//		portraitResult = [[dic objectForKey:@"success"] integerValue];
///MobileEducation/file/imageUpload
		NSURLRequest *request = [_httpClient multipartFormRequestWithMethod:@"POST" path:@"MobileEducation/file/imageUpload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
			NSData *imageData = UIImageJPEGRepresentation(_user.info.portrait,1);
			NSString *fileName = [NSString stringWithFormat:@"xx.jpg"];
			[formData appendPartWithFileData:imageData name:@"upload" fileName:fileName mimeType:@"image/jpeg"];
		}];
		//NSLog(@"%@",_httpClient.baseURL);
		AFHTTPRequestOperation *op =[[AFHTTPRequestOperation alloc] initWithRequest:request];
		[op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
			NSData *data = responseObject;
//			NSDictionary *dic = [data objectFromJSONData];
			NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
			NSLog(@"上传完成 %@",str);
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			NSLog(@"上传失败->%@",error);
		}];
		[_httpClient.operationQueue addOperation:op];
		
	}
	if (sexHaveChange || nameHaveChange) {
		_user.info.sex = [self.maleImage isHighlighted];
		_user.info.name = _userNameTextFied.text;
		NSString *body = [NSString stringWithFormat:@"userSex=%d&userName=%@&userAccount=%@",_user.info.sex,_user.info.name,_user.info.account];
		NSDictionary *dic = [[OLNetManager netRequestWithUrl:kCommit_info andPostBody:body] objectFromJSONData];
		infoResult = [[dic objectForKey:@"success"] boolValue];
	}
	//判断结果给出提示
	if (infoResult) {
		CAlertLabel *alert = [CAlertLabel alertLabelWithAdjustFrameForText:@"修改成功"];
		[alert showAlertLabel];
		[self editSet];
		[User sharedUser].havaChange = YES;
	}else{
		CAlertLabel *alert = [CAlertLabel alertLabelWithAdjustFrameForText:@"修改失败"];
		[alert showAlertLabel];
	}
}
/*提交个性签名*/
- (void)commitDescription:(NSString *)text{

	NSString *body = [NSString stringWithFormat:@"userSign=%@&userAccount=%@",text,_user.info.account];
	NSDictionary *dic = [[OLNetManager netRequestWithUrl:kCommit_info andPostBody:body] objectFromJSONData];
	BOOL result = [[dic objectForKey:@"success"]boolValue];
	if (result) {
		CAlertLabel *alert = [CAlertLabel alertLabelWithAdjustFrameForText:@"修改成功"];
		[alert showAlertLabel];
		_user.info.describe = text;
		_describtion.text = text;
		[_describtion resizeToFit];
	}else{
		CAlertLabel *alert = [CAlertLabel alertLabelWithAdjustFrameForText:@"修改失败"];
		[alert showAlertLabel];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	nameHaveChange = YES;
	return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"编辑"]) {
		return;
	}
	switch (indexPath.section) {
		case 0:
			[self editPortrait];
			break;
		case 2:
		{
			EditDescriptionViewController *ed = [[EditDescriptionViewController alloc] init];
			ed.textView.text = _user.info.describe;
		ed.delegate = self;
		UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ed];

			[self presentViewController:nav animated:NO completion:^{
				
			}];
		}
			break;
		default:
			break;
	}
	
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)editPortrait {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}
#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.portraitView.image = editedImage;
	_user.info.portrait = editedImage;
	portraitHaveChange = YES;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
		{
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
			{
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
			}
        else
            if (widthFactor < heightFactor)
				{
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
				}
		}
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark portraitImageView getter
//- (UIImageView *)portraitImageView {
//    if (!_portraitImageView) {
//        CGFloat w = 100.0f; CGFloat h = w;
//        CGFloat x = (self.view.frame.size.width - w) / 2;
//        CGFloat y = (self.view.frame.size.height - h) / 2;
//        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
//        [_portraitImageView.layer setCornerRadius:(_portraitImageView.frame.size.height/2)];
//        [_portraitImageView.layer setMasksToBounds:YES];
//        [_portraitImageView setContentMode:UIViewContentModeScaleAspectFill];
//        [_portraitImageView setClipsToBounds:YES];
//        _portraitImageView.layer.shadowColor = [UIColor blackColor].CGColor;
//        _portraitImageView.layer.shadowOffset = CGSizeMake(4, 4);
//        _portraitImageView.layer.shadowOpacity = 0.5;
//        _portraitImageView.layer.shadowRadius = 2.0;
//        _portraitImageView.layer.borderColor = [[UIColor blackColor] CGColor];
//        _portraitImageView.layer.borderWidth = 2.0f;
//        _portraitImageView.userInteractionEnabled = YES;
//        _portraitImageView.backgroundColor = [UIColor blackColor];
//        UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
//        [_portraitImageView addGestureRecognizer:portraitTap];
//    }
//    return _portraitImageView;
//}
@end
