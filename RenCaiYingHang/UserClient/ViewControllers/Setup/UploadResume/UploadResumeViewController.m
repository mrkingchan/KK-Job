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
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth*0.35, kScreenHeight * 0.2, kScreenWidth * 0.3, kScreenWidth * 0.3)];
        _imageView.image = UIIMAGE(@"noresume");
        _imageView.layer.cornerRadius = kScreenWidth * 0.15;
        _imageView.clipsToBounds = true;
        _imageView.userInteractionEnabled = true;
        [self.view addSubview:_imageView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigscale:)];
        [_imageView addGestureRecognizer:tap];
    }
    return _imageView;
}

- (UILabel *)showMsgLabel
{
    if (!_showMsgLabel) {
        _showMsgLabel = [UIFactory initLableWithFrame:CGRectMake(20, self.imageView.bottom + 10, kScreenWidth - 40, 20) title:@"暂无简历" textColor:UIColorHex(999999) font:systemOfFont(16) textAlignment:1];
        [self.view addSubview:_showMsgLabel];
    }
    return _showMsgLabel;
}

- (UIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [UIFactory initBorderButtonWithFrame:CGRectMake(kScreenWidth * 0.15, kScreenHeight * 0.7, kScreenWidth * 0.7, 40) title:@"上传" textColor:[UIColor darkTextColor] font: systemOfFont(16) cornerRadius:5 bgColor:Color235 borderColor:UIColorHex(999999) borderWidth:0.5 tag:10 target:self action:@selector(postImg:)];
       // [self.view addSubview:_submitBtn];
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
    self.title = @"附近简历";
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KIMGURL,UserInfo.userInfo.resumeImage]] placeholderImage:UIIMAGE(@"noresume")];
    self.showMsgLabel.hidden = [VerifyHelper empty:UserInfo.userInfo.resumeImage];
    [self.view addSubview:self.submitBtn];
}

/** 放大了看 */
- (void) bigscale:(UITapGestureRecognizer *) tapView
{
    if ([VerifyHelper empty:UserInfo.userInfo.resumeImage]) {
        return;
    }
    [HUPhotoBrowser showFromImageView:self.imageView withImages:@[self.imageView.image] atIndex:0];
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
    NSData * imageData = UIImageJPEGRepresentation(originImage, 0.7);
    [NetWorkHelper uploadFileRequest:imageData param:dic method:UploadFiles completeBlock:^(NSDictionary *data) {
        self.showMsgLabel.hidden = true;
        self.imageView.image = originImage;
    } errorBlock:^(NSError *error) {
        
    } uploadProgress:^(NSProgress *progress) {
        self.progressView.hidden = false;
        self.progressView.percent = [progress fractionCompleted];
        if ([progress fractionCompleted] == 1) {
            self.progressView.hidden = true;
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
