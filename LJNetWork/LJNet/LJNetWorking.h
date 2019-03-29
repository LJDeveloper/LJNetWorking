//
//  LJNetWorking.h
//  LJNetWork
//
//  Created by 凯悦 on 2019/3/29.
//  Copyright © 2019 杨建军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import <SVProgressHUD.h>
NS_ASSUME_NONNULL_BEGIN
#define ACCEPTTYPENORMAL @[@"application/json",@"application/xml",@"text/json",@"text/javascript",@"text/html",@"text/plain"]
@interface LJNetWorking : NSObject
@property(nonatomic,strong)AFHTTPSessionManager *manage;
+ (LJNetWorking *)shareAssistant;
//post请求
- (void)POSTWithCompleteURL:(NSString *)URLString parameters:(id)parameters progress:(void(^)(id progress))progress success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;
//get请求
- (void)GETWithCompleteURL:(NSString *)URLString parameters:(id)parameters progress:(void(^)(id progress))progress success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;
//GBK编码请求方式
- (void)RequstByGBKWithCompleteURL:(NSString *)URLString body:(NSString *)body method:(NSString *)method success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;
//上传图片
- (void)upLoadImagesWithComplete:(NSString *)URLString paras:(NSDictionary*)paras imageArr:(NSArray *)imageArr progress:(void(^)(id progress))progress success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;
//dict转str
+ (NSString *)convertToJsonData:(NSDictionary *)dict;
//获取当前时间
+(NSString*)getCurrentTimesFormat:(NSString*)format;
//获取当前时间戳
+(NSString *)getNowTimeTimestamp;
@end

NS_ASSUME_NONNULL_END
