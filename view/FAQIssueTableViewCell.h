//
//  FAQIssueTableViewCell.h
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/12/7.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTFAQObj.h"

@interface FAQIssueTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *issueLabel;
@property (strong, nonatomic) IBOutlet UIImageView *arrowIV;

- (void)data :(TTFAQObj *)obj;
@end
