//
//  Client+CoreDataProperties.h
//  mac服务器
//
//  Created by Edge on 2017/5/31.
//  Copyright © 2017年 Edge. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Client.h"

NS_ASSUME_NONNULL_BEGIN

@interface Client (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *potNumber;
@property (nullable, nonatomic, retain) NSString *potAdress;
@property (nullable, nonatomic, retain) NSDate *connectTime;
@property (nullable, nonatomic, retain) NSDate *disconnectTime;

@end

NS_ASSUME_NONNULL_END
