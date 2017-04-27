//
//  CommentCell.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/17.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "CommentCell.h"
#import "CommentModel.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"

@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    
    // contentLabel
    self.contentLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.contentLabel];
    self.contentLabel.backgroundColor = ColorRGB(236, 236, 236);
    self.contentLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - kGAP-kAvatar_Size - 2*kGAP;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.font = FONT_14;
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView).offset(0);//cell上部距离为3.0个间隙
    }];
    self.hyb_lastViewInCell = self.contentLabel;
    self.hyb_bottomOffsetToCell = 0;//cell底部距离为3.0个间隙
}

- (void)configureCellWithModel: (CommentModel *)model {
    
    NSString *str;
    if (![model.commentByUserName isEqualToString:@""]) {
        str= [NSString stringWithFormat:@"%@回复%@：%@",
              model.commentUserName, model.commentByUserName, model.commentText];
    }else{
        str= [NSString stringWithFormat:@"%@：%@",
              model.commentUserName, model.commentText];
    }
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor orangeColor]
                 range:NSMakeRange(0, model.commentUserName.length)];
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor orangeColor]
                 range:NSMakeRange(model.commentUserName.length + 2, model.commentByUserName.length)];
    self.contentLabel.attributedText = text;
}

@end
