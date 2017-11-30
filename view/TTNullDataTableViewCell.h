//
//  TTNullDataTableViewCell.h
//  WhaleShop
//
//  Created by 殷玉秋 on 2017/10/21.
//  Copyright © 2017年 HeiziTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTNullDataTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *msgLabel;
- (void)msg :(NSString *)msg;
@end
