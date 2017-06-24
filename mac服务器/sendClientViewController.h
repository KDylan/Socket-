//
//  sendClientViewController.h
//  mac服务器
//
//  Created by Edge on 2017/6/12.
//  Copyright © 2017年 Edge. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Client.h"
@interface sendClientViewController : NSViewController
//  接收客户端
@property(nonatomic,strong)Client *client;
@end
