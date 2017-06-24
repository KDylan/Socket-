//
//  ViewController.h
//  mac服务器
//
//  Created by Edge on 2017/5/16.
//  Copyright © 2017年 Edge. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GCDAsyncSocket.h"
@interface ViewController : NSViewController

/**
 *  设置一个服务器
 */
@property(nonatomic,strong)GCDAsyncSocket *server;
@end

