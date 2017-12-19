//
//  RYAreaPickView.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/15.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "RYAreaPickView.h"

#import "AreaModel.h"

//当前tableview所处的状态
NS_ENUM(NSInteger,PickState) {
    ProvinceState,//选择省份状态
    CityState,//选择城市状态
    DistrictState//选择区、县状态
};

@interface RYAreaPickView()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *selectedProvince;
    NSString *selectedCity;
}

@property (nonatomic, strong)UITableView *tableView;

@end

@implementation RYAreaPickView

- (NSMutableArray *)cityArr
{
    if (!_cityArr) {
        _cityArr = [NSMutableArray array];
    }
    return _cityArr;
}

//- (NSMutableArray *)districtArr
//{
//    if (!_districtArr) {
//        _districtArr = [NSMutableArray array];
//    }
//    return _districtArr;
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame];
    if(self) {
        self.userInteractionEnabled = YES;
        // [self initData];
        [self setUI];
        //首先赋值为选择省份状态
        PickState = ProvinceState;
    }
    return self;
}

#pragma mark 读取plist城市数据文件
-(void)initData {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
    _areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray *components = [_areaDic allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[_areaDic objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    //取出省份数据
    _provinceArr = [[NSArray alloc] initWithArray: provinceTmp];
    
}

- (void)setUI
{
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height/2 - 50)];
    backView.backgroundColor = [UIColor blackColor];
    [backView.layer setOpaque:0.0];
    backView.alpha = 0.5;
    [self addSubview:backView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromSuperview)];
    [backView addGestureRecognizer:tap];
    
    UIView * bottomView = [UIFactory initViewWithFrame:CGRectMake(0, self.bounds.size.height/2, self.bounds.size.width, self.bounds.size.height/2) color:kWhiteColor];
    [self addSubview:bottomView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, bottomView.bounds.size.width , bottomView.bounds.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = [UIColor clearColor];
    [bottomView addSubview:_tableView];
    
    UIView * btnView = [UIFactory initViewWithFrame:CGRectMake(0, self.bounds.size.height/ 2 - 50, self.bounds.size.width, 50) color:kWhiteColor];
    [self addSubview:btnView];
    
    _provinceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_provinceBtn setTitle:@"请选择" forState:UIControlStateNormal];
    _provinceBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_provinceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _provinceBtn.frame = CGRectMake(0, 10, kScreenWidth/3, 30);
    [_provinceBtn addTarget:self action:@selector(provinceAction) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:_provinceBtn];
    CGFloat width = [self getBtnWidth:_provinceBtn];
    
    _cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cityBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _cityBtn.frame = CGRectMake(kScreenWidth/3, 10, kScreenWidth/3, 30);
    [_cityBtn addTarget:self action:@selector(cityAction) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:_cityBtn];
   
#pragma mark 地区
//    _districtBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _districtBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [_districtBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    _districtBtn.frame = CGRectMake(kScreenWidth/3 * 2, 10, kScreenWidth/3, 30);
//    [_districtBtn addTarget:self action:@selector(districtAction) forControlEvents:UIControlEventTouchUpInside];
//    [btnView addSubview:_districtBtn];
    
    _selectLine = [[UIView alloc]initWithFrame:CGRectMake((kScreenWidth/3 - width)/2, 41, width, 1)];
    _selectLine.backgroundColor = [UIColor blackColor];
    [btnView addSubview:_selectLine];
    //_selectLine.hidden = YES;
    
}

-(void) provinceAction {
    _selectLine.hidden = NO;
    PickState = ProvinceState;
    [_tableView reloadData];
    
    CGFloat width = [self getBtnWidth:_provinceBtn];
    
    [UIView animateWithDuration:0.4 animations:^{
        _selectLine.frame = CGRectMake((kScreenWidth/3-width)/2 , 41, width, 1);
    }];
    
}

-(void) cityAction {
    _selectLine.hidden = NO;
    PickState = CityState;
    [_tableView reloadData];
    CGFloat width = [self getBtnWidth:_cityBtn];
    
    [UIView animateWithDuration:0.4 animations:^{
        _selectLine.frame = CGRectMake((kScreenWidth/3-width)/2 + kScreenWidth/3, 41, width, 1);
        
    }];
    
    
}

//-(void) districtAction {
//    _selectLine.hidden = NO;
//    PickState = DistrictState;
//    [_tableView reloadData];
//    CGFloat width = [self getBtnWidth:_districtBtn];
//
//    [UIView animateWithDuration:0.4 animations:^{
//        _selectLine.frame = CGRectMake((kScreenWidth/3-width)/2  + kScreenWidth * 2/3, 41, width, 1);
//
//    }];
//}

-(CGFloat)getBtnWidth:(UIButton *)btn
{
    CGRect tmpRect = [btn.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] context:nil];
    CGFloat width = tmpRect.size.width;
    return width;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(PickState == ProvinceState) {
        return _provinceArr.count;
    }else if (PickState == CityState) {
        return self.cityArr.count;
    }
    return 0;
//    else {
//        return self.districtArr.count;
//    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if(PickState == ProvinceState)
    {
        AreaModel * model = _provinceArr[indexPath.row];
        cell.textLabel.text = model.aliasName;
        
    }else if(PickState == CityState)
    {
        AreaModel * model = self.cityArr[indexPath.row];
        cell.textLabel.text = model.city;
    }
//    else {
//        DistrictModel * model = self.districtArr[indexPath.row];
//        cell.textLabel.text = model.name;
//    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor blackColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectLine.hidden = NO;
    if(PickState == ProvinceState) {
        AreaModel * model = _provinceArr[indexPath.row];
        //当tableview所处为省份选择状态时，点击cell 进入城市选择状态
        PickState = CityState;
        selectedProvince = model.aliasName;
        
        [_provinceBtn setTitle:selectedProvince forState:UIControlStateNormal];
        [_cityBtn setTitle:@"请选择" forState:UIControlStateNormal];
        
        //[_districtBtn setTitle:@"" forState:UIControlStateNormal];
        
        CGFloat width = [self getBtnWidth:_provinceBtn];
        
        [UIView animateWithDuration:0.4 animations:^{
            _selectLine.frame = CGRectMake((kScreenWidth/3-width)/2, 41, width, 1);
        }];
        
        
        NSDictionary * parameters = @{@"provinceId":@(model.provinceID)};
        //清空市和地区后面数据的数组
        //[self.districtArr removeAllObjects];
        //刷新市的数据
        [self refreshTableView:self.cityArr paramter:parameters];
        
    }
    else if (PickState == CityState) {
        AreaModel * model = self.cityArr[indexPath.row];
        PickState = DistrictState;
        selectedCity = model.city;
        [_cityBtn setTitle:selectedCity forState:UIControlStateNormal];
        //[_districtBtn setTitle:@"请选择" forState:UIControlStateNormal];
        
        CGFloat width = [self getBtnWidth:_cityBtn];
        
        [UIView animateWithDuration:0.4 animations:^{
            _selectLine.frame = CGRectMake((kScreenWidth/3-width)/2 + kScreenWidth/3, 41, width, 1);
            
        }];
        
        if (_selectProvinceCityAreaCall) {
            _selectProvinceCityAreaCall(selectedProvince,selectedCity);
        }
        [self removeFromSuperview];
        //获取刷新地区的数据
        //[self refreshTableView:self.districtArr paramter:parameters];
        
    }
//    else {
//        DistrictModel * model = self.districtArr[indexPath.row];
//
//        [_districtBtn setTitle:model.name forState:UIControlStateNormal];
//
//        CGFloat width = [self getBtnWidth:_districtBtn];
//        
//        [UIView animateWithDuration:0.4 animations:^{
//            _selectLine.frame = CGRectMake((kScreenWidth/3-width)/2 + kScreenWidth * 2/3, 41, width, 1);
//
//        }];
//
//        [self removeFromSuperview];
//        //NSString * text = [NSString stringWithFormat:@"%@省%@市%@区",selectedProvince,selectedCity,model.name];
//
//
//    }
    [_tableView reloadData];
}

- (void) refreshTableView:(NSMutableArray * )arr paramter:(NSDictionary *)paramter
{
    //先清空数组
    [arr removeAllObjects];
    [AreaRequest getCityInfoWithParamer:paramter suceess:^(NSArray *dataArr) {
        [arr addObjectsFromArray:dataArr];
        [_tableView reloadData];
    } failure:^(id errorCode) {
        
    }];
}

- (void) show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
}

@end
