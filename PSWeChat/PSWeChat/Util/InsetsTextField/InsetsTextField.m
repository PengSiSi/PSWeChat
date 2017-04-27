//
//  InsetsTextField.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/26.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "InsetsTextField.h"

@implementation InsetsTextField

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    
    return CGRectInset(bounds, self.textFieldInset.x, self.textFieldInset.y);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    
    return CGRectInset(bounds, self.textFieldInset.x, self.textFieldInset.y);
}
@end
