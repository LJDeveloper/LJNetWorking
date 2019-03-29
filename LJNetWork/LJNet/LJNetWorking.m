//
//  LJNetWorking.m
//  LJNetWork
//
//  Created by 凯悦 on 2019/3/29.
//  Copyright © 2019 杨建军. All rights reserved.
//

#import "LJNetWorking.h"
@implementation LJNetWorking
+ (LJNetWorking *)shareAssistant
{
    static dispatch_once_t onceToken;
    static LJNetWorking *assistant = nil;
    if (assistant == nil) {
        dispatch_once(&onceToken, ^{
            assistant = [[LJNetWorking alloc]init];
        });
    }
    return assistant;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _manage = [AFHTTPSessionManager manager];
        
    }
    return self;
}
- (void)POSTWithCompleteURL:(NSString *)URLString parameters:(id)parameters progress:(void (^)(id _Nonnull))progress success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure
{
    _manage.requestSerializer = [AFJSONRequestSerializer serializer];
    [_manage.requestSerializer setTimeoutInterval:10];
    [_manage.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"User-Agent"];
    _manage.responseSerializer.acceptableContentTypes = [NSSet setWithArray:ACCEPTTYPENORMAL];
    [_manage POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        failure(error);
    }];
}
- (void)GETWithCompleteURL:(NSString *)URLString parameters:(id)parameters progress:(void (^)(id _Nonnull))progress success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure
{
    _manage.requestSerializer = [AFJSONRequestSerializer serializer];
    [_manage.requestSerializer setTimeoutInterval:10];
    [_manage.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"User-Agent"];
    _manage.responseSerializer.acceptableContentTypes = [NSSet setWithArray:ACCEPTTYPENORMAL];
    [_manage GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
- (void)RequstByGBKWithCompleteURL:(NSString *)URL body:(NSString *)body method:(NSString *)method success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]];
    [urlRequest setHTTPMethod: method];
    //body转GBK
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    [urlRequest setHTTPBody:[body dataUsingEncoding:enc]];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    _manage.requestSerializer = [AFHTTPRequestSerializer serializer];
    _manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDataTask *dataTask =[_manage dataTaskWithRequest:urlRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        //处理成功之后的逻辑
        if (responseObject) {
            success(responseObject);
        }
        if (error) {
            failure(error);
        }
    }];
    [dataTask resume];
}

- (void)upLoadImagesWithComplete:(NSString *)URLString paras:(NSDictionary *)paras imageArr:(NSArray *)imageArr progress:(void (^)(id _Nonnull))progress success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure
{
    [_manage POST:URLString parameters:paras constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData){
        for (UIImage *image in imageArr)
        {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.6) name:@"upload" fileName:[NSString stringWithFormat:@"%@.jpg",[LJNetWorking getNowTimeTimestamp]] mimeType:@"image/jpg"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
+(NSString *)convertToJsonData:(NSDictionary *)dict

{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}
+(NSString*)getCurrentTimesFormat:(NSString*)format{
    //yyyy-MM-dd HH:mm
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8*60*60];
    [formatter setDateFormat:format];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}
+(NSString *)getNowTimeTimestamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}
@end
