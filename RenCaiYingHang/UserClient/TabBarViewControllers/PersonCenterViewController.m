//
//  PersonCenterViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "PersonCenterViewController.h"

#import "MineCollectionViewCell.h"
#import "MineHeaderView.h"
#import "MineFooterView.h"

#import "BankCardViewController.h"
#import "WalletViewController.h"
#import "SetupViewController.h"
#import "UploadResumeViewController.h"
#import "AgentViewController.h"

//#import "PrivacyViewController.h"
//#import "AssetsManagementViewController.h"

#import "RYAlertAction.h"
#import "JHUploadImage.h"

@interface PersonCenterViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,JHUploadImageDelegate>

@property (nonatomic,retain) UICollectionViewFlowLayout * layout;

@property (nonatomic,strong) UICollectionView * collectionView;

/** 中间按钮 **/
@property (nonatomic,copy) NSArray * dataArray;
/** 上面的个人信息 */
@property (nonatomic,strong) NSMutableArray * topArr;
/** 下面的消息信息 */
@property (nonatomic,copy) NSArray * tabDataArr;

@end

static NSString * cellId = @"MineCollectionViewCell";
static NSString * headerId = @"MineHeaderView";
static NSString * footerId = @"MineFooterView";

@implementation PersonCenterViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:false animated:animated];
}

- (UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
    }
    return _layout;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
       // 自定义的布局对象
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenWidth, kScreenHeight - kStatusBarHeight - KToolHeight) collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = false;
        _collectionView.alwaysBounceVertical = true;
        [self.view addSubview:_collectionView];
        
        // 注册cell、sectionHeader、sectionFooter
        [_collectionView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellWithReuseIdentifier:cellId];
        [_collectionView registerNib:[UINib nibWithNibName:headerId bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
        [_collectionView registerNib:[UINib nibWithNibName:footerId bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
        
    }
    return _collectionView;
}

- (NSMutableArray *)topArr
{
    if (!_topArr) {
        _topArr = [NSMutableArray array];
    }
    return _topArr;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /** 修改了简历 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"resumeStateChange" object:nil];
    
    adjustsScrollViewInsets_NO(self.collectionView, self);
    
    self.collectionView.mj_header = [MyRefreshHeader headerWithRefreshingBlock:^{
       [self.collectionView.mj_header endRefreshing];
       [self requestData];
    }];
    
    [self requestData];
}

- (void) requestData
{
    [UIFactory addLoading];
    
    [RYUserRequest appUsGetBaseInfoSuceess:^(NSDictionary * baseInfo,NSArray * imageArr) {
        [UIFactory removeLoading];
        [self.topArr removeAllObjects];
        [self.topArr addObject:baseInfo];
        if (![VerifyHelper empty:imageArr]) {
            [self.topArr addObject:imageArr];
        }
        [self loadData];
    } failure:^(id errorCode) {
        
    }];
    
    [RYUserRequest centerMessageSucess:^(NSArray *dataArr) {
        [UIFactory removeLoading];
        self.tabDataArr = @[dataArr,@[@[@"private",@"隐私设置"],@[@"notifi",@"通知"]]];
        [self loadData];
    } failure:^(id errorCode) {
        
    }];

}

- (void) loadData
{
    [self.view bringSubviewToFront:self.collectionView];
    self.dataArray = @[@[@"online_resume",@"在线简历"],@[@"near_resume",@"附件简历"],@[@"wallet",@"人才钱包"],@[@"bankcard",@"银行卡"],@[@"collect",@"收藏夹"],@[@"heart",@"邀请函"],@[@"agent",@"人才经纪人"],@[@"entry_company",@"进入企业"]];
    [self.collectionView reloadData];
}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MineCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.img.image = UIIMAGE(self.dataArray[indexPath.row][0]);
    cell.lab.text = self.dataArray[indexPath.row][1];
    return cell;
}

// 和UITableView类似，UICollectionView也可设置段头段尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        MineHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
        for (id view in self.topArr) {
            if ([view isKindOfClass:[NSArray class]]) {
                NSMutableArray * array = [NSMutableArray array];
                for (BannerImageModel * model in view) {
                    [array addObject:model.urlString];
                }
                headerView.dataArr = array.copy;
            }else if ([view isKindOfClass:[NSDictionary class]]){
                headerView.user = view;
            }
        }
        headerView.mineHeaderClickCallBack = ^(NSInteger index) {
            [self imageClickPushWithIndex:index];
        };
        headerView.mineHeaderButtonCallBack = ^(NSInteger index) {
          //10设置 11头像 12更改状态
            [self doSomeHandleWithTag:index];
        };
        headerView.mineHeaderStatusCallBack = ^{
            CommonH5Controller * h5 = [[CommonH5Controller alloc] init];
            h5.url = [UtilityHelper addUrlToken:@"apply/resume/modifyRes"];
            [self.navigationController pushViewController:h5 animated:true];
        };
        return headerView;
    }
    else if([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        MineFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerId forIndexPath:indexPath];
        footerView.dataArr = self.tabDataArr;
        footerView.mineFooterClickCallBack = ^(NSInteger index) {
            [self clickFooterPushWithIndex:index];
        };
        return footerView;
    }

    return nil;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){kScreenWidth/4 - 1,kScreenWidth/4 - 1};
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0.25, 0.5, 0);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.01f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.01f;
}

/** 头部高度 **/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){kScreenWidth,kScreenHeight * 0.4};
}

/** 底部高度 **/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return (CGSize){kScreenWidth,([self.tabDataArr[1] count]+1)*45+20};
}

#pragma mark ---- UICollectionViewDelegate
// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 1:
        {
            UploadResumeViewController * upload = [[UploadResumeViewController alloc] init];
            [self.navigationController pushViewController:upload animated:true];
        }
            break;
        case 7:
        {
            //进入企业
           // [self alertMessageWithViewController:self message:@"敬请期待"];
            
            [UtilityHelper changeClient:1];
        }
            break;
        case 2:
        {
            WalletViewController * h5 = [[WalletViewController alloc] init];
            h5.url = [UtilityHelper addUrlToken:@"apply/trans"];
            h5.jsMethodName = @"recharge";
            h5.type = 0;
            [self.navigationController pushViewController:h5 animated:true];
        }
            break;
        case 3:
        {
            BankCardViewController * h5 = [[BankCardViewController alloc] init];
            h5.url = [UtilityHelper addUrlToken:@"apply/bankcard"];
            h5.jsMethodName = @"unAuthIDCard";
            [self.navigationController pushViewController:h5 animated:true];
        }
            break;
        case 4:
        {
            CommonH5Controller * h5 = [[CommonH5Controller alloc] init];
            h5.url = [UtilityHelper addTokenForUrlSting:[NSString stringWithFormat:@"%@apply/collection",KBaseURL]];
            [self.navigationController pushViewController:h5 animated:true];
            
        }
            break;
        case 0:
        case 5:
        {
            CommonH5Controller * h5 = [[CommonH5Controller alloc] init];
            if (indexPath.row == 0) {
                h5.url = [UtilityHelper addUrlToken:@"apply/resume/modifyRes"];
            }else{
                h5.url = [UtilityHelper addUrlToken:@"apply/invitation"];
            }
            [self.navigationController pushViewController:h5 animated:true];
        }
            break;
        case 6:
        {
            AgentViewController * h5 = [[AgentViewController alloc] init];
            h5.url = [UtilityHelper addUrlToken:@"apply/recommended"];
            [self.navigationController pushViewController:h5 animated:true];
        }
        default:
            break;
    }
}

/** 底部表格视图push */
- (void) clickFooterPushWithIndex:(NSInteger)index
{
    CommonH5Controller * h5 = [[CommonH5Controller alloc] init];
    switch (index) {
        case 0:
        {
            NSString * jsonstr =   [@{@"token":UserInfo.userInfo.token,@"pkey":UserInfo.userInfo.pkey} mj_JSONString];
            ;
            h5.url = [NSString stringWithFormat:@"%@identity/comHideList?resumeId=%@&token=%@",KBaseURL,UserInfo.userInfo.resumeId,[UtilityHelper encryptUseDES2:jsonstr key:DESKEY]];
        }
            break;
        case 1:
            h5.url = [UtilityHelper addUrlToken:@"public/message"];
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:h5 animated:true];
}

/** 头部按钮push */
- (void) doSomeHandleWithTag:(NSInteger) tag
{
    if (tag == 10) {
        [self.navigationController pushViewController:[[SetupViewController alloc] init] animated:true];
    }else if (tag == 11){
        [JHUPLOAD_IMAGE showActionSheetInFatherViewController:self delegate:self canEdit:true];
    }else{
        [self changeStauts];
    }
}

/** 头部图片点击push **/
- (void) imageClickPushWithIndex:(NSInteger) index
{
    for (id arr in self.topArr) {
        if ([arr isKindOfClass:[NSArray class]]) {
            BannerImageModel * model = arr[index];
            AgentViewController * h5 = [[AgentViewController alloc] init];
            h5.url = [UtilityHelper addTokenForUrlSting:model.clickUrl];
            [self.navigationController pushViewController:h5 animated:true];
        }
    }
}

#pragma mark - JHUploadImageDelegate
- (void)uploadImageToServerWithImage:(UIImage *)image OriginImage:(UIImage *)originImage
{
    NSData * imageData = UIImageJPEGRepresentation(image, 0.7);
    NSDictionary * dic = @{@"token":UserInfo.userInfo.token,@"type":@"1"};
    if (![VerifyHelper empty:UserInfo.userInfo.image]) {
        dic = @{@"token":UserInfo.userInfo.token,@"type":@"1",@"filePathOld":UserInfo.userInfo.image};
    }
    
    [NetWorkHelper uploadFileRequest:imageData param:dic method:UploadFiles completeBlock:^(NSDictionary *data) {
        NSDictionary * dic = data[@"rel"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHeaderIcon" object:dic];
    } errorBlock:^(NSError *error) {
        
    } uploadProgress:^(NSProgress *progress) {
        
    }];
    
    NSLog(@"%@\n%@",originImage,image);
}

/** 改变状态 */
- (void) changeStauts
{
    RYAlertAction * action = [[RYAlertAction alloc] initWithFrame:CGRectZero dataArr:@[@"我目前已离职,可快速到岗",@"我目前在职,正考虑换个新环境",@"我暂时不想找工作",@"我是应届毕业生"]];
    [action show];
    
    action.ryAlertActionCall = ^(NSInteger index) {
        [RYUserRequest updateResumeInfoWithParamer:@{@"jobcondition":@(index+1)} suceess:^(BOOL isSuccess) {
            [self requestData];
        } failure:^(id errorCode) {
            
        }];
    };
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
