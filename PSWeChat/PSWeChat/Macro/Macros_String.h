//
//  Macro_String.h
//  zichan
//
//  Created by Mike on 16/5/16.
//  Copyright © 2016年 Mike. All rights reserved.
//

#ifndef Macro_String_h
#define Macro_String_h

// user default access
#define USERDEFAULT_OBJ4KEY(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define USERDEFAULT_SETOBJ4KEY(obj, key) [[NSUserDefaults standardUserDefaults]setObject:obj forKey:key]

#define USERDEFAULT_BOOL4KEY(key) [[NSUserDefaults standardUserDefaults] boolForKey:key]
#define USERDEFAULT_SETBOOL4KEY(bool, key) [[NSUserDefaults standardUserDefaults] setBool:bool forKey:key]

#define kServerURL (@"kServerURL")
#define kJXHDServerURL (@"kJXHDServerURL")
#define isNotFirstOpenApp (@"isFirstOpenApp")
#define kRememberPassword (@"kRememberPassword")
#define kAutoLogin (@"kAutoLogin")
#define kUsername (@"kUsername")
#define kPassword (@"kPassword")
#define kHandshakePassword (@"kHandshakePassword")
#define kJXHDServerUrl @"JXHDserverUrl"

#pragma mark - 网络请求宏
//网络请求提示宏
#define KREQUESTLOADING @"加载中..."
#define KREQUESTSUCCESS @"请求成功"
#define KREQUESTERROR @"网络异常 请稍后再试"
#define kREQUESTSERVICEERROR @"服务器错误"
#define kREQUESTUNKNOWERROR @"未知错误"
#define KREQUESTNODATA @"暂无数据"
#define KREQUESTNOACCESS @"无权限"
#define KREQUESTOVERTIME @"请求超时"
#define KREQUESTLOGINERROR @"登录失败"
#define KREQUESTADDSUCCESS @"添加成功"
#define KREQUESTADDFAILED @"添加失败"
#define KREQUESTOPERATESUCCESS @"操作成功"
#define KREQUESTOPERATEFAILED @"操作失败"
#define KREQUESTCONTAINILLEGALSTRING @"包含非法字符 请重新输入"
#define KREQUESTPLEASEINPUTALLINFO @"请填写完整信息"
#define KREQUESTLIMITCOUNT @"已经达到输入的最大字数了哦"
#define KCONTENTLIMITCOUNT @"已经达到内容输入的最大字数了哦"
#define KVOTEOPTIONLIMITCOUNT @"已经达到投票选项输入的最大字数了哦"
#define KTHMELIMITCOUNT @"主题最多输入100字"
#define KALBUMNAMELIMITCOUNT @"相册名称最多输入100字"
#define KNAMELIMITCOUNT @"名称最多输入100字"
#define KDESCRIPTIONLIMITCOUNT @"描述最多输入100字"
#define KCOMMENTLIMITCOUNT @"评论最多输入100字"
#define KREQUESTADDING @"提交中..."
#define KCOMFIRMDELETE @"确认删除"
#define KREQUESTATLEASTONECONDITION @"至少选择一个搜索条件"
#define KNODOWNLOAD @"您还没有下载哦~"
#define KHAVELIKED @"您已经点过赞了哦~"
#define KCONTENTCANNOTBEEMPTY @"内容不能为空哦~"

#define KREQUESTDURATIONHALFSECOND 0.5
#define KREQUESTDURATION 1.0
#define KREQUESTONEANDHALFSECOND 1.5

#pragma mark - jxhd code 提示
#define K_JXHD_CODE_TIP_WRONGPASSWORD @"密码错误"
#define K_JXHD_CODE_TIP_ACCOUNTNOTEXIT @"用户不存在"
#define K_JXHD_CODE_TIP_USENAMEORPASSWORDROERROR @"用户名或密码错误"

/**
 *  请输入文字描述宏
 */
#define INPUTDESCRIPTION @"请输入文字描述"
#define KPLEASEINPUT (@"请输入文字")
#define KPLAEASECHOOSE (@"请选择")
#define KDEVELOPING @"此模块正在开发中，下一版即将上线"
#define KDOWNLOADALREADY @"此文件已下载，请在已下载中查看"
#define KCHOOSEWRONGTIME @"您选择的结束时间不对，请重新选择"
#define KONLYINPUTNUMBER @"您只能输入整数哦~"
#define KINPUTUNZERO @"您不能输入0开头的数字哦~"
#define KDOWNLOADSUCCESS @"下载成功"
#define KDOWNLOADFAIL @"下载失败,请稍后再试"
#define KREPAIRSTILLHAVENOTCOMMENT @"您还有报修未评价，请评价后再添加"
#define KCANNOTDELETETHISCOMMENT (@"您不能删除此评论哟")

#define KREQUESTCHANGEPASSWORDSUCCESS @"密码修改成功"
#define KREQUESTCHANGEPASSWORDFAILED @"密码修改失败"


/**
 *  是否第一次出现,0表示第一次出现，1表示出现了好多次
 */
#define KNOTIFY_FIRSTSHOW @"kfirstShow"

//家校互动
#define K_NOTICE_PATH (@"notice") //家校互动通知模块
#define K_WORK_PATH (@"work") //作业模块
#define K_VOTE_PATH (@"vote") //投票模块
#define K_ACTIVITY_PATH (@"activity") //活动模块
#define K_BOOK_PATH (@"book") //荐书模块
#define K_ALBUM_PATH (@"album") //相册模块
#define K_RESOURCE_PATH (@"resource") //资料模块
#define K_SHARE_PATH (@"share") //分享模块
#define K_ASK_PATH (@"ask") //提问模块
#define K_APPENDIX_PATH (@"appendix") //东华门的所有都放在一个文件夹下

#endif /* Macro_String_h */
