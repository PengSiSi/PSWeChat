//
//  LoacationCell.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/26.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "LoacationCell.h"

@interface LoacationCell ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UILabel *locationNameLabel;
@property (nonatomic, strong) UIImageView *tipImgView;

@end

@implementation LoacationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self createSubViews];
        [self layOut];
    }
    return self;
}

- (void)createSubViews {
    
    self.tipImgView = [[UIImageView alloc]init];
    self.tipImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.tipImgView.hidden = YES;
    self.tipImgView.image = [UIImage imageNamed:@"actionbar_location_icon"];
    [self.contentView addSubview:self.tipImgView];

    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //将这个控件加到父容器中
    [self.contentView addSubview:self.activityIndicator];
    self.locationNameLabel = [[UILabel alloc]init];
    self.locationNameLabel.font = FONT_14;
    self.locationNameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.locationNameLabel];
}

- (void)layOut {
    
    [self.activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10);
        make.centerY.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(20);
    }];
    [self.tipImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10);
        make.centerY.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(20);
    }];

    [self.locationNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.activityIndicator.mas_right).offset(10);
    }];
}

- (void)configureCellWithStartAnimation: (BOOL)isStartAnimation locationName: (NSString *)locationName {
    
    if (isStartAnimation) {
        [self.activityIndicator startAnimating];
        self.tipImgView.hidden = YES;
    } else {
        [self.activityIndicator stopAnimating];
        self.tipImgView.hidden = NO;
    }
    self.locationNameLabel.text = locationName;
}

@end
