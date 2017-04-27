//
//  UpdateAddressTableViewCell.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/20.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "UpdateAddressTableViewCell.h"

@interface UpdateAddressTableViewCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation UpdateAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
        [self layOut];
    }
    return self;
}

- (void)createSubViews {
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = FONT_15;
    self.titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.titleLabel];
    
    self.inputTextField = [[UITextField alloc]init];
    self.inputTextField.textAlignment = NSTextAlignmentLeft;
    [self.inputTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.inputTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.inputTextField.delegate = self;
    self.inputTextField.font = FONT_15;
    self.inputTextField.textColor = PLACEHOLDER_COLOR;
    [self.inputTextField setValue:PLACEHOLDER_COLOR forKeyPath:@"_placeholderLabel.textColor"];
    [self.contentView addSubview:self.inputTextField];
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.hidden = YES;
    [self.contentView addSubview:self.rightButton];
}

- (void)layOut {
   
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10);
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(getWidth(80));
    }];
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(self.contentView);
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.centerY.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(20);
    }];
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [_inputTextField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    BOOL isEmoj = [NSString stringContainsEmoji:textField.text];
    if (isEmoj) {
        //有非法字符
        [CombancHUD showInfoWithStatus:KREQUESTCONTAINILLEGALSTRING];
        textField.text = @"";
    } else{
        //正常字符
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(addTableViewCellWithLabelAndTextField:textFieldDidEndEditing:)]) {
            [self.delegate addTableViewCellWithLabelAndTextField:self textFieldDidEndEditing:textField];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(addTableViewCellWithLabelAndTextField:textField:shouldChangeCharactersInRange:replacementString:)]) {
        [self.delegate addTableViewCellWithLabelAndTextField:self textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}

- (void)configureUpdateAddressTableViewCellWithTitleLabelText: (NSString *)titleText rightImageName: (NSString *)imageName {
    
    self.titleLabel.text = titleText;
    if (imageName.length > 0) {
        [self.rightButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
}
@end
