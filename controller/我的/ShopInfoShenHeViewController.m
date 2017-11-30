//
//  ShopInfoShenHeViewController.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/11/16.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "ShopInfoShenHeViewController.h"

@interface ShopInfoShenHeViewController ()
@property (strong, nonatomic) IBOutlet UIView *contentView;

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

@property (strong, nonatomic) IBOutlet UILabel *uploadTipLabel1;
@property (strong, nonatomic) IBOutlet UILabel *uploadTipLabel2;
@property (strong, nonatomic) IBOutlet UILabel *uploadTipLabel3;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation ShopInfoShenHeViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"审核信息";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tvChanged:) name:UITextViewTextDidChangeNotification object:nil];
    [self loadShopInfo];
}
//MARK:获取店铺信息-不可修改信息
- (void)loadShopInfo{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    [ProgressHUD show:nil Interaction:NO];
    [TTRequestOperationManager POST:API_GET_SHOP_PRODUCT_INFO Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
        if ([code isEqualToString:@"200"]){
            [ProgressHUD dismiss];
            [self updateInfoUI:result];
        }
        else{
            [ProgressHUD showError:msg];
        }
    } Failure:^(NSError *error) {
    }];
}
- (void)updateInfoUI:(NSDictionary *)info{
    //    "state": "string,1待审核2审核通过0未通过",
    NSString *state = [info string_ForKey:@"state"];
    //页面默认为不可交互
    if ([state isEqualToString:@"1"]||[state isEqualToString:@"2"]) {
        //待审核或者审核通过状态下，将已经上传过的信息赋值到当前页面
        NSString *image1 = [info string_ForKey:@"image"];//
        [self.iv1 sd_setImageWithURL:[NSURL URLWithString:image1] placeholderImage:PLACEHOLDER_GENERAL];
        NSString *image2 = [info string_ForKey:@"image2"];//
        [self.iv2 sd_setImageWithURL:[NSURL URLWithString:image2] placeholderImage:PLACEHOLDER_GENERAL];
        NSString *image3 = [info string_ForKey:@"image3"];//
        [self.iv3 sd_setImageWithURL:[NSURL URLWithString:image3] placeholderImage:PLACEHOLDER_GENERAL];
        self.tv1.text = [info string_ForKey:@"desc"];
        self.tv2.text = [info string_ForKey:@"desc2"];
        self.tv3.text = [info string_ForKey:@"desc3"];
        self.placeHolderLabel1.hidden = YES;
        self.placeHolderLabel2.hidden = YES;
        self.placeHolderLabel3.hidden = YES;
        if ([state isEqualToString:@"1"]){
            //待审核
            self.saveBtn.hidden = NO;
            self.saveBtn.enabled = NO;//待审核
        }
    }
    else{
        //若未上传过此页面信息，则打开交互，显示保存按钮
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(resignKeyBorad)];
        self.contentView.userInteractionEnabled = YES;
        self.uploadTipLabel1.hidden = NO;
        self.uploadTipLabel2.hidden = NO;
        self.uploadTipLabel3.hidden = NO;
        self.saveBtn.hidden = NO;
    }
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
    [TTRequestOperationManager POST:API_USER_UPLOAD_IMAGE parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:@"image" fileName:@"pic.png" mimeType:@"image/png"];
    } Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
        if ([code isEqualToString:@"200"]){
            NSString *imageUrl =[result string_ForKey:@"file"];
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
            [ProgressHUD dismiss];
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
        [ProgressHUD showError:@"请上传完整介绍图片" Interaction:NO];
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
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    [para setObject:self.imageUrl1 forKey:@"image"];
    [para setObject:self.imageUrl2 forKey:@"image2"];
    [para setObject:self.imageUrl3 forKey:@"image3"];
    [para setObject:self.tv1.text forKey:@"desc"];
    [para setObject:self.tv2.text forKey:@"desc2"];
    [para setObject:self.tv3.text forKey:@"desc3"];
    [ProgressHUD show:nil Interaction:NO];
    [TTRequestOperationManager POST:API_USER_UPLOAD_INFORMATION_PRODUCT Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        if ([code isEqualToString:@"200"]){
            [ProgressHUD showSuccess:msg Interaction:NO];
            [self performSelector:@selector(successBack) withObject:nil afterDelay:1.2];
        }
        else{
            [ProgressHUD showError:msg];
        }
        
    } Failure:^(NSError *error) {
        
    }];
}
- (void)successBack{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
