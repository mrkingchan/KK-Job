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

//#import "SetupViewController.h"
//#import "PrivacyViewController.h"
//#import "UploadResumeViewController.h"
//#import "AssetsManagementViewController.h"

@interface PersonCenterViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,retain) UICollectionViewFlowLayout * layout;

@property (nonatomic,strong) UICollectionView * collectionView;

@property (nonatomic,copy) NSArray * dataArray;

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


- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.dataArray = @[@[@"1",@"在线简历"],@[@"2",@"附件简历"],@[@"1",@"隐人才钱包"],@[@"2",@"银行卡"],@[@"1",@"收藏夹"],@[@"2",@"邀请函"],@[@"1",@"人才经纪人"],@[@"2",@"进入企业"]];
    self.tabDataArr = @[@[@"通知哦哦哦哦哦哦 哦哦哦哦哦 哦哦哦",@"通知啊啊啊啊啊啊啊啊啊啊"],@[@[@"1",@"隐私设置"],@[@"2",@"通知"]]];
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
        headerView.dataArr = @[];
        headerView.user = @{};
        headerView.mineHeaderClickCallBack = ^(NSInteger index) {
            
        };
        headerView.mineHeaderButtonCallBack = ^(NSInteger index) {
          //10设置 11头像
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
    return UIEdgeInsetsMake(0, 0.25, 0.25, 0);
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
    return (CGSize){kScreenWidth,kScreenHeight/3};
}

/** 底部高度 **/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return (CGSize){kScreenWidth,(self.tabDataArr.count+1)*45+20};
}

#pragma mark ---- UICollectionViewDelegate
// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

/** 表格视图push */
- (void) clickFooterPushWithIndex:(NSInteger)index
{
    
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
