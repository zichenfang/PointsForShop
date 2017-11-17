//
//  TTTourTypePickerView.m
//  SuiTu
//
//  Created by 殷玉秋 on 2017/5/23.
//  Copyright © 2017年 fff. All rights reserved.
//

#import "TTNormalPickerView.h"
@interface TTNormalPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong)UIPickerView *pickerView;
@property (nonatomic,strong)NSArray *items;
@property (nonatomic,assign)NSInteger selectedRow;

@end
@implementation TTNormalPickerView

- (instancetype)init
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 210)];
        [self addSubview:self.contentView];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        float btn_width = 70;
        float btn_height = 40;
        
        //确定
        UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.contentView addSubview:okBtn];
        okBtn.frame = CGRectMake(self.contentView.frame.size.width-btn_width, 0, btn_width, btn_height);
        [okBtn setTitle:@"确定" forState:UIControlStateNormal];
        [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        okBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        [okBtn addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
        
        
        //取消
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.contentView addSubview:cancelBtn];
        cancelBtn.frame = CGRectMake(0, 0, btn_width, btn_height);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];

        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, btn_height, self.contentView.frame.size.width, self.contentView.frame.size.height-btn_height)];
        [self.contentView addSubview:self.pickerView];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        

 
    }
    return self;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1; //
}

//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.items.count;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return self.frame.size.width;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    TTNormalPickerItem *item = [self.items objectAtIndex:row];
    return item.item_name;
}

// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedRow = row;
}
- (void)showWithItems :(NSArray <TTNormalPickerItem *> *)items SelectedIndex :(NSInteger)selectedIndex Handler:(TTNormalPickerViewHandler)handler
{
    if (handler) {
        self.handler = handler;
    }
    self.selectedRow = selectedIndex;
    if (items) {
        self.items = items;
        if (self.selectedRow<self.items.count) {
            [self.pickerView selectRow:self.selectedRow inComponent:0 animated:NO];
        }
        [self.pickerView reloadAllComponents];
    }
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(0, -self.contentView.frame.size.height);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }];
}
- (void)ok{
    if (self.items.count>0) {
        TTNormalPickerItem *item = [self.items objectAtIndex:self.selectedRow];
        if (self.handler) {
            self.handler(item);
        }
    }
    [self dismiss];
}
- (void)cancel{}
- (void)dismiss{
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(0, 0);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if ([touch.view isKindOfClass:[self class]]) {
        [self dismiss];
    }
}
@end
