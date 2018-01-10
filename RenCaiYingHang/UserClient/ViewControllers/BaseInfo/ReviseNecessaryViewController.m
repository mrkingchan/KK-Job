//
//  ReviseNecessaryViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/8.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "ReviseNecessaryViewController.h"

@interface ReviseNecessaryViewController ()

@property (nonatomic, retain) UILabel * showMessage;

@property (nonatomic, retain) TextViewCell *  cell;

@end

@implementation ReviseNecessaryViewController

/** 提示限制字数 */
- (UILabel *)showMessage
{
    if (!_showMessage) {
        _showMessage = [UIFactory initLableWithFrame:CGRectZero title:[NSString stringWithFormat:@"0/%zd",_maxLength] textColor:[UIColor darkTextColor] font:systemOfFont(16) textAlignment:2];
        [self.view addSubview:_showMessage];
    }
    return _showMessage;
}

- (TextViewCell *)cell
{
    if (!_cell) {
        _cell = [[NSBundle mainBundle] loadNibNamed:@"TextViewCell" owner:nil options:nil].lastObject;
        _cell.frame = CGRectMake(0, KNavBarHeight + 10, kScreenWidth, 50);
        _cell.textView.placeholder = [NSString stringWithFormat:@"请输入%@",self.title];
        _cell.textView.showsVerticalScrollIndicator = false;
        [self.view addSubview:_cell];
    }
    return _cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:UIIMAGE(@"checkbox_chosed") style:UIBarButtonItemStylePlain target:self action:@selector(commitData:)];
}

/** 数据提交 **/
- (void) commitData:(UIBarButtonItem *)sender
{
    if ([VerifyHelper empty:self.cell.textView.text]) {
        [self alertMessageWithViewController:self message:@"内容为空无法提交"];
        return;
    }
    if (_reviseNecessaryCall) {
        _reviseNecessaryCall(self.cell.textView.text);
    }
    [self.navigationController popViewControllerAnimated:true];
}

/** 限制字数 */
- (void)textViewDidChange:(UITextView *)textView {
    
    //    对占位符的显示和隐藏做判断
    if (self.cell.textView.text.length == 0) {
        self.cell.textView.placeholder = [NSString stringWithFormat:@"请输入%@",self.title];
    }else {
        self.cell.textView.placeholder = @"";
    }
    
    //    读出textView字符长度
    self.showMessage.text = [NSString stringWithFormat:@"%lu/%zd", self.cell.textView.text.length,_maxLength];
    //self.showMessage.text = [NSString stringWithFormat:@"%lu/40",40 - self.cell.textView.text.length];
    
    if (self.cell.textView.text.length > _maxLength) {
        // 对超出的部分进行剪切
        self.cell.textView.text = [self.cell.textView.text substringToIndex:40];
        self.showMessage.text = [NSString stringWithFormat:@"%lu/%zd",_maxLength,_maxLength];
        
    }
    
    if (self.cell.textView.text.length >= _maxLength) {
        [self alertMessageWithViewController:self message:[NSString stringWithFormat:@"亲!最多只能输入%zd个字!请您合理安排内容!",_maxLength]];
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
