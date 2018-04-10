//
//  DealViewController.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/11/28.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "DealViewController.h"
#import <CoreImage/CoreImage.h>
#import "QRCodeImageShowViewController.h"
#import "RechargeViewController.h"

@interface DealViewController ()
@property (strong, nonatomic) IBOutlet UITextField *inputMoneyTF;
@property (strong, nonatomic) IBOutlet UIButton *rechargeBtn;//充值按钮
@property (strong, nonatomic) IBOutlet UILabel *pointsLabel;//积分余额
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;//获取不到最新店铺配置信息时，禁用掉按钮

@end

@implementation DealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"买单";
    [self configUI];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadShopStatusInfo];
}
- (void)configUI{
    self.rechargeBtn.layer.masksToBounds = YES;
    self.rechargeBtn.layer.cornerRadius = 12;
    self.rechargeBtn.layer.borderWidth =1;
    self.rechargeBtn.layer.borderColor = [UIColor stylePinkColor].CGColor;
}
//MARK:充值
- (IBAction)goRecharge:(id)sender {
    RechargeViewController *vc = [[RechargeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//MAR:生成二维码
- (IBAction)makeQRCode:(id)sender {
    if (self.inputMoneyTF.text.intValue<=0) {
        [ProgressHUD showError:@"请输入消费金额" Interaction:NO];
        return;
    }
    
    
    [self.inputMoneyTF resignFirstResponder];
    //  25jfnmuhgpbv春风十里jfnmuhgpbv5jfnmuhgpbv100 ()
    //  店铺idjfnmuhgpbv店铺名jfnmuhgpbv转换比例jfnmuhgpbv消费金额
    NSDictionary *result = [TTUserInfoManager userInfo];
    NSString *shopID = [result string_ForKey:@"id"];
    NSString *shopName = [result string_ForKey:@"name"];
    NSString *pointsPercent = [result string_ForKey:@"integral_ratio"];
    if (self.inputMoneyTF.text.intValue*pointsPercent.floatValue*0.01>self.pointsLabel.text.intValue){
        [ProgressHUD showError:@"积分余额不足" Interaction:NO];
        return;
    }
    NSString *qrStr = [NSString stringWithFormat:@"%@jfnmuhgpbv%@jfnmuhgpbv%@jfnmuhgpbv%@",shopID,shopName,pointsPercent,self.inputMoneyTF.text];
    [self makeQRCodeWithContent:qrStr];
}
//MARK:获取最新状态信息
- (void)loadShopStatusInfo{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    [ProgressHUD show:nil Interaction:NO];
    [TTRequestOperationManager POST:API_USER_GET_ALLINFO Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
            [TTUserInfoManager setUserInfo:result];
            self.pointsLabel.text = [[TTUserInfoManager userInfo] string_ForKey:@"integral_recharge"];
            self.saveBtn.enabled = YES;
            [ProgressHUD dismiss];
        }
        else{
            [ProgressHUD showError:msg Interaction:NO];
        }
        
    } Failure:^(NSError *error) {
    }];
}
- (void)makeQRCodeWithContent :(NSString *)content{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    CIImage *ciimage = [filter outputImage];
    UIImage *bigImage = [self createNonInterpolatedUIImageFormCIImage:ciimage withSize:600];
    QRCodeImageShowViewController *vc = [[QRCodeImageShowViewController alloc] init];
    vc.qrImage = bigImage;
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

@end
