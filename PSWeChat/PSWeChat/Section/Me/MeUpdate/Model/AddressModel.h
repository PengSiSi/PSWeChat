//
//  AddressModel.h
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/20.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject

@property (nonatomic, copy) NSString *addressId;
@property (nonatomic, copy) NSString *contactName; /**< 联系人 */
@property (nonatomic, copy) NSString *telNum; /**<联系电话 */
@property (nonatomic, copy) NSString *area; /**<地区 */
@property (nonatomic, copy) NSString *detailAddress; /**<详细地址 */
@property (nonatomic, copy) NSString *zipCode; /**<邮政编码 */

@end
