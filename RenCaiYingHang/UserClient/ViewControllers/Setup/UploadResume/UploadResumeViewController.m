//
//  UploadResumeViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "UploadResumeViewController.h"

#import <HUPhotoBrowser.h>

#import "JHUploadImage.h"

#import "RYProgressView.h"

@interface UploadResumeViewController ()<JHUploadImageDelegate>

@property (nonatomic,strong) UIImageView * imageView;

@property (nonatomic,strong) UIButton * submitBtn;

@property (nonatomic,strong) UILabel * showMsgLabel;

@property (nonatomic,strong) RYProgressView * progressView;

@end

@implementation UploadResumeViewController

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth*0.3, kScreenHeight * 0.2, kScreenWidth * 0.4, kScreenWidth * 0.4)];
        _imageView.image = UIIMAGE(@"noresume");
        _imageView.userInteractionEnabled = true;
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)showMsgLabel
{
    if (!_showMsgLabel) {
        _showMsgLabel = [UIFactory initLableWithFrame:CGRectMake(20, self.imageView.bottom + 15, kScreenWidth - 40, 20) title:@"" textColor:UIColorHex(999999) font:systemOfFont(16) textAlignment:1];
        [self.view addSubview:_showMsgLabel];
    }
    return _showMsgLabel;
}

- (UIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [UIFactory initButtonWithFrame: CGRectMake(kScreenWidth * 0.15, kScreenHeight * 0.7, kScreenWidth * 0.7, 40*AdaptiveRate) title:@"" textColor:kWhiteColor font:systemOfFont(16) cornerRadius:5 tag:10 target:self action:@selector(postImg:)];
        [_submitBtn setBackgroundColor:kNavBarTintColor];
        [self.view addSubview:_submitBtn];
    }
    return _submitBtn;
}

- (RYProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[RYProgressView alloc]initWithFrame:self.imageView.bounds];
        _progressView.arcFinishColor = UIColorHex(@"#75AB33");
        _progressView.arcUnfinishColor = UIColorHex(@"#0D6FAE");
        [self.imageView addSubview:_progressView];
    }
    return _progressView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"附件简历";
    
    
    self.imageView.image = [VerifyHelper empty:UserInfo.userInfo.resumeImage] ? UIIMAGE(@"noresume") : UIIMAGE(@"fj_resume");

    self.showMsgLabel.text = [VerifyHelper empty:UserInfo.userInfo.resumeImage] ? @"暂无简历" : [NSString stringWithFormat:@"%@",[UserInfo.userInfo.name componentsSeparatedByString:@"/"][1]];
    self.showMsgLabel.textColor = [VerifyHelper empty:UserInfo.userInfo.resumeImage] ? UIColorHex(999999) :kNavBarTintColor;
    [self.submitBtn setTitle:[VerifyHelper empty:UserInfo.userInfo.resumeImage] ? @"上传":@"重新上传" forState:UIControlStateNormal];
    
    
    if (![VerifyHelper empty:UserInfo.userInfo.resumeImage]) {
        UIButton * see = [UIFactory initButtonWithFrame:CGRectMake(0, 0, 42, 40) title:@"预览" textColor:kWhiteColor font:systemOfFont(14) cornerRadius:0 tag:10 target:self action:@selector(bigscale:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:see];
    }
}

/** 放大了看 */
- (void) bigscale:(UIButton *) sender
{
    if ([VerifyHelper empty:UserInfo.userInfo.resumeImage]) {
        return;
    }
    [HUPhotoBrowser showFromImageView:self.imageView withURLStrings:@[[NSString stringWithFormat:@"%@%@",KIMGURL,UserInfo.userInfo.resumeImage]] atIndex:0];
}

/** 上传图片 **/
- (void) postImg:(UIButton *) sender
{
   [JHUPLOAD_IMAGE showActionSheetInFatherViewController:self delegate:self canEdit:false];
}

#pragma mark - JHUploadImageDelegate
- (void)uploadImageToServerWithImage:(UIImage *)image OriginImage:(UIImage *)originImage
{
    NSDictionary * dic = @{@"token":UserInfo.userInfo.token,@"type":@"2"};
    if (![VerifyHelper empty:UserInfo.userInfo.resumeImage]) {
        dic = @{@"token":UserInfo.userInfo.token,@"type":@"2",@"filePathOld":UserInfo.userInfo.image};
    }
    
    //开始上传就显示进度条
    self.progressView.hidden = false;
    self.progressView.percent = 0;
    
    NSData * imageData = UIImageJPEGRepresentation(originImage, 0.7);
    [NetWorkHelper uploadFileRequest:imageData param:dic method:UploadFiles completeBlock:^(NSDictionary *data) {
        self.showMsgLabel.text = [NSString stringWithFormat:@"%@",data[@"fileName"]];
        self.imageView.image = UIIMAGE(@"fj_resume");
        [self showAlertWithTitle:@"上传成功" message:@"" appearanceProcess:^(EJAlertViewController * _Nonnull alertMaker) {
            alertMaker.addActionCancelTitle(@"确定");
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, EJAlertViewController * _Nonnull alertSelf) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"resumeStateChange" object:nil];
        }];
    } errorBlock:^(NSError *error) {
        self.progressView.hidden = true;
    } uploadProgress:^(NSProgress *progress) {
        self.progressView.percent = [progress fractionCompleted];
        if ([progress fractionCompleted] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.hidden = true;
            });
        }
    }];
    NSLog(@"%@\n%@",originImage,image);
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
