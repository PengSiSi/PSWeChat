//
//  MeTableViewCell.h
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/16.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PersonModel;

@interface MeTableViewCell : UITableViewCell

@property (nonatomic, strong) PersonModel *model; /**<用户信息model */

@end
