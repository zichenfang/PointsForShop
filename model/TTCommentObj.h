//
//  TTCommentObj.h
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/12/8.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "TTObject.h"

@interface TTCommentObj : TTObject
@property (nonatomic,strong) NSString * comment_id;//
@property (nonatomic,strong) NSString * user_id;//
@property (nonatomic,strong) NSString * nickname;//
@property (nonatomic,strong) NSString * head_url;//
@property (nonatomic,strong) NSString * comment;//
@property (nonatomic,assign) double score;//

@property (nonatomic,assign) int star;//星星等级
@property (nonatomic,strong) NSString * image1;//
@property (nonatomic,strong) NSString * image2;//
@property (nonatomic,strong) NSString * image3;//
@property (nonatomic,strong) NSMutableArray * images;//////自组成数组
@property (nonatomic,strong) NSString * create_time;//

@end
//var id :Int?
//var user_id :Int?
//var nickname :String?
//var head_url :String?
//var comment :String?
////评分
//var score :Double?
////星星等级
//var star :Int?
//var image1 :String?
//var image2 :String?
//var image3 :String?
////自组成数组
//var images = NSMutableArray() as! [String]
//var create_time :String?

