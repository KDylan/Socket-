//
//  ClientManagerCoreData.m
//  mac服务器
//
//  Created by Edge on 2017/5/31.
//  Copyright © 2017年 Edge. All rights reserved.
//

#import "ClientManagerCoreData.h"

@implementation ClientManagerCoreData

+(instancetype)shareManager{
    
    static ClientManagerCoreData *shareManager;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        shareManager = [[ClientManagerCoreData alloc]init];
    });
    return shareManager;
}

-(NSManagedObjectContext *)managerContext{
    if (!_managerContext) {
        // 1、 创建上下文
        _managerContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        // 2、 设置持久化协调器
        
        //2.1   创建模型文件
        /* 1- 系统只有一个模型获取方式
         
         */
      //   NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
        //  获取模型
        //  打包名称为nomd
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc]initWithContentsOfURL:[[NSBundle mainBundle]URLForResource:@"CoreDataModel" withExtension:@"momd"]];
        //2.2  模型绑定协调器关联模型文件
        NSPersistentStoreCoordinator *per = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
        
        // 2.3 设置数据库保存路径
        
        NSURL *url = [NSURL fileURLWithPath:@"/Users/edge/Desktop/数据库/Client.db"];
        
        [per addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:nil];
        
        // 2.4  复制给协调器上下文
        _managerContext.persistentStoreCoordinator=per;
    }
    return _managerContext;

}
@end
