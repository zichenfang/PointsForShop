//
//  ImageBrowserVC.h
//  WhaleShop
//
//  Created by 殷玉秋 on 2017/10/22.
//  Copyright © 2017年 HeiziTech. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "TTVenderHeader.h"

@interface ImageBrowserVC : UIViewController
@property(nonatomic,strong)NSArray *links;
@property(nonatomic,assign)NSInteger currentIndex;

//links :只需要是图片的链接就行，不需要转化成url
- (id)initWithLinks :(NSArray *)links CurrentIndex:(NSInteger)index;
- (void)show;
@end
