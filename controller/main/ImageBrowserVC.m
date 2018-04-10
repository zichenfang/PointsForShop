//
//  ImageBrowserVC.m
//  WhaleShop
//
//  Created by 殷玉秋 on 2017/10/22.
//  Copyright © 2017年 HeiziTech. All rights reserved.
//

#import "ImageBrowserVC.h"

@interface ImageBrowserVC ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UILabel *pageLabel;

@end

@implementation ImageBrowserVC
- (id)initWithLinks :(NSArray *)links CurrentIndex:(NSInteger)index
{
    self =[super init];
    if (self) {
        //
        self.links = [NSArray arrayWithArray:links];
        //        self.currentIndex =MAX(0, MIN(links.count, index));
        self.currentIndex =index;
        self.view.backgroundColor =[UIColor blackColor];
        //返回 tap手势
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        tap.numberOfTapsRequired =1;
        [self.view addGestureRecognizer:tap];
        
        UITapGestureRecognizer * tap_double = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
        tap_double.numberOfTapsRequired =2;
        [self.view addGestureRecognizer:tap_double];
        [tap requireGestureRecognizerToFail:tap_double];
        
        [self creatSubview];
    }
    return self;
}
- (void)doubleTap:(UITapGestureRecognizer *)sender{
    NSInteger index= [sender locationInView:self.scrollView].x/SCREEN_WIDTH;
    UIScrollView *scr = (UIScrollView *)[self.scrollView viewWithTag:100+index];
    if (![scr isKindOfClass:NSClassFromString(@"UIScrollView")]) {
        return;
    }
    if (scr.zoomScale ==1) {
        [scr setZoomScale:2.0 animated:YES];
    }
    else{
        [scr setZoomScale:1.0 animated:YES];
    }
    
}
-(void)dismiss
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
}
- (void)creatSubview
{
    self.scrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.scrollView];
    
    self.scrollView.backgroundColor =[UIColor blackColor];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*self.links.count, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    
    //    self.scrollView.minimumZoomScale = 1.0;
    //    self.scrollView.maximumZoomScale = 3.0;
    
    for (int i =0; i<self.links.count; i++) {
        //用来缩放图片的 scrollview
        UIScrollView *zoomScrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.scrollView addSubview:zoomScrollView];
        zoomScrollView.backgroundColor =[UIColor blackColor];
        zoomScrollView.delegate = self;
        zoomScrollView.minimumZoomScale = 1.0;
        zoomScrollView.maximumZoomScale = 3.0;
        zoomScrollView.tag =i+100;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.links[i]] placeholderImage:[UIImage imageNamed:@"zanwutupian"]];
        [zoomScrollView addSubview:imageView];
        imageView.tag =10;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    self.scrollView.contentOffset =CGPointMake(self.scrollView.frame.size.width*self.currentIndex, 0);
    //    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    saveBtn.frame =CGRectMake(ScreenWidth -60, ScreenHeight-50, 33, 33);
    //    [saveBtn setImage:[UIImage imageNamed:@"save_icon_highlighted"] forState:UIControlStateNormal];
    //    [saveBtn setImage:[UIImage imageNamed:@"save_icon"] forState:UIControlStateDisabled];
    //    [self.view addSubview:saveBtn];
    //    [saveBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.pageLabel =[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.5-25, SCREEN_HEIGHT-50, 50, 33)];
    self.pageLabel.textAlignment = NSTextAlignmentCenter;
    self.pageLabel.textColor =[UIColor lightGrayColor];
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%lu",self.currentIndex+1,(unsigned long)self.links.count];
    [self.view addSubview:self.pageLabel];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    [window.rootViewController addChildViewController:self];
    // 隐藏状态栏
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    
}
- (void)saveImage
{
    UIScrollView *imageBacScroll = (UIScrollView *)[self.scrollView viewWithTag:self.currentIndex+100];
    UIImageView *imageView = (UIImageView *)[imageBacScroll viewWithTag:10];
    UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}
- (void)image: (UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"" message:@"保存成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
    [ale show];
}
#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView!= self.scrollView) {
        return;
    }
    self.currentIndex =(int)(scrollView.contentOffset.x/SCREEN_WIDTH);
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%lu",self.currentIndex+1,(unsigned long)self.links.count];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        return nil;
    }
    UIView *subView = [scrollView viewWithTag:self.currentIndex+100];
    UIImageView *imageView = (UIImageView *)[subView viewWithTag:10];
    return imageView;
}
@end
