//
//  AddPrivacyCompanyViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "AddPrivacyCompanyViewController.h"

#define MaxCompanyNameLength 40

@interface AddPrivacyCompanyViewController ()

@property (nonatomic, retain) UILabel * showMessage;

@property (nonatomic, retain) TextViewCell *  cell;

@end

@implementation AddPrivacyCompanyViewController

/** 提示限制字数 */
- (UILabel *)showMessage
{
    if (!_showMessage) {
        _showMessage = [UIFactory initLableWithFrame:CGRectZero title:[NSString stringWithFormat:@"0/%zd",MaxCompanyNameLength] textColor:[UIColor darkTextColor] font:systemOfFont(16) textAlignment:2];
        [self.view addSubview:_showMessage];
    }
    return _showMessage;
}

- (TextViewCell *)cell
{
    if (!_cell) {
        _cell = [[NSBundle mainBundle] loadNibNamed:@"TextViewCell" owner:nil options:nil].lastObject;
        _cell.frame = CGRectMake(0, KNavBarHeight + 10, kScreenWidth, 50);
        _cell.textView.placeholder = @"请输入公司名称";
        _cell.textView.showsVerticalScrollIndicator = false;
        [self.view addSubview:_cell];
    }
    return _cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"不让以下公司看到我";
    self.view.backgroundColor = Color235;
    [self regsiterNotcification];
    [self configurationUI];
}

/** 注册通知 */
- (void) regsiterNotcification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object:nil];
}

/** 主UI */
- (void) configurationUI
{
    self.showMessage.frame = CGRectMake(self.view.width - 80, self.cell.bottom + 10, 70, 30);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIIMAGE(@"checkbox_chosed") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(commitData:)];
//    self.showMessage.sd_layout.leftSpaceToView(self.view, kScreenWidth - 80).topSpaceToView(self.cell, 10).widthIs(70).heightIs(30);
}

/** 数据提交 **/
- (void) commitData:(UIBarButtonItem *)sender
{
    if ([VerifyHelper empty:self.cell.textView.text]) {
        [self alertMessageWithViewController:self message:@"内容为空无法提交"];
        return;
    }
    
    LoadingView * loading = [[LoadingView alloc] initWithFrame:CGRectZero];
    [loading show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [loading dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTableView" object:@{@"companyName":self.cell.textView.text}];
        [self.navigationController popViewControllerAnimated:true];
    });
}

/** 限制字数 */
- (void)textViewDidChange:(UITextView *)textView {
    
    //    对占位符的显示和隐藏做判断
    if (self.cell.textView.text.length == 0) {
         self.cell.textView.placeholder = @"请输入公司名称";
    }else {
        self.cell.textView.placeholder = @"";
    }
    
    //    读出textView字符长度
    self.showMessage.text = [NSString stringWithFormat:@"%lu/%zd", self.cell.textView.text.length,MaxCompanyNameLength];
    //self.showMessage.text = [NSString stringWithFormat:@"%lu/40",40 - self.cell.textView.text.length];
    
    if (self.cell.textView.text.length > MaxCompanyNameLength) {
        // 对超出的部分进行剪切
        self.cell.textView.text = [self.cell.textView.text substringToIndex:MaxCompanyNameLength];
        self.showMessage.text = [NSString stringWithFormat:@"%zd/%zd", MaxCompanyNameLength,MaxCompanyNameLength];
        
    }
    
    if (self.cell.textView.text.length >= MaxCompanyNameLength) {
        [self alertMessageWithViewController:self message:[NSString stringWithFormat:@"亲!最多只能输入%zd个字!请您合理安排内容!",MaxCompanyNameLength]];
    }
}

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
