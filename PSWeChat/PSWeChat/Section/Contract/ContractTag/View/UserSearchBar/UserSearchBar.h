//
//  UserSearchBar.h
//  PSWeChat
//
//  Created by 思 彭 on 2017/5/2.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendModel.h"

@class UserSearchBar;

@protocol UserSearchBarDelegate <NSObject>
@optional

- (BOOL)searchBarShouldBeginEditing:(UserSearchBar *)searchBar;

- (BOOL)searchBarShouldEndEditing:(UserSearchBar *)searchBar;

- (void)searchBar:(UserSearchBar *)searchBar textDidChange:(NSString *)searchText;

- (void)searchBar:(UserSearchBar *)searchBar removeUser:(FriendModel *) user;

@end

@interface UserSearchBarItem : UIButton

@property (strong, nonatomic) FriendModel *user;

@end

@interface UserSearchBar : UIView <UIScrollViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) id <UserSearchBarDelegate> delegate;
@property (weak, nonatomic) UIScrollView *userScrollView;
@property (weak, nonatomic) UITextField *searchTextView;

@property (nonatomic, strong) NSMutableArray *dataLiatArray;
@property (nonatomic, strong) NSMutableArray <UserSearchBarItem *>*items;
@property (nonatomic, strong) UserSearchBarItem *searchItem;

- (void)setText:(NSString *)text;
- (void)addUser:(FriendModel *)user;
- (void)removeUser:(FriendModel *)user;

@end
