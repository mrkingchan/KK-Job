//
//  RadarViewController.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "RadarViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "RyAnnotation.h"
#import "RyAnnotationView.h"
#import "RyJobModel.h"

#import "JXMapNavigationView.h"

#import "CollectionViewCell.h"

#import <objc/runtime.h>

@interface RadarViewController ()<MKMapViewDelegate,CLLocationManagerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    
    CLLocationManager *_locationManager;
    MKMapView *_mapView;
    //    CLLocationCoordinate2D currentLocation;
    RyAnnotation *currentAnnotation;
    BOOL haveGetUserLocation;//是否获取到用户位置
    CLGeocoder *geocoder;
    UIImageView *imgView;//中间位置标志视图
    BOOL spanBool;//是否是滑动
    BOOL pinchBool;//是否缩放
}

@property (nonatomic, strong)JXMapNavigationView *mapNavigationView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray * dataArray;

@end

static NSString * identifier = @"CollectionViewCell";

@implementation RadarViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (UICollectionView *)collectionView
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
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellWithReuseIdentifier:identifier];
        _collectionView.contentSize = CGSizeMake(kScreenWidth*10, 200);
        _collectionView.contentOffset = CGPointMake(0, 0);
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (JXMapNavigationView *)mapNavigationView{
    if (_mapNavigationView == nil) {
        _mapNavigationView = [[JXMapNavigationView alloc]init];
    }
    return _mapNavigationView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置代理
    _mapView.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    spanBool = NO;
    pinchBool = NO;
    haveGetUserLocation = NO;
    geocoder=[[CLGeocoder alloc]init];
    
    for (UIView *view in _mapView.subviews) {
        NSString *viewName = NSStringFromClass([view class]);
        if ([viewName isEqualToString:@"_MKMapContentView"]) {
            UIView *contentView = view;//[self.mapView valueForKey:@"_contentView"];
            for (UIGestureRecognizer *gestureRecognizer in contentView.gestureRecognizers) {
                if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
                    [gestureRecognizer addTarget:self action:@selector(mapViewSpanGesture:)];
                }
                if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
                    [gestureRecognizer addTarget:self action:@selector(mapViewPinchGesture:)];
                }
            }
            
        }
    }
    [self loadData];
}

- (void) loadData
{
    for (int i = 0; i<10; i++) {
        RyJobModel *model = [[RyJobModel alloc]init];
        model.title = [NSString stringWithFormat:@"目的地地址%d",i];
        model.latitudef = 22.25;
        model.longitudef = 115.15-0.1*i;
        model.iconName = @"address";
        model.picName = @"address";
        model.detailStr = [NSString stringWithFormat:@"职位测试%d",i];
        model.distance = @"50m";
        model.index = i;
        [self.dataArray addObject:model];
    }
    [self initGUI];
    [self nearbyPointWithArr:self.dataArray];
}

#pragma mark 添加地图控件
-(void)initGUI{
    CGRect rect=[UIScreen mainScreen].bounds;
    _mapView=[[MKMapView alloc]initWithFrame:rect];
    [self.view addSubview:_mapView];
    
    //请求定位服务
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    
    
    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
        [_locationManager requestWhenInUseAuthorization];
        //[_locationManager startUpdatingLocation];
    }
    
    //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
    _mapView.userTrackingMode = MKUserTrackingModeFollow;//MKUserTrackingModeFollowWithHeading;
    
    //设置地图类型
    _mapView.mapType = MKMapTypeStandard;
    _mapView.showsUserLocation = YES;
    
    [self.view insertSubview:_mapView belowSubview:self.collectionView];
    [self.collectionView reloadData];
    //添加大头针
    //    [self addAnnotation];
}

- (void)nearbyPointWithArr:(NSMutableArray *)arr{
    if (arr.count>0) {
        for (int i = 0; i<arr.count; i++) {
            RyJobModel *model = arr[i];
            CLLocationCoordinate2D location1=CLLocationCoordinate2DMake(model.latitudef, model.longitudef);
            RyAnnotation *annotation1 = [[RyAnnotation alloc]init];
            annotation1.title = model.title;
            annotation1.coordinate=location1;
            annotation1.image = [UIImage imageNamed:model.picName];
            annotation1.icon = [UIImage imageNamed:model.iconName];
            annotation1.detail = model.detailStr;
            annotation1.distance = model.distance;
            annotation1.tag = model.index;
            [_mapView addAnnotation:annotation1];
        }
    }
}

#pragma mark CoreLocation delegate
//定位失败则执行此代理方法
//定位失败弹出提示框,点击"打开定位"按钮,会打开系统的设置,提示打开定位服务
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self gotoSetLocation];
}

//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [_locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    //反编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            NSString *  currentCity = placeMark.locality;
            if (!currentCity) {
                currentCity = @"无法定位当前城市";
            }
            [self alertMessageWithViewController:self message:currentCity];
//            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:currentCity style:UIBarButtonItemStylePlain target:self action:@selector(selectCityName:)];
            NSLog(@"%@",currentCity); //这就是当前的城市
            NSLog(@"%@",placeMark.name);//具体地址:  xx市xx区xx街道
            
            /** 定位成功再调用 */
            //[self loadData];
        }
        else if (error == nil && placemarks.count == 0) {
            NSLog(@"No location and error return");
        }
        else if (error) {
            NSLog(@"location error: %@ ",error);
        }
        
    }];
}

/** 选择城市 **/
- (void) selectCityName:(UIBarButtonItem *)item
{
    
}

#pragma mark - 地图控件代理方法
#pragma mark 显示大头针时调用，注意方法中的annotation参数是即将显示的大头针对象
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    //由于当前位置的标注也是一个大头针，所以此时需要判断，此代理方法返回nil使用默认大头针视图
    if ([annotation isKindOfClass:[RyAnnotation class]]) {
        static NSString *key1 = @"AnnotationKey1";
        MKAnnotationView *annotationView=[_mapView dequeueReusableAnnotationViewWithIdentifier:key1];
        //如果缓存池中不存在则新建
        if (!annotationView) {
            annotationView=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:key1];
            //annotationView.canShowCallout=true;//允许交互点击
            annotationView.calloutOffset = CGPointMake(0, 1);//定义详情视图偏移量
            annotationView.leftCalloutAccessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"address"]];//定义详情左侧视图
        }
        //修改大头针视图
        //重新设置此类大头针视图的大头针模型(因为有可能是从缓存池中取出来的，位置是放到缓存池时的位置)
        annotationView.annotation = annotation;
        annotationView.image = ((RyAnnotation *)annotation).image;//设置大头针视图的图片
        
        return annotationView;
    }else if([annotation isKindOfClass:[RyCalloutAnnotation class]]){
        //对于作为弹出详情视图的自定义大头针视图无弹出交互功能（canShowCallout=false，这是默认值），在其中可以自由添加其他视图（因为它本身继承于UIView）
        RyAnnotationView * calloutView = [RyAnnotationView  calloutViewWithMapView:mapView];
        calloutView.ryAnnotation = (RyCalloutAnnotation *)annotation;
        
        [calloutView getReturnMark:^(NSString *mark) {
            NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%@",mark);
            
            //从目前位置导航到指定地
            [self.mapNavigationView showMapNavigationViewWithtargetLatitude:currentAnnotation.coordinate.latitude targetLongitute:currentAnnotation.coordinate.longitude toName:currentAnnotation.title];
            [self.view addSubview:_mapNavigationView];
            
            //从指定地导航到另一个指定地
            //            [self.mapNavigationView showMapNavigationViewFormcurrentLatitude:30.306906 currentLongitute:120.107265 TotargetLatitude:currentAnnotation.coordinate.latitude targetLongitute:currentAnnotation.coordinate.longitude toName:currentAnnotation.title];
           // [self.view addSubview:_mapNavigationView];
            
        }];
        
        return calloutView;
        
    } else {
        return nil;
    }
}

#pragma mark 选中大头针时触发
//点击一般的大头针KCAnnotation时添加一个大头针作为所点大头针的弹出详情视图
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    //获取当前点击的大头针的全部信息
    currentAnnotation = (RyAnnotation *)view.annotation;
    //    currentLocation = annotation.coordinate;
    if ([view.annotation isKindOfClass:[RyAnnotation class]]) {
        //点击一个大头针时移除其他弹出详情视图
        //        [self removeCustomAnnotation];
        //添加详情大头针，渲染此大头针视图时将此模型对象赋值给自定义大头针视图完成自动布局
        RyCalloutAnnotation *annotation1=[[RyCalloutAnnotation alloc]init];
        annotation1.icon = currentAnnotation.icon;
        annotation1.detail = currentAnnotation.detail;
        annotation1.distance = currentAnnotation.distance;
        annotation1.coordinate = view.annotation.coordinate;
        [mapView addAnnotation:annotation1];
    }
    if ([view.annotation isKindOfClass:[MKUserLocation class]]) {
        return;
    }
#pragma mark 点击滚动到zhidingweizhi
    [self.collectionView layoutIfNeeded];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentAnnotation.tag inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark 取消选中时触发
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    [self removeCustomAnnotation];
}

#pragma mark 移除所用自定义大头针
-(void)removeCustomAnnotation{
    [_mapView.annotations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[RyCalloutAnnotation class]]) {
            [_mapView removeAnnotation:obj];
        }
    }];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"userLocation:longitude:%f---latitude:%f",userLocation.location.coordinate.longitude,userLocation.location.coordinate.latitude);
    if (!haveGetUserLocation) {
        if (_mapView.userLocationVisible) {
            haveGetUserLocation = YES;
            [self getAddressByLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
            [self addCenterLocationViewWithCenterPoint:_mapView.center];
        }
        
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"regionDidChangeAnimated");
    if (imgView && (spanBool||pinchBool)) {
        CGPoint mapCenter = _mapView.center;
        CLLocationCoordinate2D coordinate = [_mapView convertPoint:mapCenter toCoordinateFromView:_mapView];
        [self getAddressByLatitude:coordinate.latitude longitude:coordinate.longitude];
        imgView.center = CGPointMake(mapCenter.x, mapCenter.y-15);
        [UIView animateWithDuration:0.2 animations:^{
            imgView.center = mapCenter;
        }completion:^(BOOL finished){
            if (finished) {
                [UIView animateWithDuration:0.05 animations:^{
                    imgView.transform = CGAffineTransformMakeScale(1.0, 0.8);
                    
                }completion:^(BOOL finished){
                    if (finished) {
                        [UIView animateWithDuration:0.1 animations:^{
                            imgView.transform = CGAffineTransformIdentity;
                        }completion:^(BOOL finished){
                            if (finished) {
                                spanBool = NO;
                            }
                        }];
                    }
                }];
                
            }
        }];
    }
    
}

-(void)addCenterLocationViewWithCenterPoint:(CGPoint)point
{
    if (!imgView) {
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 100, 18, 38)];
        imgView.center = point;
        imgView.image = [UIImage imageNamed:@"map_location"];
        imgView.center = _mapView.center;
        [self.view addSubview:imgView];
    }
    
}

#pragma mark 根据坐标取得地名
-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
#pragma mark 根据需求操作 --此处操作将经纬度上传给后台刷新数据
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        }else{
            haveGetUserLocation = NO;
            NSLog(@"error:%@",error.localizedDescription);
        }
        
    }];
}

#pragma mark ------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.collectionViewCellCallBack = ^(NSInteger index) {
        NSString * message ;
        if (index == 11) {
            message = @"职业详情";
        }else if (index == 12){
            message = @"公司详情";
        }
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
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

#pragma mark - MapView Gesture
-(void)mapViewSpanGesture:(UIPanGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
            NSLog(@"SpanGesture Began");
        }
            break;
        case UIGestureRecognizerStateChanged:{
            NSLog(@"SpanGesture Changed");
            spanBool = YES;
        }
            
            break;
        case UIGestureRecognizerStateCancelled:{
            NSLog(@"SpanGesture Cancelled");
        }
            
            break;
        case UIGestureRecognizerStateEnded:{
            NSLog(@"SpanGesture Ended");
        }
            
            break;
            
        default:
            break;
    }
}

- (void)mapViewPinchGesture:(UIGestureRecognizer*)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
            NSLog(@"PinchGesture Began");
        }
            break;
        case UIGestureRecognizerStateChanged:{
            NSLog(@"PinchGesture Changed");
            pinchBool = YES;
        }
            
            break;
        case UIGestureRecognizerStateCancelled:{
            NSLog(@"PinchGesture Cancelled");
        }
            
            break;
        case UIGestureRecognizerStateEnded:{
            pinchBool = NO;
            NSLog(@"PinchGesture Ended");
        }
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark - touchs
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"moved");
    spanBool = YES;
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

/** 去设置定位 **/
- (void) gotoSetLocation
{
    [self showAlertWithTitle:@"允许\"定位\"提示" message:@"请在设置中打开定位" appearanceProcess:^(EJAlertViewController * _Nonnull alertMaker) {
        alertMaker.addActionCancelTitle(@"取消").addActionDefaultTitle(@"设置");
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, EJAlertViewController * _Nonnull alertSelf) {
        if (buttonIndex == 1) {
            //打开定位设置
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:settingsURL];
        }
    }];
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

