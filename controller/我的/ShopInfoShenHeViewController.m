//
//  ShopInfoShenHeViewController.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/11/16.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "ShopInfoShenHeViewController.h"

@interface ShopInfoShenHeViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *iv1;
@property (strong, nonatomic) IBOutlet UIImageView *iv2;
@property (strong, nonatomic) IBOutlet UIImageView *iv3;
@property (strong, nonatomic) UIImage *image1;
@property (strong, nonatomic) UIImage *image2;
@property (strong, nonatomic) UIImage *image3;
@property (strong, nonatomic) NSString *imageUrl1;
@property (strong, nonatomic) NSString *imageUrl2;
@property (strong, nonatomic) NSString *imageUrl3;


@property (strong, nonatomic) IBOutlet UITextView *tv1;
@property (strong, nonatomic) IBOutlet UITextView *tv2;
@property (strong, nonatomic) IBOutlet UITextView *tv3;
@property (strong, nonatomic) IBOutlet UILabel *placeHolderLabel1;
@property (strong, nonatomic) IBOutlet UILabel *placeHolderLabel2;
@property (strong, nonatomic) IBOutlet UILabel *placeHolderLabel3;

@end

@implementation ShopInfoShenHeViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"审核信息";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tvChanged:) name:UITextViewTextDidChangeNotification object:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(resignKeyBorad)];

}
- (void)resignKeyBorad{
    [self.iv1.superview.superview endEditing:YES];
}
- (void)tvChanged :(NSNotification *)noti{
    UITextView *tv = noti.object;
    if (tv == self.tv1) {
        if (self.tv1.text.absolute_String.length>0) {
            self.placeHolderLabel1.hidden = YES;
        }
        else{
            self.placeHolderLabel1.hidden = NO;
        }
    }
    else if (tv == self.tv2){
        if (self.tv2.text.absolute_String.length>0) {
            self.placeHolderLabel2.hidden = YES;
        }
        else{
            self.placeHolderLabel2.hidden = NO;
        }
    }
    else if (tv == self.tv3){
        if (self.tv3.text.absolute_String.length>0) {
            self.placeHolderLabel3.hidden = YES;
        }
        else{
            self.placeHolderLabel3.hidden = NO;
        }
    }
}
- (IBAction)selectImage1:(id)sender {
    [self selectPhotoIndex:1];
}
- (IBAction)selectImage2:(id)sender {
    [self selectPhotoIndex:2];
}
- (IBAction)selectImage3:(id)sender {
    [self selectPhotoIndex:3];
}
//MARK:选择图片
- (IBAction)selectPhotoIndex:(int)index {
    [self resignKeyBorad];
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    //设置照片最大选择数
    actionSheet.maxSelectCount = 1;
    actionSheet.allowSelectVideo = NO;
    actionSheet.allowSelectGif = NO;
    actionSheet.allowSelectLivePhoto = NO;
    actionSheet.navBarColor = [UIColor stylePinkColor];
    actionSheet.sender = self;
    __weak ShopInfoShenHeViewController *weakSelf = self;
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        if (images.count>0) {
            if (index ==1) {
                weakSelf.image1 = images[0];
                [self uploadImageIndex:1];
            }
            else if (index ==2){
                weakSelf.image2 = images[0];
                [self uploadImageIndex:2];
            }
            else if (index ==3){
                weakSelf.image3 = images[0];
                [self uploadImageIndex:3];
            }
        }
    }];
    //调用相册
    [actionSheet showPreviewAnimated:YES];
}
//MARK:上传营业执照
- (void)uploadImageIndex :(int)index
{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    UIImage *image;
    if (index ==1) {
        image = self.image1;
    }
    else if (index ==2){
        image = self.image2;
    }
    else if (index ==3){
        image = self.image3;
    }
    [ProgressHUD show:nil Interaction:NO];
    [TTRequestOperationManager POST:API_USER_UPLOAD_AVATAR parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:@"member_avatar" fileName:@"pic.png" mimeType:@"image/png"];
    } Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
        if ([code isEqualToString:@"1"]){
            NSString *imageUrl =[result string_ForKey:@"member_avatar"];
            if (index ==1) {
                self.imageUrl1 =imageUrl;
                self.iv1.image =self.image1;
            }
            else if (index ==2){
                self.imageUrl2 =imageUrl;
                self.iv2.image =self.image2;
            }
            else if (index ==3){
                self.imageUrl3 =imageUrl;
                self.iv3.image =self.image3;
            }
        }
        else{
            [ProgressHUD showError:msg];
        }
    } Failure:^(NSError *error) {
    }];
}
//MARK:保存
- (IBAction)save:(id)sender {
    if (self.imageUrl1.length<2||self.imageUrl2.length<2||self.imageUrl3.length<2) {
        [ProgressHUD showError:@"请上传完整图片" Interaction:NO];
        return;
    }
    if (self.tv1.text.absolute_String.length<2||self.tv2.text.absolute_String.length<2||self.tv2.text.absolute_String.length<2) {
        [ProgressHUD showError:@"请输入完整店铺介绍" Interaction:NO];
        return;
    }
    [self presentAlertWithTitle:@"确认提交？" Handler:^{
        [self saveNow];
    } Cancel:nil];
}
- (void)saveNow{
    
}
@end
