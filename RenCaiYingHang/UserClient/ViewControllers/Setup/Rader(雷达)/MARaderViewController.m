//
//  MARaderViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2018/1/5.
//  Copyright © 2018年 Macx. All rights reserved.
//

#import "MARaderViewController.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

// 自定义大头针 气泡
#import "CustomAnnotationView.h"
#import "CurrentLocationAnnotation.h"

#import "JXMapNavigationView.h"

#import "RaderSearchViewCell.h"
#import "CollectionViewCell.h"

#import "JobDetailViewController.h"
#import "CompanyDetailViewController.h"

#define RADIUS 5000

@interface MARaderViewController ()<MAMapViewDelegate,AMapSearchDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

// 地图
@property (nonatomic, strong) MAMapView            *mapView;

// 搜索引擎
@property (nonatomic, strong) AMapSearchAPI        *search;

// 自定义大头针
@property (nonatomic, strong) UIImageView          *centerAnnotationView;
// 防止重复点击
@property (nonatomic, assign) BOOL                  isMapViewRegionChangedFromTableView;

@property (nonatomic, assign) BOOL isfirst;

// 坐标数据源
@property (nonatomic, strong) NSMutableArray *searchPoiArray;

@property (nonatomic, copy) NSString * keywords;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray * dataArray;

@end

const static NSString *TableID = @"5a4d99d07bbf195075efcd72";
static NSString * identifier = @"CollectionViewCell";

@implementation MARaderViewController

#pragma mark - Utility


#pragma mark - MapViewDelegate
/**
 * @brief 地图区域改变完成后会调用此接口
 * @param mapView 地图View
 * @param animated 是否动画
 */
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //1
    // 防止重复点击
    if (!self.isMapViewRegionChangedFromTableView && self.mapView.userTrackingMode == MAUserTrackingModeNone)
    {
        [self cloudPlaceAroundSearch:self.mapView.centerCoordinate keywords:@""];
    }
    self.isMapViewRegionChangedFromTableView = NO;
}

#pragma mark - userLocation
/**
 * 当userTrackingMode改变时，调用此接口
 * 地图View
 * 改变后的
 * 动画
 */
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(!updatingLocation)
        return ;
    
    if (userLocation.location.horizontalAccuracy < 0)
    {
        return ;
    }
    if (!_isfirst) {
        _isfirst = true;
        self.mapView.userTrackingMode = MAUserTrackingModeFollow;
         [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
        [self cloudPlaceAroundSearch:userLocation.location.coordinate keywords:@""];
    }
}

/**
 * @brief 当userTrackingMode改变时，调用此接口
 * @param mapView 地图View
 * @param mode 改变后的mode
 * @param animated 动画
 */
- (void)mapView:(MAMapView *)mapView  didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated
{
    
}

/**
 * @brief 定位失败后，会调用此函数
 * @param mapView 地图View
 * @param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"error = %@",error);
}


/**
 * @brief 根据anntation生成对应的View
 * @param mapView 地图View
 * @param annotation 指定的标注
 * @return 生成的标注View
 */
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    //7
    // 自定义坐标
    if ([annotation isKindOfClass:[CurrentLocationAnnotation class]])
    {
        static NSString *reuseIndetifier = @"CustomAnnotationView";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"mapAddress"];
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;
        
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}

/**
 * @brief Cloud查询回调函数
 * @param request  发起的请求，具体字段参考 AMapPOISearchBaseRequest 及其子类。
 * @param response 响应结果，具体字段参考 AMapPOISearchResponse 。
 */
- (void)onCloudSearchDone:(AMapCloudSearchBaseRequest *)request response:(AMapCloudPOISearchResponse *)response
{
  //  [XYQProgressHUD hideHUD];
    
    [self.mapView removeAnnotations:self.searchPoiArray];
    [self.searchPoiArray removeAllObjects];
    [self.dataArray removeAllObjects];
    
    if (response.POIs.count == 0)
    {
        return;
    }

    //解析response获取POI信息，具体解析见 Demo
    NSLog(@" >>> %@",response.POIs);
    
    [response.POIs enumerateObjectsUsingBlock:^(AMapCloudPOI * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 这里使用了自定义的坐标是为了区分系统坐标 不然蓝点会被替代
        CurrentLocationAnnotation *annotation = [[CurrentLocationAnnotation alloc] init];
        [annotation setCoordinate:CLLocationCoordinate2DMake(obj.location.latitude, obj.location.longitude)];
        [annotation setTitle:[NSString stringWithFormat:@"%@ - %ldm", obj.name, (long)obj.distance]];
        [annotation setSubtitle:obj.address];
        [annotation setIndex:idx];
        
        [self.searchPoiArray addObject:annotation];
        
        //NSLog(@">>>>>%@ %f %f",obj.customFields,obj.location.latitude,obj.location.longitude);
        
        RyJobModel * model = [[RyJobModel alloc] initWithDictionary:obj.customFields];
        model.jobname = obj.name;
        model.updateTime = obj.updateTime;
        [self.dataArray addObject:model];

    }];
    
    [self showPOIAnnotations];
}

//#pragma mark 选中大头针时触发
////点击一般的大头针KCAnnotation时添加一个大头针作为所点大头针的弹出详情视图
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    //获取当前点击的大头针的全部信息
    CurrentLocationAnnotation * current  = (CurrentLocationAnnotation *)view.annotation;
    //    currentLocation = annotation.coordinate;
    if ([view.annotation isKindOfClass:[CurrentLocationAnnotation class]]) {
        //点击一个大头针时移除其他弹出详情视图
        //        [self removeCustomAnnotation];
        //添加详情大头针，渲染此大头针视图时将此模型对象赋值给自定义大头针视图完成自动布局
        CurrentLocationAnnotation *annotation1 = [[CurrentLocationAnnotation alloc]init];
        annotation1.index = current.index;
        annotation1.title = current.title;
        annotation1.subtitle = current.subtitle;
        annotation1.coordinate = view.annotation.coordinate;
        [mapView addAnnotation:annotation1];
    }
    if ([view.annotation isKindOfClass:[MKUserLocation class]]) {
        return;
    }
    NSLog(@"当前点击:%zd",current.index);
#pragma mark 点击滚动到zhidingweizhi
    [self addCollectionView];
    [[self collectionView] reloadData];
    [self.collectionView layoutIfNeeded];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:current.index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

// 设置地图使其可以显示数组中所有的annotation
- (void)showPOIAnnotations
{
    // 向地图窗口添加一组标注
    [self.mapView addAnnotations:self.searchPoiArray];
}

#pragma mark - Initialization
// 主视图
- (void)initMapView
{
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), self.view.bounds.size.height)];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    /** 向下轻扫 */
    UISwipeGestureRecognizer *swipeGestureRecognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    [self.view addGestureRecognizer:swipeGestureRecognizerLeft];
    swipeGestureRecognizerLeft.direction = UISwipeGestureRecognizerDirectionDown;
}

- (void)initSearch
{
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}

// 自定义用户大头针
- (void)initCenterView
{
    // 自己的坐标
    self.centerAnnotationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map_location"]];
    self.centerAnnotationView.center = CGPointMake(self.mapView.center.x, self.mapView.center.y - CGRectGetHeight(self.centerAnnotationView.bounds) / 2);
    
    [self.mapView addSubview:self.centerAnnotationView];
}

// 装载数据坐标
-(NSMutableArray *)searchPoiArray
{
    if (!_searchPoiArray) {
        _searchPoiArray = [NSMutableArray array];
    }
    return _searchPoiArray;
}

//数据源
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

/* 移动窗口弹一下的动画 */
- (void)centerAnnotationAnimimate
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGPoint center = self.centerAnnotationView.center;
                         center.y -= 20;
                         [self.centerAnnotationView setCenter:center];}
                     completion:nil];
    
    [UIView animateWithDuration:0.45
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGPoint center = self.centerAnnotationView.center;
                         center.y += 20;
                         [self.centerAnnotationView setCenter:center];}
                     completion:nil];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initSearch];
    [self initMapView];
    [self initSearchKeyWords];
    [self addBackLoaction];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(message:) name:@"expect_job" object:nil];
    /** 意向职位 */
    _keywords =  [RYDefaults objectForKey:@"expect_job"];
    
    self.mapView.showsUserLocation = true;
    self.mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    [self.mapView setZoomLevel:13 animated:true];
    self.isfirst = false;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self initCenterView];
    
    self.mapView.zoomLevel = 16;              ///缩放级别（默认3-19，有室内地图时为3-20）
    self.mapView.showsUserLocation = true;    ///是否显示用户位置
    self.mapView.showsCompass = false;          /// 是否显示指南针
    self.mapView.showsScale = false;           ///是否显示比例尺
    self.mapView.minZoomLevel = 5;          /// 限制最小缩放级别
}

- (void)cloudPlaceAroundSearch:(CLLocationCoordinate2D)coordinate keywords:(NSString *)keywords
{
    //[self centerAnnotationView];
    [_collectionView removeFromSuperview];
    _collectionView = nil;
    
    AMapCloudPOIAroundSearchRequest *placeAround = [[AMapCloudPOIAroundSearchRequest alloc] init];
    [placeAround setTableID:(NSString *)TableID];
    
    [placeAround setRadius:RADIUS];
    
    AMapGeoPoint *centerPoint = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    [placeAround setCenter:centerPoint];
    
    NSString * searchKey  = keywords;
    if ([VerifyHelper empty:searchKey]) {
        searchKey = _keywords;
    }
    
    [placeAround setKeywords:searchKey];

    [placeAround setSortType:AMapCloudSortTypeDESC];
    
    [placeAround setOffset:100];
    //  [placeAround setPage:1];
    
    [self.search AMapCloudPOIAroundSearch:placeAround];

}

/** 通知搜索 */
- (void) message:(NSNotification *) notifi
{
    /** 意向职位 */
    _keywords = notifi.object;
    [RYDefaults setObject:_keywords forKey:@"expect_job"];
    [self cloudPlaceAroundSearch:self.mapView.centerCoordinate keywords:_keywords];
}

/** 搜索UI */
- (void) initSearchKeyWords
{
    RaderSearchViewCell * cell = [[NSBundle mainBundle] loadNibNamed:@"RaderSearchViewCell" owner:nil options:nil].lastObject;
    cell.frame = CGRectMake(0, 0, kScreenWidth, 60);
    [self.view addSubview:cell];
}

/** 搜索关键词 */
- (void) closeBeyBoard
{
    for (id class in self.view.subviews)
    {
        if ([class isKindOfClass:[RaderSearchViewCell class]]) {
            RaderSearchViewCell * cell = (RaderSearchViewCell *)class;
            if (![VerifyHelper empty:cell.textFiled.text] && cell.textFiled.editing) {
                _keywords = cell.textFiled.text;
               [self cloudPlaceAroundSearch:self.mapView.centerCoordinate  keywords:cell.textFiled.text];
            }
        }
    }
    [super closeBeyBoard];
}

/** 回到定位位置 */
- (void) addBackLoaction
{
    UIButton *ret = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    ret.backgroundColor = [UIColor whiteColor];
    ret.layer.cornerRadius = 4;
    
    [ret setImage:[UIImage imageNamed:@"gpsStat1"] forState:UIControlStateNormal];
    [ret addTarget:self action:@selector(gpsAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:ret];
    
    ret.center = CGPointMake(CGRectGetMidX(ret.bounds) + 10,
                self.view.bounds.size.height -  CGRectGetMidY(ret.bounds) - 20 - KToolHeight);
    ret.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
}

- (void)gpsAction:(UIButton *) sender
{
    if(self.mapView.userLocation.updating && self.mapView.userLocation.location) {
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
        [sender setSelected:YES];
    }
}

/** 添加列表 */
- (void) addCollectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(kScreenWidth, 180);
        layout.minimumInteritemSpacing = 0.0f;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kScreenHeight - KToolHeight - KNavBarHeight - 200, kScreenWidth , 200) collectionViewLayout:layout];
        _collectionView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.0];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = true;
        _collectionView.showsHorizontalScrollIndicator = false;
        _collectionView.showsVerticalScrollIndicator = false;
        [_collectionView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellWithReuseIdentifier:identifier];
        _collectionView.contentSize = CGSizeMake(kScreenWidth*10, 200);
        _collectionView.contentOffset = CGPointMake(0, 0);
        [self.view addSubview:_collectionView];
    }
}

#pragma mark ------
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
    RyJobModel * model = self.dataArray[indexPath.row];
    CollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.model = model;
    cell.collectionViewCellCallBack = ^(NSInteger index) {
        if (index == 11) {
            JobDetailViewController * h5 = [[JobDetailViewController alloc] init];
            h5.url = [UtilityHelper addTokenForUrlSting:[NSString stringWithFormat:@"%@public/job/jobDetails?datas=%@",KBaseURL,[UtilityHelper encryptUseDES2:[@{@"jobId":model.jobid} mj_JSONString] key:DESKEY]]];
            [self.navigationController pushViewController:h5 animated:true];
        }else if (index == 12){
            CompanyDetailViewController * h5 = [[CompanyDetailViewController alloc] init];
            h5.url = [UtilityHelper addTokenForUrlSting:[NSString stringWithFormat:@"%@public/company/coms/%@.html",KBaseURL,[NSString stringWithFormat:@"%@",model.comid]]];
            [self.navigationController pushViewController:h5 animated:true];
        }
    };
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 10, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenWidth, 180);
}

/** 下滑清除 */
- (void)swipe:(UISwipeGestureRecognizer *)sender
{
    [_collectionView removeFromSuperview];
    _collectionView = nil;
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
