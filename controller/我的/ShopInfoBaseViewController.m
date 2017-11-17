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

@interface ShopInfoBaseViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *zhizhaoIV;
@property (strong, nonatomic) IBOutlet UIImageView *xukezhengIV;
@property (strong, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *recmondFromTF;//推荐来源
@property (strong, nonatomic) IBOutlet UITextField *workerNOTF;//业务员编号
//／／data
@property (strong, nonatomic) UIImage *zhizhaoImage;//执照图片预上传
@property (strong, nonatomic) NSString *zhizhaoImageUrl;//执照图片地址

@property (strong, nonatomic) UIImage *xukezhengImage;//许可证图片预上传
@property (strong, nonatomic) NSString *xukezhengImageUrl;//执照图片地址

@property (strong, nonatomic) NSMutableArray *recommendFromDatas;//推荐来源
@property (strong, nonatomic) TTNormalPickerItem *recommendItem;//推荐来源选中

@end

@implementation ShopInfoBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"基本信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(resignKeyBorad)];
    self.shopNameLabel.text = [[TTUserInfoManager userInfo] string_ForKey:@"name"];
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
- (void)uploadZhiZhaoImage
{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    [ProgressHUD show:nil Interaction:NO];
    [TTRequestOperationManager POST:API_USER_UPLOAD_AVATAR parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(self.zhizhaoImage) name:@"member_avatar" fileName:@"pic.png" mimeType:@"image/png"];
    } Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
        if ([code isEqualToString:@"1"]){
            self.zhizhaoImageUrl = [result string_ForKey:@"member_avatar"];
            self.zhizhaoIV.image =self.zhizhaoImage;
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
    [TTRequestOperationManager POST:API_USER_UPLOAD_AVATAR parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(self.zhizhaoImage) name:@"member_avatar" fileName:@"pic.png" mimeType:@"image/png"];
    } Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
        if ([code isEqualToString:@"1"]){
            self.xukezhengImageUrl = [result string_ForKey:@"member_avatar"];
            self.xukezhengIV.image =self.xukezhengImage;
        }
        else{
            [ProgressHUD showError:msg];
        }
    } Failure:^(NSError *error) {
    }];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.recmondFromTF) {
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
        NSArray *item_titles = @[@"客户端",@"电视广告",@"楼宇海报",@"宣传单",@"微信公众号",@"微信朋友圈",@"公司网站",@"百度搜索",@"其他"];
        NSArray *item_ids = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
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
    [self presentAlertWithTitle:@"确认提交？" Handler:^{
        [self saveNow];
    } Cancel:nil];
}
- (void)saveNow{
    
}

@end
