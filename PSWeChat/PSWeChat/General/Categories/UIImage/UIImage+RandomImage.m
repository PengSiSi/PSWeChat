//
//  UIImage+RandomImage.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/16.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "UIImage+RandomImage.h"

@implementation UIImage (RandomImage)

+ (UIImage*)randomImageInPath:(NSString*)path {
    NSString* imagePath =
    [NSString stringWithFormat:@"%@/%u.jpg", [[NSBundle mainBundle] bundlePath],
     arc4random() % 29];
    
    UIImage* image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    
    return image;
}

@end
