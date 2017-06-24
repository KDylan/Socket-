//
//  ClientManagerCoreData.h
//  mac服务器
//
//  Created by Edge on 2017/5/31.
//  Copyright © 2017年 Edge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface ClientManagerCoreData : NSObject
// 管理上下文
@property(nonatomic,strong)NSManagedObjectContext *managerContext;


/**
 *  单例
 */
+(instancetype)shareManager;
@end
