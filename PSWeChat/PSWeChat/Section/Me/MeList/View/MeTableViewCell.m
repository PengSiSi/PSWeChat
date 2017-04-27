//
//  MeTableViewCell.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/16.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "MeTableViewCell.h"
#import "PersonModel.h"

@interface MeTableViewCell ()

@property (nonatomic, strong) UIImageView *avaterImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *weChatIdLabel;
@property (nonatomic, strong) UIImageView *barcodeImgView;

@end

@implementation MeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createSubViews];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    
    [self.contentView addSubview:self.avaterImgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.weChatIdLabel];
    [self.contentView addSubview:self.barcodeImgView];
}

- (void)setModel:(PersonModel *)model {

    _model = model;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.avaterImgView.image = [UIImage imageNamed:self.model.avater];
    self.nameLabel.text = self.model.name;
    self.weChatIdLabel.text = self.model.weChatId;
    self.barcodeImgView.image = [UIImage imageNamed:@"ScanQRCode"];
    self.barcodeImgView.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 懒加载

- (UIImageView *)avaterImgView {
    
    if (!_avaterImgView) {
        _avaterImgView = [[UIImageView alloc]initWithFrame:CGRectMake(NormalSpace, NormalSpace, 70, 70)];
        _avaterImgView.clipsToBounds = YES;
        _avaterImgView.layer.cornerRadius = CIRCULARBEAD;
    }
    return _avaterImgView;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.avaterImgView.right + NormalSpace, 19,
                                                              160, 22)];
        _nameLabel.font = FONT_15;
    }
    return _nameLabel;
}

- (UILabel*)weChatIdLabel
{
    if (!_weChatIdLabel) {
        _weChatIdLabel = [[UILabel alloc]
                          initWithFrame:CGRectMake(self.nameLabel.left,
                                                   self.nameLabel.frame.origin.y +
                                                   self.nameLabel.frame.size.height + 5,
                                                   160, 20)];
        
        _weChatIdLabel.font = FONT_14;
    }
    return _weChatIdLabel;
}

- (UIImageView*)barcodeImageView
{
    if (!_barcodeImgView) {
        _barcodeImgView = [[UIImageView alloc]
                             initWithFrame:CGRectMake(self.frame.size.width - 50,
                                                      ((self.frame.size.height - 35 / 2.0) / 2.0),
                                                      35 / 2.0, 35 / 2.0)];
    }
    return _barcodeImgView;
}

@end
