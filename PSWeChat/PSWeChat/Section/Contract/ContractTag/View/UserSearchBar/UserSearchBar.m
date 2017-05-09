//
//  UserSearchBar.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/5/2.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "UserSearchBar.h"
#import "UITextField+DeleteBackward.h"


@implementation UserSearchBarItem

- (void)setUser:(FriendModel *)user {
    _user = user;
    if ([user.photo hasPrefix:@"http"]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:user.photo] placeholderImage:[UIImage imageNamed:@"contacts_groupinfo_avator_default"]];
    } else {
        [self setImage:[UIImage imageNamed:user.photo] forState:UIControlStateNormal];
    }
}

@end

@implementation UserSearchBar

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.searchTextView.delegate = self;
    self.userScrollView.delegate = self;
    self.searchTextView.returnKeyType = UIReturnKeySearch;
    self.dataLiatArray = [NSMutableArray array];
    self.items = [NSMutableArray array];
    
    UIImage *image = [UIImage imageNamed:@"tt_search"];
    UserSearchBarItem *search = [[UserSearchBarItem alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [search setImage:image forState:UIControlStateNormal];
    [search setContentMode:UIViewContentModeCenter];
    [self.userScrollView addSubview:search];
    self.searchItem = search;
    
    [self addObserver:self forKeyPath:@"dataLiatArray" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.dataLiatArray = [NSMutableArray array];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
   
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame = CGRectMake(0, 0, self.dataLiatArray.count * 54, self.height);
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.userScrollView = scrollView;
    UITextField *textField = [[UITextField alloc]init];
    textField.frame = CGRectMake(scrollView.right +10, 10, K_SCREEN_WIDTH - (self.dataLiatArray.count * 54) , self.height - 20);
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    self.searchTextView = textField;
    textField.placeholder = @"搜索";
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 0.5, K_SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView];
    [self addSubview:scrollView];
    [self addSubview:textField];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat margin = 8;
    [self.items enumerateObjectsUsingBlock:^(UserSearchBarItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        [item setFrame:CGRectMake(margin + idx * (40) , margin, 30, 30)];
    }];
}

#pragma mark - UItextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(!self.dataLiatArray.count) {
    }
    [self.searchItem removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)]) {
        return [self.delegate searchBarShouldBeginEditing:self];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (!textField.text.length && !self.dataLiatArray.count) {
        if (![self.userScrollView.subviews containsObject:self.searchItem]) {
//            self.wj_scrollWidthConstraint.constant = 50;
            [self.userScrollView addSubview:self.searchItem];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
        return [self.delegate searchBarShouldEndEditing:self];
    }
    
    return YES;
}

- (void)textFieldDidChange:(NSNotification *)notification{
    UITextField *textField = notification.object;
    if (!notification||textField == self.searchTextView) {
        
        NSLog(@"textFieldDidChange");
        [self unSelectedItems];
        if ([self.delegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
            [self.delegate searchBar:self textDidChange:textField.text];
        }
    }
}

- (void)textFieldDidDeleteBackward:(UITextField *)textField {
    if (textField.text.length == 0) {
        FriendModel *user = [self.dataLiatArray lastObject];
        if ([self isSelectedItem:user]) {
            [self removeUser:user];
        } else {
            [self selectItem:user];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    return YES;
}

#pragma mark scroll item
- (void)addScrollItem:(FriendModel *)user {
    if ([self.dataLiatArray containsObject:user]) {
        UserSearchBarItem *item = [[UserSearchBarItem alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        [item setUser:user];
        [item addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.userScrollView addSubview:item];
        [self.items addObject:item];
        [self setNeedsLayout];
        [self unSelectedItems];
    }
}

- (void)clickItem:(UserSearchBarItem *)item {
    [self removeUser:item.user];
}

- (BOOL)isSelectedItem:(FriendModel *)user {
    if (!user) {
        return NO;
    }
    NSInteger index = [self.dataLiatArray indexOfObject:user];
    UserSearchBarItem *item = [self.items objectAtIndex:index];
    if (item) {
        return item.selected;
    }
    return NO;
}

- (void)unSelectedItems {
    __weak typeof(self) weakSelf = self;
    [self.dataLiatArray enumerateObjectsUsingBlock:^(FriendModel *obj, NSUInteger idx, BOOL *stop) {
        NSInteger index = [self.dataLiatArray indexOfObject:obj];
        UserSearchBarItem *item = [weakSelf.items objectAtIndex:index];
        if (item) {
            [item setHighlighted:NO];
            item.selected = NO;
        }
    }];
}

- (void)selectItem:(FriendModel *)user {
    if (!user) {
        return;
    }
    NSInteger index = [self.dataLiatArray indexOfObject:user];
    UserSearchBarItem *item = [self.items objectAtIndex:index];
    if (item) {
        [item setHighlighted:YES];
        item.selected = YES;
    }
}

- (void)removeScrollItem:(FriendModel *)user {
    if (!user) {
        return;
    }
    NSInteger index = [self.dataLiatArray indexOfObject:user];
    UserSearchBarItem *item = [self.items objectAtIndex:index];
    [self unSelectedItems];
    if (item) {
        [item removeFromSuperview];
        [self.items removeObjectAtIndex:index];
        [self setNeedsLayout];
    }
}

- (BOOL)resignFirstResponder {
    [super resignFirstResponder];
    return [self.searchTextView resignFirstResponder];
}

- (BOOL)becomeFirstResponder {
    [super becomeFirstResponder];
    return [self.searchTextView becomeFirstResponder];
}

- (BOOL)isFirstResponder {
    [super isFirstResponder];
    return [self.searchTextView isFirstResponder];
}


#pragma mark public
- (void)removeUser:(FriendModel *)user {
    if ([self.dataLiatArray containsObject:user]) {
        [self removeScrollItem:user];
        [[self mutableArrayValueForKey:@"dataLiatArray"] removeObject:user];
        if ([self.delegate respondsToSelector:@selector(searchBar:removeUser:)]) {
            [self.delegate searchBar:self removeUser:user];
        }
    }
}
- (void)addUser:(FriendModel *)user {
    if (!user || [self.dataLiatArray containsObject:user]) {
        return;
    }
//    [[self mutableArrayValueForKey:@"dataLiatArray"] addObject:user];
    [self.dataLiatArray addObject:user];
    self.userScrollView.frame = CGRectMake(self.dataLiatArray.count * 54, 10, 54, 54);
    self.searchTextView.frame = CGRectMake(self.userScrollView.right + 10, 10, 100, self.height - 20);
    [self addScrollItem:user];
}


#pragma mark - kvo

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"dataLiatArray"]) {
        CGFloat w = 8 + self.dataLiatArray.count * (40);
        if(![self.searchTextView isFirstResponder] && self.dataLiatArray.count == 0){
//            self.wj_scrollWidthConstraint.constant = 50;
            w = 50;
            if (![self.userScrollView.subviews containsObject:self.searchItem]) {
                [self.userScrollView addSubview:self.searchItem];
            }
        } else if(self.dataLiatArray.count <= 6) {
//            self.wj_scrollWidthConstraint.constant = w;
            [self.searchItem removeFromSuperview];
        }
        [self.userScrollView setContentSize:CGSizeMake(w, 0)];
        [self.userScrollView setContentOffset:CGPointMake(self.dataLiatArray.count * 54, 0) animated:YES];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
