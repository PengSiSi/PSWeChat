//
//  UpdateAddressViewController.h
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/20.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "BaseViewController.h"
#import "AddressModel.h"

typedef void(^SuccessBlock)(void);

@interface UpdateAddressViewController : BaseViewController

@property (nonatomic, copy) SuccessBlock block; /**<新增收货地址成功的回调 */

+ (instancetype)updateAddressViewControllerWithAddressModel: (AddressModel *)model;

- (instancetype)initWithUpdateAddressViewControllerWithAddressModel:(AddressModel *)model;

@end
