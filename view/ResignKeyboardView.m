//
//  ResignKeyboardView.m
//  WhaleShop
//
//  Created by 殷玉秋 on 2017/10/13.
//  Copyright © 2017年 HeiziTech. All rights reserved.
//

#import "ResignKeyboardView.h"
@interface ResignKeyboardView()
@property (nonatomic) UITextField *tf;
@property (nonatomic) UITextView *tv;
@end

@implementation ResignKeyboardView

- (instancetype)initWithTextField :(UITextField *)tf TextView :(UITextView *)tv Instruction :(NSString *)ins
{
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //ins
        UILabel *insLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-90, self.frame.size.height)];
        [self addSubview:insLabel];
        insLabel.textColor = [UIColor lightGrayColor];
        insLabel.font = [UIFont systemFontOfSize:13];
        insLabel.text = ins;
        //按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.frame.size.width-64, 0, 64,self.frame.size.height);
        [self addSubview:btn];
        [btn setImage:[UIImage imageNamed:@"resignkeyboard"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(resignKeyBorad) forControlEvents:UIControlEventTouchUpInside];
        if (tf) {
            self.tf = tf;
        }
        if (tv) {
            self.tv = tv;
        }
    }
    return self;
}
- (void)resignKeyBorad{
    if (self.tf) {
        [self.tf resignFirstResponder];
    }
    else if (self.tv){
        [self.tv resignFirstResponder];
    }
}
@end
