//
//  ShopInfoShenHeViewController.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/11/16.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "ShopInfoShenHeViewController.h"
/*
 当前页面变化的控件比较多，为统一减少代码，对于可能会变化的控件，在xib中默认统一为隐藏（Hidden = YES）,contentView的用户交互默认为NO
 */
@interface ShopInfoShenHeViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *shenhezhongView;//上传成功之后，如果在审核中，则显示此View

@property (strong, nonatomic) IBOutlet UIImageView *iv_head;//新增加的门头照片
@property (strong, nonatomic) IBOutlet UIImageView *iv1;
@property (strong, nonatomic) IBOutlet UIImageView *iv2;
@property (strong, nonatomic) IBOutlet UIImageView *iv3;

@property (strong, nonatomic) UIImage *image_head;
@property (strong, nonatomic) UIImage *image1;
@property (strong, nonatomic) UIImage *image2;
@property (strong, nonatomic) UIImage *image3;

@property (strong, nonatomic) NSString *imageUrl_head;
@property (strong, nonatomic) NSString *imageUrl1;
@property (strong, nonatomic) NSString *imageUrl2;
@property (strong, nonatomic) NSString *imageUrl3;

@property (strong, nonatomic) IBOutlet UITextView *tv_head;
@property (strong, nonatomic) IBOutlet UITextView *tv1;
@property (strong, nonatomic) IBOutlet UITextView *tv2;
@property (strong, nonatomic) IBOutlet UITextView *tv3;

@property (strong, nonatomic) IBOutlet UILabel *placeHolderLabel_head;
@property (strong, nonatomic) IBOutlet UILabel *placeHolderLabel1;
@property (strong, nonatomic) IBOutlet UILabel *placeHolderLabel2;
@property (strong, nonatomic) IBOutlet UILabel *placeHolderLabel3;
@property (strong, nonatomic) IBOutlet UILabel *rejectReasonLabel;//审核未通过的原因

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
//MARK:获取店铺信息
- (void)loadShopInfo{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    [para setObject:@"pending" forKey:@"type"];
    [ProgressHUD show:nil Interaction:NO];
    [TTRequestOperationManager POST:API_GET_SHOP_PRODUCT_INFO Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
        if ([code isEqualToString:@"200"]){
            [self switchUIHiddenWithInfo:result];
            [ProgressHUD dismiss];
        }
        else{
            [ProgressHUD showError:msg];
        }
    } Failure:^(NSError *error) {
    }];
}
//根据状态status，选择需要显示和隐藏的控件
- (void)switchUIHiddenWithInfo:(NSDictionary *)info{
    //type=pending时:1：待审核2：审核通过9：未上传信息 ；0未通过 type=其他值时:不存在
    NSInteger state = [[info string_ForKey:@"state"] integerValue];
    //待审核
    if (state ==1) {
        self.shenhezhongView.hidden = NO;
    }
    //审核通过，显示已上传的信息
    else if (state ==2){
        self.scrollView.hidden = NO;
        [self updateInfoUI:info];
    }
    //未上传信息
    else if (state ==9){
        self.scrollView.hidden = NO;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(resignKeyBorad)];
    }
    //未通过
    else if (state ==0){
        self.scrollView.hidden = NO;
        self.rejectReasonLabel.hidden = NO;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(resignKeyBorad)];
        [self updateInfoUI:info];
    }
}
- (void)updateInfoUI:(NSDictionary *)info{
    //头图
    NSString *head_img = [info string_ForKey:@"head_img"];
    [self.iv_head sd_setImageWithURL:[NSURL URLWithString:head_img] placeholderImage:PLACEHOLDER_GENERAL];
    self.tv_head.text =[info string_ForKey:@"introduction"];
    //主图
    NSString *imageUrl_1 = [info string_ForKey:@"image"];
    [self.iv1 sd_setImageWithURL:[NSURL URLWithString:imageUrl_1] placeholderImage:PLACEHOLDER_GENERAL];
    self.tv1.text =[info string_ForKey:@"desc"];
    //副图1
    NSString *imageUrl_2 = [info string_ForKey:@"image2"];
    [self.iv_head sd_setImageWithURL:[NSURL URLWithString:imageUrl_2] placeholderImage:PLACEHOLDER_GENERAL];
    self.tv_head.text =[info string_ForKey:@"desc2"];
    //副图2
    NSString *imageUrl_3 = [info string_ForKey:@"image3"];
    [self.iv_head sd_setImageWithURL:[NSURL URLWithString:imageUrl_3] placeholderImage:PLACEHOLDER_GENERAL];
    self.tv_head.text =[info string_ForKey:@"desc3"];
    self.rejectReasonLabel.text =[info string_ForKey:@"check_remark"];//审核意见（审核不通过的原因）
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
    else if (tv == self.tv_head){
        if (self.tv_head.text.absolute_String.length>0) {
            self.placeHolderLabel_head.hidden = YES;
        }
        else{
            self.placeHolderLabel_head.hidden = NO;
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
//MARK:门头照片
- (IBAction)selectImageHead:(id)sender {
    [self selectPhotoIndex:10];
}
//MARK:选择图片
- (void)selectPhotoIndex:(int)index {
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
            else if (index ==10){
                weakSelf.image_head = images[0];
                [self uploadImageIndex:10];
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
    else if (index ==10){
        image = self.image_head;
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
            else if (index ==10){
                self.imageUrl_head =imageUrl;
                self.iv_head.image =self.image_head;
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
    if (self.imageUrl1.length<2||self.imageUrl2.length<2||self.imageUrl3.length<2||self.imageUrl_head.length<2) {
        [ProgressHUD showError:@"请上传完整介绍图片" Interaction:NO];
        return;
    }
    if (self.tv1.text.absolute_String.length<2||self.tv2.text.absolute_String.length<2||self.tv2.text.absolute_String.length<2||self.tv_head.text.absolute_String.length<2) {
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
    [para setObject:self.imageUrl_head forKey:@"head_img"];

    [para setObject:self.tv1.text forKey:@"desc"];
    [para setObject:self.tv2.text forKey:@"desc2"];
    [para setObject:self.tv3.text forKey:@"desc3"];
    [para setObject:self.tv_head.text forKey:@"introduction"];

    [ProgressHUD show:nil Interaction:NO];
    [TTRequestOperationManager POST:API_USER_UPLOAD_INFORMATION_PRODUCT Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        if ([code isEqualToString:@"200"]){
            [ProgressHUD showSuccess:msg Interaction:NO];
            //提交成功之后，会获取state，该state等效于登录接口中的state
            NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
            NSString *state = [result string_ForKey:@"state"];
            NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithDictionary:[TTUserInfoManager userInfo]];
            [userinfo setObject:state forKey:@"state"];
            [TTUserInfoManager setUserInfo:userinfo];
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
