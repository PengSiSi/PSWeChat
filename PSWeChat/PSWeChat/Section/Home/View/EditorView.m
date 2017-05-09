//
//  EditorView.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/27.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "EditorView.h"
#import "ChatRoomViewController.h"
#import "LGMessageModel.h"
#import "LGAudioKit.h"

@interface EditorView ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *voiceButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *emojButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (nonatomic, assign) BOOL isVoice; /**<是录音 */

- (IBAction)voiceDidClick:(id)sender;
- (IBAction)emojDidClick:(id)sender;
- (IBAction)addButtonDidClick:(id)sender;

@end

@implementation EditorView

+ (instancetype)editorView {
    
    return [[NSBundle mainBundle]loadNibNamed:@"EditorView" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self addKeyboardNotification];
    self.backgroundColor = [UIColor colorWithRed:250 / 255.0
                                           green:250 / 255.0
                                            blue:250 / 255.0
                                           alpha:1];
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.cornerRadius = 3;
    self.textView.layer.borderColor =
    [UIColor colorWithWhite:0 alpha:0.1].CGColor;
    self.textView.delegate = self;
    self.isVoice = YES;
}

#pragma mark - UITextViewDelegate

/*根据textView的行数调整视图高度*/
- (void)textViewDidChange:(UITextView*)textView{
    
    CGFloat lineHeight = textView.font.lineHeight;
    NSInteger lineCount = (NSInteger)(textView.contentSize.height / lineHeight);
    // 大概写死一个最大的高度
    if (lineCount > 3) {
        return;
    }
    // 计算增加的高度
    CGFloat increaseHeight = (lineCount - 1) * lineHeight;
    // 修改当前editor视图的高度
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([ChatRoomViewController editorViewHeight] + increaseHeight);
    }];
    
    // 动画更新父视图的frame
    [UIView animateWithDuration:1 animations:^{
        [self.superview layoutIfNeeded];
    }];
}

- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text {
    
    // 检测输入回车,发送内容
    if ([text isEqualToString:@"\n"]) {
        if (self.messageWasSend) {
            [self.textView endEditing:YES];
            self.messageWasSend(self.textView.text, ChatMessageTypeText);
            
            // 发送完成,textView清空,需要再次计算textView的高度
            self.textView.text = @"";
            // 手动修改值不会触发textview的通知和事件，只有手动触发textViewDidChange
            [self textViewDidChange:self.textView];
            return NO;
        }
    }
    return YES;
}

- (void)addKeyboardNotification {
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChangedExt:) name:UITextViewTextDidChangeNotification object:nil];
}

- (IBAction)voiceDidClick:(UIButton *)sender {
    
    CGRect textViewFrame = self.textView.frame;
    // 隐藏textView,不能移除,移除会导致所有和他约束有关的子视图会移除.
//    [self.textView setHidden:YES];
    self.isVoice = !self.isVoice;
    if (!_isVoice) {
        [sender setImage:[UIImage imageNamed:@"Album_ToolViewKeyboard"] forState:UIControlStateNormal];
        // 添加录音的按钮
        [self addRecordButton];
        self.recordButton.hidden = NO;
        self.textView.hidden = YES;

    } else {
        [sender setImage:[UIImage imageNamed:@"chat_setmode_voice_btn_normal"] forState:UIControlStateNormal];
        self.recordButton.hidden = YES;
        self.textView.hidden = NO;
    }
    if (self.voiceButtonClick) {
        self.voiceButtonClick();
    }
}

- (IBAction)emojDidClick:(id)sender {
    
    if (self.emojButtonClick) {
        self.emojButtonClick();
    }
}

- (IBAction)addButtonDidClick:(id)sender {
    
    if (self.addButtonClick) {
        self.addButtonClick();
    }
}

- (void)keyBoardWillShow: (NSNotification *)notification {
    
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSInteger animCurveKey =
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration =
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (self.keyBoardWillShow) {
        self.keyBoardWillShow(animCurveKey, duration, keyboardSize);
    }
}

- (void)keyboardWillHidden: (NSNotification *)notification {
    
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSInteger animCurveKey =
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration =
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (self.keyboardWillHidden) {
        self.keyboardWillHidden(animCurveKey, duration, keyboardSize);
    }
}

// 在复制文字进文本框时触发该通知

- (void)textChangedExt: (NSNotification *)notification {
    
    [self textViewDidChange:self.textView];
}

- (void)addRecordButton {
    
    _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_recordButton setBackgroundImage:[[UIImage imageNamed:@"btn_chatbar_press_normal" ] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    [_recordButton setBackgroundImage:[[UIImage imageNamed:@"btn_chatbar_press_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch] forState:UIControlStateSelected];
    _recordButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_recordButton setTitle:@"按住录音" forState:UIControlStateNormal];
    [_recordButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_recordButton addTarget:self action:@selector(startRecordVoice) forControlEvents:UIControlEventTouchDown];
    [_recordButton addTarget:self action:@selector(cancelRecordVoice) forControlEvents:UIControlEventTouchUpOutside];
    [_recordButton addTarget:self action:@selector(confirmRecordVoice) forControlEvents:UIControlEventTouchUpInside];
    [_recordButton addTarget:self action:@selector(updateCancelRecordVoice) forControlEvents:UIControlEventTouchDragExit];
    [_recordButton addTarget:self action:@selector(updateContinueRecordVoice) forControlEvents:UIControlEventTouchDragEnter];
    [_recordButton setFrame:self.textView.frame];
    [self addSubview:_recordButton];
}

- (void)startRecordVoice {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(editorViewStartRecordVoice)]) {
        [self.delegate editorViewStartRecordVoice];
    }
}

- (void)cancelRecordVoice {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(editorViewCancelRecordVoice)]) {
        [self.delegate editorViewCancelRecordVoice];
    }
}

- (void)confirmRecordVoice {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(editorViewConfirmRecordVoice)]) {
        [self.delegate editorViewConfirmRecordVoice];
    }
}

- (void)updateCancelRecordVoice {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editorViewUpdateCancelRecordVoice)]) {
        [self.delegate editorViewUpdateCancelRecordVoice];
    }
}

- (void)updateContinueRecordVoice {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editorViewUpdateContinueRecordVoice)]) {
        [self.delegate editorViewUpdateContinueRecordVoice];
    }
}

@end
