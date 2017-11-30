//
//  DealViewController.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/11/28.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "DealViewController.h"
#import <CoreImage/CoreImage.h>

@interface DealViewController ()
@property (strong, nonatomic) IBOutlet UITextField *inputMoneyTF;
@property (strong, nonatomic) IBOutlet UIImageView *qrIV;

@end

@implementation DealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"买单";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)makeQRCode:(id)sender {
    if (self.inputMoneyTF.text.intValue<=0) {
        [ProgressHUD showError:@"请输入消费金额" Interaction:NO];
        return;
    }
    [self.inputMoneyTF resignFirstResponder];
    NSString *qrStr = [NSString stringWithFormat:@"zzz:%@",self.inputMoneyTF.text];
    [self makeQRCodeWithContent:qrStr];
}

- (void)makeQRCodeWithContent :(NSString *)content{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    CIImage *ciimage = [filter outputImage];
    UIImage *bigImage = [self createNonInterpolatedUIImageFormCIImage:ciimage withSize:600];
    self.qrIV.image = bigImage;
    [ProgressHUD showSuccess:@"成功" Interaction:NO];
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
