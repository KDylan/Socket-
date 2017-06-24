//
//  sendClientViewController.m
//  mac服务器
//
//  Created by Edge on 2017/6/12.
//  Copyright © 2017年 Edge. All rights reserved.
//

#import "sendClientViewController.h"

@interface sendClientViewController ()
@property (weak) IBOutlet NSTextField *textFiled;
@property (weak) IBOutlet NSButton *sendMessageBtn;

@end

@implementation sendClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   //  设置标题
    self.title = [NSString stringWithFormat:@"IP:%@   Port:%@",_client.potAdress,_client.potNumber];
}

// v发送数据
- (IBAction)sendClientBtn:(NSButton *)sender {
    //  字典传参数
    NSDictionary *dict =@{
                          @"message":_textFiled.stringValue,
                           @"client":_client// 哪个客户端(ip+port)
                          };
    //  发送通知(发送的消息)
    [[NSNotificationCenter defaultCenter]postNotificationName:@"sendMessage" object:nil userInfo:dict];
//    NSLog(@"message=%@",_textFiled.stringValue);
//
//     NSLog(@"_client=%@",_client);
}

@end
