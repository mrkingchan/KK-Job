//
//  FeebBackViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/8.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "FeebBackViewController.h"

@interface FeebBackViewController ()

///<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
//
//@property (nonatomic,strong) UITableView * tableView;
//
//@property (nonatomic,copy) NSArray * dataArray;

@end

//static NSString * TextViewCellID = @"TextViewCell";

@implementation FeebBackViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //标题
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.jsMethodName = @"FeedBackCallBack";
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    //网页title
    if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.webView)
        {
            self.title = self.webView.title;
        }
    }
}

/**
 与后台协商方法调用
 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"FeedBackCallBack"]) {
        [self.navigationController popViewControllerAnimated:true];
    }
}

- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"title"];
}

//- (UITableView *)tableView
//{
//    if (!_tableView) {
//        _tableView = [UIFactory initTableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped delegate:self];
//        [_tableView registerNib:[UINib nibWithNibName:TextViewCellID bundle:nil] forCellReuseIdentifier:TextViewCellID];
//        [self.view addSubview:_tableView];
//    }
//    return _tableView;
//}
//
//- (UIView *) tableFooterView
//{
//    UIView * footer = [UIFactory initViewWithFrame:CGRectMake(0, 0, kScreenWidth, 80) color:nil];
//    UIButton * loginOutBtn = [UIFactory initBorderButtonWithFrame:CGRectMake(50, 30, kScreenWidth - 100, 45) title:@"提交" textColor:[UIColor darkTextColor] font:systemOfFont(15) cornerRadius:10 bgColor:kWhiteColor borderColor:[UIColor lightGrayColor] borderWidth:0.5 tag:10 target:self action:@selector(buttonClick:)];
//    [footer addSubview:loginOutBtn];
//    return footer;
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    [self configurationTableView];
//}
//
//- (void) configurationTableView
//{
//    self.tableView.tableFooterView = [self tableFooterView];
//    self.dataArray = @[@"你的建议",@"邮箱/QQ／手机"];
//    [self.tableView reloadData];
//}
//
///** 立即认证 **/
//- (void) buttonClick:(UIButton *) sender
//{
//
//}
//
//#pragma mark UITableViewDataSource
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return self.dataArray.count;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    TextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:TextViewCellID];
//    if (indexPath.section == 0) {
//        cell.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        cell.textView.layer.borderWidth = 0.5;
//    }
//    cell.textView.font = systemOfFont(16);
//    cell.textView.placeholder =  indexPath.section == 0 ? @"请输入你的建议" : @"客服会第一时间联系您";
//    cell.textView.delegate = self;
//    cell.textView.tag = indexPath.section;
//    cell.textView.showsVerticalScrollIndicator = false;
//    return cell;
//}
//
//#pragma mark UITableViewDelegate
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return indexPath.section == 0 ? 200 : 50;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 50;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.01;
//}
//
//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    LabelViewCell * cell = [[NSBundle mainBundle] loadNibNamed:@"LabelViewCell" owner:nil options:nil].lastObject;
//    cell.frame = CGRectMake(0, 0, kScreenWidth, 50);
//    cell.textLabel.text = self.dataArray[section];
//    cell.textLabel.font = systemOfFont(16);
//    return cell;
//}
//
//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return nil;
//}
//
//#pragma mark UITextViewDelegate
//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
//{
//    return true;
//}
//
//- (void)textViewDidChange:(UITextView *)textView
//{
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
