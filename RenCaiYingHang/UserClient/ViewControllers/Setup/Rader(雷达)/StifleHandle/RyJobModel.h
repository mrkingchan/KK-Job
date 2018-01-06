//
//  RyJobModel.h
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/18.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "RYBaseModel.h"

@interface RyJobModel : RYBaseModel

//"_city" = "\U6df1\U5733\U5e02";
//"_district" = "\U5357\U5c71\U533a";
//"_province" = "\U5e7f\U4e1c\U7701";

//主标题
@property(nonatomic,copy)NSString *jobname;//职位名称
//详情信息
@property(nonatomic,copy)NSString *salaryrange;//": "3k-8k", //薪酬范围

@property(nonatomic,copy)NSString *_city;//": "深圳市", //城市名称
@property(nonatomic,copy)NSString *_district;//": "罗湖区", //区县
@property(nonatomic,assign)int jobid;//": 1510647725849124, //职位id
@property(nonatomic,assign)int comid;//": 1510542150833744, //公司id
@property(nonatomic,copy)NSString *comname;//": "深圳市金瑞康源生态技术有限公司",
@property(nonatomic,assign)float subsidy;//": 165, //补贴
@property(nonatomic,copy)NSString *comshortname;//": "金瑞康", //公司简称
@property(nonatomic,copy)NSString *comlogo;//": "comLogo/1510541628146513.png", //公司logo
@property(nonatomic,assign)float award;//": 0, //悬赏金
@property(nonatomic,copy)NSString *industry_name;//": "制药/医疗", //行业名称
@property(nonatomic,copy)NSString *lightspots_name;//": "年终奖,股票期权,五险一金,带薪年假,交通补贴,话费补贴", //公司亮点名称
@property(nonatomic,copy)NSString *job_exp_name;//": "无要求", //工作年限
@property(nonatomic,copy)NSString *diploma_name;//": "其他", //学历名称
@property (nonatomic,copy) NSString * updateTime;//更新时间
@property (nonatomic,copy) NSString * scale_name;//公司规模


@property (nonatomic,copy) NSString * finance_name;//融资

@end
