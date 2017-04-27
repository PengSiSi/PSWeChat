//
//  AddressBookCell.h
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/17.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressBookCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *nameLabel;

- (void)configureAddressBookCellWithIconImg: (NSString *)iconImgUrl
                                       name: (NSString *)name;

@end
