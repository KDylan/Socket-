//
//  ViewController.m
//  mac服务器
//
//  Created by Edge on 2017/5/16.
//  Copyright © 2017年 Edge. All rights reserved.
//

#import "ViewController.h"
#import "ClientManagerCoreData.h"
#import "Client.h"

@interface ViewController()<GCDAsyncSocketDelegate>
//端口号
@property (weak) IBOutlet NSTextField *poetNum;

//保存scoket
@property(copy,nonatomic)NSMutableArray *scoketArr;

@end
@implementation ViewController
-(NSMutableArray *)scoketArr{
    if (!_scoketArr) {
        _scoketArr = [NSMutableArray array];
    }
    return _scoketArr;
}
//  懒加载服务器连接管道
-(GCDAsyncSocket *)server{
    if (!_server) {
        _server = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _server;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _server.delegate = self;
    
  
}


- (IBAction)listenScoket:(id)sender {
    
    //  使用scoket 监听和绑定
    [self.server acceptOnPort:self.poetNum.intValue error:nil];
    
    //  注册endController通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendMeaasgeNotificationCenter:) name:@"sendMessage" object:nil];
}

// 接收到的通知
-(void)sendMeaasgeNotificationCenter:(NSNotification *)nofification {
    //  接收到的参数
    NSDictionary *dict = nofification.userInfo;
    //  实体类
    Client *client = dict[@"client"];
    //  消息
    NSString *message = dict[@"message"];
    
//    //  拿出ip+port比较确定哪个服务器
//    for (GCDAsyncSocket *socket in _scoketArr) {
//        if ([socket.connectedHost isEqualToString:client.potAdress]&&
//            socket.connectedPort == client.potNumber) {
//            // 找到ip和post
//
//        }
//    }
    
    //  拿到想要的socket（ip+port一致）
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"connectedHost = %@ and connectedPort = %@",client.potAdress,client.potNumber];
    //  按照要去查找指定元素
    NSArray *temp = [_scoketArr filteredArrayUsingPredicate:pre];
    
    if (temp.count!=0) {
        
    for (GCDAsyncSocket *socket in temp) {
//  如果拿到说明在线
            [socket writeData:[message dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:socket.connectedPort];
        }
    }else{
            
            NSLog(@"用户下线了");
        }
    }


/**
 *  通过代理告诉我们有新的客户端连接服务器
 *
 *  @param sock      服务器socket
 *  @param newSocket 新来的客户端
 */
-(void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket{
    
    //  持有newScoket不让释放
    [self.scoketArr addObject:newSocket];
    //  存储数据
    Client *client = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Client class]) inManagedObjectContext:[ClientManagerCoreData shareManager].managerContext];
     //  赋值属性
    client.potAdress = newSocket.connectedHost;
    client.potNumber = @(newSocket.connectedPort);
    client.connectTime = [NSDate date];
    client.disconnectTime = nil;
    
    //  提交保存
    [[ClientManagerCoreData shareManager].managerContext save:nil];
   NSLog(@"new%@R",newSocket);
    
    //  通过当前scoket读取数据
    [newSocket readDataWithTimeout:-1 tag:self.scoketArr.count];
    
    // 通知更多界面添加监听
    [[NSNotificationCenter defaultCenter]postNotificationName:@"moreClientReload" object:nil];
    
}

//  通过代理接收数据
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    NSLog(@" 客户端 = %@  ,tag=%ld",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding],tag);
    
    //  重新开始读取数据(不断读取)
  //  NSLog(@"%ld",tag);
    [self.scoketArr[tag-1] readDataWithTimeout:-1 tag:tag];
    
}

@end
