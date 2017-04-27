//
//  ShareTableViewCell.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/16.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "ShareTableViewCell.h"
#import "UIView+JGG.h"
#import "MessageModel.h"
#import "ZanCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"

#define kGAP 10
#define kAvatar_Size 40

static NSString *const commentCellID = @"commentCellID";
static NSString *const zanCellID = @"zanCellID";

@interface ShareTableViewCell ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) JGGView *jggView;

@end

@implementation ShareTableViewCell

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
    
    [self.contentView addSubview:self.iconImgV];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.moreBtn];
    [self.contentView addSubview:self.jggView];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.replyButton];
    [self.contentView addSubview:self.deleteButton];
    [self.contentView addSubview:self.commentTableView];
}

- (void)layOut{
    
    [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(kGAP);
        make.width.height.mas_equalTo(kAvatar_Size);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImgV.mas_right).offset(10);
        make.top.mas_equalTo(self.iconImgV);
        make.right.mas_equalTo(-kGAP);
    }];
    self.contentLabel.preferredMaxLayoutWidth = K_SCREEN_WIDTH - kGAP-kAvatar_Size ;
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(kGAP);
    }];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentLabel);
        make.top.mas_equalTo(self.contentLabel.mas_bottom);
    }];
    [self.jggView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.moreBtn);
        make.top.mas_equalTo(self.moreBtn.mas_bottom).offset(kGAP);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.jggView);
        make.top.mas_equalTo(self.jggView.mas_bottom).offset(kGAP);
    }];
    [self.replyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentLabel);
        make.top.mas_equalTo(self.jggView.mas_bottom).offset(kGAP);
    }];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLabel);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(kGAP);
    }];
    [self.commentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentLabel);
        make.top.mas_equalTo(self.deleteButton.mas_bottom).offset(5);
        make.right.mas_equalTo(self.contentLabel);
        make.bottom.mas_equalTo(self.contentView).offset(-10);
    }];
}

#pragma mark - 懒加载

- (UIImageView *)iconImgV {
    
    if (!_iconImgV) {
        _iconImgV = [[UIImageView alloc]init];
        _iconImgV.backgroundColor = [UIColor whiteColor];
        _iconImgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImgV;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = FONT_15;
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.font = FONT_15;
    }
    return _timeLabel;
}

- (UILabel *)contentLabel {
    
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.font = FONT_14;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UIButton *)moreBtn {
    
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setTitle:@"全文" forState:UIControlStateNormal];
        [_moreBtn setTitle:@"收起" forState:UIControlStateSelected];
        [_moreBtn setTitleColor:[UIColor colorWithRed:92/255.0 green:140/255.0 blue:193/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_moreBtn setTitleColor:[UIColor colorWithRed:92/255.0 green:140/255.0 blue:193/255.0 alpha:1.0] forState:UIControlStateSelected];
        _moreBtn.titleLabel.font = FONT_14;
        _moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _moreBtn.selected = NO;
        [_moreBtn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (UIButton *)replyButton {
    
    if (!_replyButton) {
        _replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_replyButton addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
        [_replyButton setBackgroundImage:[UIImage imageNamed:@"fw_r2_c2"] forState:UIControlStateNormal];
    }
    return _replyButton;
}

- (UIButton *)deleteButton {
    
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:F_BLUE forState:UIControlStateNormal];
        _deleteButton.titleLabel.font = FONT_15;
        _deleteButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _deleteButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [_deleteButton addTarget:self action:@selector(deleteShareClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _deleteButton;
}

- (JGGView *)jggView {
    
    if (!_jggView) {
        _jggView = [[JGGView alloc]init];
    }
    return _jggView;
}

- (UITableView *)commentTableView {
    
    if (!_commentTableView) {
        _commentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _commentTableView.delegate = self;
        _commentTableView.dataSource = self;
        _commentTableView.scrollEnabled = NO;
        _commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 注册cell
        [_commentTableView registerClass:[CommentCell class] forCellReuseIdentifier:commentCellID];
        [_commentTableView registerClass:[ZanCell class] forCellReuseIdentifier:zanCellID];
    }
    return _commentTableView;
}

#pragma mark - Private Method

- (void)moreAction: (UIButton *)button {
    
    if (self.MoreBtnClickBlock) {
        self.MoreBtnClickBlock(button, self.indexPath);
    }
}

- (void)replyAction: (UIButton *)button {
    
    if (self.ReplyBtnClickBlock) {
        self.ReplyBtnClickBlock(button, self.indexPath);
    }
}

- (void)deleteShareClick: (UIButton *)button {
    
    if (self.DeleteBtnClickBlock) {
        self.DeleteBtnClickBlock(button, self.indexPath);
    }
}

- (void)configCellWithModel:(MessageModel *)model indexPath:(NSIndexPath *)indexPath {
    
    self.messageModel = model;
    [self.iconImgV sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.indexPath = indexPath;
    self.nameLabel.text = model.userName;
    self.contentLabel.text = model.message;
    self.timeLabel.text = model.timeTag;
    
    NSMutableParagraphStyle *muStyle = [[NSMutableParagraphStyle alloc]init];
    muStyle.lineSpacing = 3;//设置行间距离
    muStyle.alignment = NSTextAlignmentLeft;//对齐方式
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSParagraphStyleAttributeName:muStyle};
    CGFloat height = [model.message boundingRectWithSize:CGSizeMake(K_SCREEN_WIDTH - kGAP-kAvatar_Size - 2*kGAP, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height+0.5;
    if (height < 60) {
        [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentLabel);
            make.top.mas_equalTo(self.contentLabel.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
    } else {
        [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentLabel);
            make.top.mas_equalTo(self.contentLabel.mas_bottom);
        }];
    }
    if (model.isExpand) {//展开
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.nameLabel);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(kGAP);
            make.height.mas_equalTo(height);
        }];
    }else{//闭合
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.nameLabel);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(kGAP);
            make.height.mas_lessThanOrEqualTo(60);
        }];
    }
    self.moreBtn.selected = model.isExpand;
    
    CGFloat jjg_height = 0.0;
    CGFloat jjg_width = 0.0;
    if (model.messageBigPics.count>0&&model.messageBigPics.count<=3) {
        jjg_height = [JGGView imageHeight];
        jjg_width  = (model.messageBigPics.count)*([JGGView imageWidth]+kJGG_GAP)-kJGG_GAP;
    }else if (model.messageBigPics.count>3&&model.messageBigPics.count<=6){
        jjg_height = 2*([JGGView imageHeight]+kJGG_GAP)-kJGG_GAP;
        jjg_width  = 3*([JGGView imageWidth]+kJGG_GAP)-kJGG_GAP;
    }else  if (model.messageBigPics.count>6&&model.messageBigPics.count<=9){
        jjg_height = 3*([JGGView imageHeight]+kJGG_GAP)-kJGG_GAP;
        jjg_width  = 3*([JGGView imageWidth]+kJGG_GAP)-kJGG_GAP;
    }
    // 解决图片复用问题
    [self.jggView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    ///布局九宫格
    [self.jggView JGGView:self.jggView DataSource:model.messageBigPics completeBlock:^(NSInteger index, NSArray *dataSource,NSIndexPath *indexpath) {
        if (self.tapImageBlock) {
            self.tapImageBlock(index,dataSource,self.indexPath);
        }
    }];
    [self.jggView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.moreBtn);
        make.top.mas_equalTo(self.moreBtn.mas_bottom).offset(kJGG_GAP);
        make.size.mas_equalTo(CGSizeMake(jjg_width, jjg_height));
    }];
    if (self.messageModel.commentModelArray > 0) {
        // 显示tableView,设置高度
        CGFloat tableViewHeight = 0.0f;
        for (CommentModel *commentModel in self.messageModel.commentModelArray) {
            CGFloat cellHeight = [CommentCell hyb_heightForTableView:self.commentTableView config:^(UITableViewCell *sourceCell) {
                CommentCell *cell = (CommentCell *)sourceCell;
                [cell configureCellWithModel:commentModel];
            } cache:^NSDictionary *{
                return @{kHYBCacheUniqueKey : commentModel.commentId,
                         kHYBCacheStateKey : @"",
                         kHYBRecalculateForStateKey : @(YES)};
            }];
            tableViewHeight = tableViewHeight + cellHeight;
        }
        if (self.messageModel.hasOk) {
            tableViewHeight = tableViewHeight + 40;
        }
        // 更新tableView高度
        [self.commentTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(tableViewHeight);
        }];
        [self.commentTableView reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    return self.messageModel.commentModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        ZanCell *cell = [tableView dequeueReusableCellWithIdentifier:zanCellID forIndexPath:indexPath];
        if (self.messageModel.hasOk) {
            [cell configureWithZanUser:@"思思"];
        } else {
            [cell configureWithZanUser:@""];
        }
        return cell;
    }
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellID forIndexPath:indexPath];
    [self configureCommentCell:cell indexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return self.messageModel.hasOk ? 40.0f : 0.0f;
    } else {
        CommentModel *model = self.messageModel.commentModelArray[indexPath.row];
        CGFloat cell_height = [CommentCell hyb_heightForTableView:self.commentTableView config:^(UITableViewCell *sourceCell) {
            CommentCell *cell = (CommentCell *)sourceCell;
            [cell configureCellWithModel:model];
        } cache:^NSDictionary *{
            NSDictionary *cache = @{kHYBCacheUniqueKey : model.commentId,
                                    kHYBCacheStateKey : @"",
                                    kHYBRecalculateForStateKey : @(NO)};
            //        model.shouldUpdateCache = NO;
            return cache;
        }];
        return cell_height;
    }
}

- (void)configureCommentCell: (CommentCell *)cell indexPath: (NSIndexPath *)indexPath {

    [cell configureCellWithModel:self.messageModel.commentModelArray[indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return FLT_EPSILON;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return FLT_EPSILON;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.commentCellDidSelectBlock) {
        CommentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.commentCellDidSelectBlock(self.commentTableView, cell, indexPath);
    }
}
@end
