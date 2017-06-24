


//
//  moreClicentViewController.m
//  mac服务器
//
//  Created by Edge on 2017/6/11.
//  Copyright © 2017年 Edge. All rights reserved.
//
#import "sendClientViewController.h"
#import "moreClicentViewController.h"
#import "ClientManagerCoreData.h"
#import "Client.h"
@interface moreClicentViewController ()<NSTableViewDelegate,NSTableViewDataSource>
@property (weak) IBOutlet NSTableView *tableView;

//  数组
@property(nonatomic,strong)NSArray* moreArrEnity;
@property(nonatomic,strong)NSDateFormatter *formate;
@end

@implementation moreClicentViewController

-(NSArray *)moreArrEnity{
    if (!_moreArrEnity) {
        _moreArrEnity = [NSArray array];
    }
    return _moreArrEnity;
    
}
-(NSDateFormatter *)formate{
    if (!_formate) {
    //  创建一个格式
      _formate = [[NSDateFormatter alloc]init];
        _formate.dateFormat = @"yyyy-MM-dd-EEEE a hh:mm:ss:SSS";
     //   NSLog(@"formate = %@",_formate);
        _formate.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
        //  显示星期
        _formate.weekdaySymbols = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    }
    return _formate;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //数据加载
    [self fecthData];
    //  注册通知
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fecthData) name:@"moreClientReload" object:nil];
}

-(void)fecthData{
    
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Client" inManagedObjectContext:[ClientManagerCoreData shareManager].managerContext];
    [fetchRequest setEntity:entity];
  
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"connectTime"
                                                                   ascending:NO];// 按时间降序
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
   // NSError *error = nil;
//    查好的数据放进数组
    self.moreArrEnity = [[ClientManagerCoreData shareManager].managerContext executeFetchRequest:fetchRequest error:nil];
    
//    NSLog(@"%@",self.moreArrEnity);
    //刷新数据
    [self.tableView reloadData];
}

#pragma mark tableViewDatadous

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    
    return self.moreArrEnity.count;
}

- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    
    
    Client *client = self.moreArrEnity[row];// 每行
    
    if ([tableColumn.title isEqualToString:@"ip"]) {
       return  client.potAdress;
    }else if ([tableColumn.title isEqualToString:@"port"])
    {
        
        return client.potNumber;
    }else if ([tableColumn.title isEqualToString:@"connectTime" ]){
        
        return [self.formate stringFromDate:client.connectTime];
    }else if ([tableColumn.title isEqualToString:@"disconnectTime"]){
        
        return [self.formate stringFromDate:client.disconnectTime];
    }else{
        
        return nil;
    }
}
//  选中cell
-(void)tableViewSelectionDidChange:(NSNotification *)notification{
    //  获取客户端 数据
    Client *client = self.moreArrEnity[self.tableView.selectedRow];
    //  执行手动跳转
    [self performSegueWithIdentifier:@"sent" sender:client];
    
}
//  这个方法跳转就会来（手动/自动）
-(void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender{
    
    //  拿到目标控制器
    sendClientViewController *sendVC =segue.destinationController;
    //  赋值参数
    sendVC.client = sender;
}

@end
