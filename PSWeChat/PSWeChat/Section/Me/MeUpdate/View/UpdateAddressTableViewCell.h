//
//  UpdateAddressTableViewCell.h
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/20.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UpdateAddressTableViewCellDelegate <NSObject>

@optional
- (void)addTableViewCellWithLabelAndTextField:(UITableViewCell *)cell textFieldDidEndEditing:(UITextField *)textField;

- (void)addTableViewCellWithLabelAndTextField:(UITableViewCell *)cell textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end


@interface UpdateAddressTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, assign) id<UpdateAddressTableViewCellDelegate> delegate;

- (void)configureUpdateAddressTableViewCellWithTitleLabelText: (NSString *)titleText rightImageName: (NSString *)imageName;

@end
