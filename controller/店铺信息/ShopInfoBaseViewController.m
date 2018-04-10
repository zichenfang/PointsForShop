//
//  ShopInfoBaseViewController.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/11/16.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "ShopInfoBaseViewController.h"
#import "TTNormalPickerView.h"
#import "TTNormalPickerItem.h"
/*
 当前页面变化的控件比较多，为统一减少代码，对于可能会变化的控件，在xib中默认统一为隐藏（Hidden = YES）,contentView的用户交互默认为NO
 */
@interface ShopInfoBaseViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *shenhezhongView;//上传成功之后，如果在审核中，则显示此View
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIImageView *zhizhaoIV;
@property (strong, nonatomic) IBOutlet UIImageView *xukezhengIV;
@property (strong, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *recmondFromTF;//推荐来源
@property (strong, nonatomic) IBOutlet UIView *workerView;//推荐来源选择业务员或者好友的时候，显示此View
@property (strong, nonatomic) IBOutlet UITextField *workerNOTF;//业务员编号
//／／data
@property (strong, nonatomic) UIImage *zhizhaoImage;//执照图片预上传
@property (strong, nonatomic) NSString *zhizhaoImageUrl;//执照图片地址

@property (strong, nonatomic) UIImage *xukezhengImage;//许可证图片预上传
@property (strong, nonatomic) NSString *xukezhengImageUrl;//执照图片地址

@property (strong, nonatomic) NSMutableArray *recommendFromDatas;//推荐来源
@property (strong, nonatomic) TTNormalPickerItem *recommendItem;//推荐来源选中
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) IBOutlet UILabel *uploadTipLabel1;
@property (strong, nonatomic) IBOutlet UILabel *uploadTipLabel2;
@property (strong, nonatomic) IBOutlet UILabel *rejectReasonLabel;//审核未通过的原因

@end

@implementation ShopInfoBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"基本信息";
    self.shopNameLabel.text = [[TTUserInfoManager userInfo] string_ForKey:@"name"];
    [self loadShopInfo];
}
//MARK:获取店铺信息-不可修改信息
- (void)loadShopInfo{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    [para setObject:@"pending" forKey:@"type"];
    [ProgressHUD show:nil Interaction:NO];
    [TTRequestOperationManager POST:API_GET_SHOP_CANNOT_CHANGE_INFO Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
        if ([code isEqualToString:@"200"]){
            [ProgressHUD dismiss];
            [self switchUIHiddenWithInfo:result];
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
        self.uploadTipLabel1.hidden = NO;
        self.uploadTipLabel2.hidden = NO;
        self.saveBtn.hidden = NO;
        self.contentView.userInteractionEnabled = YES;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(resignKeyBorad)];
    }
    //未通过
    else if (state ==0){
        self.scrollView.hidden = NO;
        self.uploadTipLabel1.hidden = NO;
        self.uploadTipLabel2.hidden = NO;
        self.saveBtn.hidden = NO;
        self.rejectReasonLabel.hidden = NO;
        self.contentView.userInteractionEnabled = YES;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(resignKeyBorad)];
        [self updateInfoUI:info];
    }
}
- (void)updateInfoUI:(NSDictionary *)info{
    //将已经上传过的信息赋值到当前页面
    NSString *business_license = [info string_ForKey:@"business_license"];//营业执照
    [self.zhizhaoIV sd_setImageWithURL:[NSURL URLWithString:business_license] placeholderImage:PLACEHOLDER_GENERAL];
    NSString *business_permit = [info string_ForKey:@"business_permit"];//许可证
    [self.xukezhengIV sd_setImageWithURL:[NSURL URLWithString:business_permit] placeholderImage:PLACEHOLDER_GENERAL];
    NSString *source =[info string_ForKey:@"source"];//推荐来源 中文描述
    self.recmondFromTF.text = source;
    if ([source isEqualToString:@"业务员"]) {
        self.workerView.hidden = NO;
        self.workerNOTF.text = [info string_ForKey:@"recommend_admin"];
    }
    else if ([source isEqualToString:@"好友推荐"]){
        self.workerView.hidden = NO;
        self.workerNOTF.text = [info string_ForKey:@"recommend_phone"];
    }
    self.rejectReasonLabel.text =[info string_ForKey:@"check_remark"];//审核意见（审核不通过的原因）
}
- (void)resignKeyBorad{
    [self.zhizhaoIV.superview endEditing:YES];
}
//MARK:营业执照
- (IBAction)zhizhaoPhoto:(id)sender {
    [self resignKeyBorad];
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    //设置照片最大选择数
    actionSheet.maxSelectCount = 1;
    actionSheet.allowSelectVideo = NO;
    actionSheet.allowSelectGif = NO;
    actionSheet.allowSelectLivePhoto = NO;
    actionSheet.navBarColor = [UIColor stylePinkColor];
    actionSheet.sender = self;
    __weak ShopInfoBaseViewController *weakSelf = self;
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        if (images.count>0) {
            weakSelf.zhizhaoImage = images[0];
            [self uploadZhiZhaoImage];
        }
    }];
    //调用相册
    [actionSheet showPreviewAnimated:YES];
}
//MARK:上传营业执照
- (void)uploadZhiZhaoImage{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    [ProgressHUD show:nil Interaction:NO];
    [TTRequestOperationManager POST:API_USER_UPLOAD_IMAGE parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(self.zhizhaoImage) name:@"image" fileName:@"pic.png" mimeType:@"image/png"];
    } Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
        if ([code isEqualToString:@"200"]){
            self.zhizhaoImageUrl = [result string_ForKey:@"file"];
            self.zhizhaoIV.image =self.zhizhaoImage;
            [ProgressHUD dismiss];
        }
        else{
            [ProgressHUD showError:msg];
        }
    } Failure:^(NSError *error) {
    }];
}
//MARK:许可证
- (IBAction)xukezhengPhoto:(id)sender {
    [self resignKeyBorad];
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    //设置照片最大选择数
    actionSheet.maxSelectCount = 1;
    actionSheet.allowSelectVideo = NO;
    actionSheet.allowSelectGif = NO;
    actionSheet.allowSelectLivePhoto = NO;
    actionSheet.navBarColor = [UIColor stylePinkColor];
    actionSheet.sender = self;
    __weak ShopInfoBaseViewController *weakSelf = self;
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        if (images.count>0) {
            weakSelf.xukezhengImage = images[0];
            [self uploadXuKeZhengImage];
        }
    }];
    //调用相册
    [actionSheet showPreviewAnimated:YES];
}
//MARK:上传营业执照
- (void)uploadXuKeZhengImage
{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    [ProgressHUD show:nil Interaction:NO];
    [TTRequestOperationManager POST:API_USER_UPLOAD_IMAGE parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(self.zhizhaoImage) name:@"image" fileName:@"pic.png" mimeType:@"image/png"];
    } Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
        if ([code isEqualToString:@"200"]){
            self.xukezhengImageUrl = [result string_ForKey:@"file"];
            self.xukezhengIV.image =self.xukezhengImage;
            [ProgressHUD dismiss];
        }
        else{
            [ProgressHUD showError:msg];
        }
    } Failure:^(NSError *error) {
    }];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.recmondFromTF) {
        [self resignKeyBorad];
        [self selectRecmondFrom];
        return NO;
    }
    else{
        return YES;
    }
}
//MARK:选择推荐来源
- (void)selectRecmondFrom{
    if (self.recommendFromDatas ==nil) {
        self.recommendFromDatas = [NSMutableArray array];
    }
    if (self.recommendFromDatas.count<=0) {
        NSArray *item_titles = @[@"业务员",@"好友推荐",@"客户端",@"电视广告",@"楼宇海报",@"宣传单",@"微信公众号",@"微信朋友圈",@"公司网站",@"百度搜索",@"其他"];
        NSArray *item_ids = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11"];
        for (int i=0; i<item_titles.count; i++) {
            TTNormalPickerItem *item = [[TTNormalPickerItem alloc] init];
            item.item_id = item_ids[i];
            item.item_name = item_titles[i];
            [self.recommendFromDatas addObject:item];
        }
    }
    TTNormalPickerView *pickerView = [[TTNormalPickerView alloc] init];
    [pickerView showWithItems:self.recommendFromDatas SelectedIndex:0 Handler:^(TTNormalPickerItem *item) {
        self.recommendItem = item;
        self.recmondFromTF.text = item.item_name;
        if ([self.recommendItem.item_id isEqualToString:@"1"]||[self.recommendItem.item_id isEqualToString:@"2"]) {
            self.workerView.hidden = NO;
        }
        else{
            self.workerView.hidden = YES;
        }
    }];

}

//MARK:保存
- (IBAction)save:(id)sender {
    if (self.zhizhaoImageUrl.length<2) {
        [ProgressHUD showError:@"请上传营业执照照片" Interaction:NO];
        return;
    }
    if (self.xukezhengImageUrl.length<2) {
        [ProgressHUD showError:@"请上传许可证照片" Interaction:NO];
        return;
    }
    if (self.workerNOTF.text.absolute_String.length<2) {
        //    推荐业务员电话
        if ([self.recommendItem.item_id isEqualToString:@"1"]) {
            [ProgressHUD showError:@"请输入推荐业务员电话" Interaction:NO];
            return;
        }
        //推荐用户电话
        if ([self.recommendItem.item_id isEqualToString:@"2"]) {
            [ProgressHUD showError:@"请输入推荐好友电话" Interaction:NO];
            return;
        }
    }
    [self presentAlertWithTitle:@"确认提交？" Handler:^{
        [self saveNow];
    } Cancel:nil];
}
- (void)saveNow{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    [para setObject:self.zhizhaoImageUrl forKey:@"business_license"];
    [para setObject:self.xukezhengImageUrl forKey:@"business_permit"];
//    推荐业务员电话
    if ([self.recommendItem.item_id isEqualToString:@"1"]) {
        [para setObject:self.workerNOTF.text forKey:@"recommend_admin"];//推荐业务员电话
    }
    //推荐用户电话
    if ([self.recommendItem.item_id isEqualToString:@"2"]) {
        [para setObject:self.workerNOTF.text forKey:@"recommend_phone"];//
    }
    [para setObject:self.recommendItem.item_name forKey:@"source"];
    [ProgressHUD show:nil Interaction:NO];
    [TTRequestOperationManager POST:API_USER_UPLOAD_INFORMATION_ONLY_ONCE Parameters:para Success:^(NSDictionary *responseJsonObject) {
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
