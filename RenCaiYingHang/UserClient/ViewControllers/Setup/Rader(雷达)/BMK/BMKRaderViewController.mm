//
//  BMKRaderViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2018/1/16.
//  Copyright © 2018年 Macx. All rights reserved.
//

#import "BMKRaderViewController.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

#import "RYAnnotation.h"
#import "YWRoundAnnotationView.h"
#import "RaderSearchViewCell.h"
#import "CollectionViewCell.h"

#import "JobDetailViewController.h"
#import "CompanyDetailViewController.h"

@interface BMKRaderViewController ()<BMKMapViewDelegate,BMKCloudSearchDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,BMKLocationServiceDelegate>
{
    BMKCloudSearch* _search;
}

// 地图
@property (nonatomic, strong) BMKMapView             * mapView;

//定位
@property (nonatomic, strong)  BMKLocationService    * locService;

// 自定义大头针
@property (nonatomic, strong) UIImageView            * centerAnnotationView;

//当前坐标
@property (nonatomic,assign) CLLocationCoordinate2D  currentLocation;

// 防止重复点击
@property (nonatomic, assign) BOOL                  isMapViewRegionChangedFromTableView;

@property (nonatomic, assign) BOOL isfirst;

// 坐标数据源
@property (nonatomic, strong) NSMutableArray         * searchPoiArray;

@property (nonatomic, copy) NSString                 * keywords;

@property (nonatomic, strong) UICollectionView       * collectionView;

@property (nonatomic,strong) NSMutableArray          * dataArray;

@end

const static int GEO_TABLE_ID = 183071;
static NSString * AK = @"DFNh9NA5GK0Po41cGcBeWg4tY5F25MTL";
static NSString * identifier = @"CollectionViewCell";

@implementation BMKRaderViewController

#pragma mark - Utility


#pragma mark - MapViewDelegate
/**
 * @brief 地图区域改变完成后会调用此接口
 * @param mapView 地图View
 * @param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (!self.isMapViewRegionChangedFromTableView)
    {
        [self cloudPlaceAroundSearch:self.mapView.centerCoordinate keywords:@""];
    }
    self.isMapViewRegionChangedFromTableView = NO;
}

#pragma mark - userLocation

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
   
    [_locService stopUserLocationService];
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (!_isfirst) {
        _isfirst = true;
        _currentLocation = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
        [_mapView updateLocationData:userLocation];
        self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
        [self cloudPlaceAroundSearch:userLocation.location.coordinate keywords:@""];
    }
    [_locService stopUserLocationService];
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    
}

/**
 * @brief 根据anntation生成对应的View
 * @param mapView 地图View
 * @param annotation 指定的标注
 * @return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
//    RYAnnotation * current  = (RYAnnotation *)annotation;
    if ([annotation isKindOfClass:[RYAnnotation class]])
    {
        YWRoundAnnotationView *newAnnotationView =(YWRoundAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"RoundmyAnnotation"];
        if (newAnnotationView==nil)
        {
            newAnnotationView=[[ YWRoundAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"RoundmyAnnotation"];
        }

        newAnnotationView.titleText = [NSString stringWithFormat:@"%@", annotation.title];
        newAnnotationView.countText = [NSString stringWithFormat:@"%@", annotation.subtitle];
        
        newAnnotationView.canShowCallout = false;
        
        __weak typeof(newAnnotationView) annotationView = newAnnotationView;
        newAnnotationView.bmkAnnotationViewClick = ^ {
            annotationView.selected = true;
            [self mapView:self.mapView didSelectAnnotationView:annotationView];
        };
        
        return newAnnotationView;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"didAddAnnotationViews");
}

/**
 *返回云检索POI列表结果
 *@param poiResultList 云检索结果列表，成员类型为BMKCloudPOIList
 *@param type 返回结果类型： BMK_CLOUD_LOCAL_SEARCH,BMK_CLOUD_NEARBY_SEARCH,BMK_CLOUD_BOUND_SEARCH
 *@param error 错误号，@see BMKCloudErrorCode
 */
- (void)onGetCloudPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error
{
    [self.mapView removeAnnotations:self.searchPoiArray];
    [self.searchPoiArray removeAllObjects];
    [self.dataArray removeAllObjects];
    
    if (error == BMKErrorOk) {
        BMKCloudPOIList* result = [poiResultList objectAtIndex:0];
        for (int i = 0; i < result.POIs.count; i++) {
            BMKCloudPOIInfo * poi = [result.POIs objectAtIndex:i];
            //自定义字段
            if(poi.customDict!=nil && poi.customDict.count > 1)
            {
                RYAnnotation *annotation = [[RYAnnotation alloc] init];
                [annotation setCoordinate:CLLocationCoordinate2DMake(poi.longitude, poi.latitude)];
                [annotation setTitle:poi.customDict[@"salaryrange"]];
                [annotation setSubtitle:[NSString stringWithFormat:@"%ldm",(long)poi.distance]];
                [annotation setIndex:i];
                
                [self.searchPoiArray addObject:annotation];
                
                RyJobModel * model = [[RyJobModel alloc] initWithDictionary:poi.customDict];
                model.jobname = poi.title;
                model.city = poi.city;
                model.district = poi.district;
                [self.dataArray addObject:model];
            }
        }
    }
    
    [self showPOIAnnotations];
}

//#pragma mark 选中大头针时触发
////点击一般的大头针KCAnnotation时添加一个大头针作为所点大头针的弹出详情视图
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    //获取当前点击的大头针的全部信息
    RYAnnotation * current  = (RYAnnotation *)view.annotation;
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
    
    if ([view.annotation isKindOfClass:[RYAnnotation class]]) {
       // [mapView removeAnnotation:current];
        RYAnnotation *annotation1 = [[RYAnnotation alloc]init];
        annotation1.index = current.index;
        annotation1.title = current.title;
        annotation1.subtitle = current.subtitle;
        annotation1.coordinate = view.annotation.coordinate;
        [mapView addAnnotation:annotation1];
    }
    
    if ([view.annotation isKindOfClass:[BMKUserLocation class]]) {
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
    [self.mapView addAnnotations:self.searchPoiArray];
//    if (self.searchPoiArray.count > 1) {
//        [self.mapView showAnnotations:self.searchPoiArray animated:NO];
//    }
}

#pragma mark - Initialization
// 主视图
- (void)initMapView
{
    self.mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    self.mapView.mapType = BMKMapTypeStandard;
    self.mapView.isSelectedAnnotationViewFront = true;
    
    self.mapView.showsUserLocation = false;
    self.mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;
    self.mapView.showsUserLocation = true;
    [self.mapView setZoomLevel:16];
    
    self.mapView.gesturesEnabled = self.mapView.zoomEnabled = true;
    self.mapView.scrollEnabled = true;
    
    self.mapView.minZoomLevel = 3;
    self.mapView.maxZoomLevel = 21;
    self.isfirst = false;
}

/** 开始定位 */
- (void) startLocation
{
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc] init];
    
    _locService.delegate = self;
    
    _locService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    //启动LocationService
    [_locService startUserLocationService];
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

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    //初始化云检索服务
    _search = [[BMKCloudSearch alloc]init];
    _search.delegate = self;
    [self initMapView];
    [self startLocation];
    [self initSearchKeyWords];
    [self addBackLoaction];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(message:) name:@"expect_job" object:nil];
    /** 意向职位 */
    _keywords =  [RYDefaults objectForKey:@"expect_job"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self initCenterView];
}

- (void)cloudPlaceAroundSearch:(CLLocationCoordinate2D)coordinate keywords:(NSString *)keywords
{
    [_collectionView removeFromSuperview];
    _collectionView = nil;
    
    BMKCloudNearbySearchInfo * placeAround = [[BMKCloudNearbySearchInfo alloc] init];
    
    [placeAround setAk:AK];
    
    [placeAround setGeoTableId:GEO_TABLE_ID];

    [placeAround setRadius:RADIUS];
    
    placeAround.location = [NSString stringWithFormat:@"%f,%f",coordinate.longitude,coordinate.latitude];
    
    NSString * searchKey  = keywords;
    if ([VerifyHelper empty:searchKey]) {
        searchKey = _keywords;
    }
    
    [placeAround setKeyword:searchKey];
    
    [placeAround setPageSize:50];
    
    BOOL flag = [_search nearbySearchWithSearchInfo:placeAround];
    if(flag)
    {
        NSLog(@"周边云检索发送成功");
    }
    else
    {
        NSLog(@"周边云检索发送失败");
    }
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
    for (id view in self.view.subviews)
    {
        if ([view isKindOfClass:[RaderSearchViewCell class]]) {
            RaderSearchViewCell * cell = (RaderSearchViewCell *)view;
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
    if(_currentLocation.latitude) {
        [self.mapView setCenterCoordinate:_currentLocation animated:YES];
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
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kScreenHeight - KToolHeight - KNavBarHeight - 200, kScreenWidth , 190) collectionViewLayout:layout];
        _collectionView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = true;
        _collectionView.showsHorizontalScrollIndicator = false;
        _collectionView.showsVerticalScrollIndicator = false;
        [_collectionView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellWithReuseIdentifier:identifier];
        _collectionView.contentSize = CGSizeMake(kScreenWidth*10, 200);
        _collectionView.contentOffset = CGPointMake(0, 0);
        [self.view addSubview:_collectionView];
        
        /** 向下轻扫 */
        UISwipeGestureRecognizer *swipeGestureRecognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        [_collectionView addGestureRecognizer:swipeGestureRecognizerLeft];
        swipeGestureRecognizerLeft.direction = UISwipeGestureRecognizerDirectionDown;
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

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _search.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _search.delegate = nil;
    _locService.delegate = nil;
}

- (void)dealloc {
    if (_search != nil) {
        _search = nil;
    }
    if (_mapView) {
        _mapView = nil;
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
