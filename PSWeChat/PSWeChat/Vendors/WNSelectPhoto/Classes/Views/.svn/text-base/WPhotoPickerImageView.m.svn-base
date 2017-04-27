//
//  WPhotoPickerImageView.m
//  WNSelectPhoto
//
//  Created by 王楠 on 15/5/20.
//  Copyright (c) 2015年 王楠. All rights reserved.
//

#import "WPhotoPickerImageView.h"
#import "WSelectPhotoCommon.h"

@interface WPhotoPickerImageView()

@property (nonatomic , weak) UIView *maskView;
@property (nonatomic , weak) UIImageView *tickImageView;
@property (nonatomic , weak) UIImageView *videoView;

@end

@implementation WPhotoPickerImageView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
    }
    return self;
}

- (UIView *)maskView{
    if (!_maskView) {
        UIView *maskView = [[UIView alloc] init];
        maskView.frame = self.bounds;
        maskView.backgroundColor = [UIColor whiteColor];
        maskView.hidden = YES;
        [self addSubview:maskView];
        self.maskView = maskView;
    }
    return _maskView;
}

- (UIImageView *)videoView{
    if (!_videoView) {
        UIImageView *videoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.bounds.size.height - 40, 30, 30)];
        videoView.image = [UIImage imageNamed:WSelectPhotoSrcName(@"video")];
        videoView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:videoView];
        self.videoView = videoView;
    }
    return _videoView;
}

- (UIImageView *)tickImageView{
    if (!_tickImageView) {
        UIImageView *tickImageView = [[UIImageView alloc] init];
        tickImageView.frame = CGRectMake(self.bounds.size.width - 30, 0, 30, 30);
        tickImageView.image = [UIImage imageNamed:WSelectPhotoSrcName(@"AssetsPickerChecked")];
        tickImageView.hidden = YES;
        [self addSubview:tickImageView];
        self.tickImageView = tickImageView;
    }
    return _tickImageView;
}

- (void)setIsVideoType:(BOOL)isVideoType{
    _isVideoType = isVideoType;
    
    self.videoView.hidden = !(isVideoType);
}

- (void)setMaskViewFlag:(BOOL)maskViewFlag{
    _maskViewFlag = maskViewFlag;
    
    self.animationRightTick = maskViewFlag;
}

- (void)setAnimationRightTick:(BOOL)animationRightTick{
    _animationRightTick = animationRightTick;
    self.tickImageView.hidden = !animationRightTick;
    
    CAKeyframeAnimation *scaoleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaoleAnimation.duration = 0.25;
    scaoleAnimation.autoreverses = YES;
    scaoleAnimation.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.2],[NSNumber numberWithFloat:1.0]];
    scaoleAnimation.fillMode = kCAFillModeForwards;
    
    if (self.isVideoType) {
        [self.videoView.layer removeAllAnimations];
        [self.videoView.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];
    }else{
        [self.tickImageView.layer removeAllAnimations];
        [self.tickImageView.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];
    }
    
}
@end
