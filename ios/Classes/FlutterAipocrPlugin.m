#import "FlutterAipocrPlugin.h"

#import <AipOcrSdk.h>

@interface FlutterAipocrPlugin ()

@property(copy, nonatomic) FlutterResult result;

@end


@implementation FlutterAipocrPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"flutter_aipocr"
                                     binaryMessenger:[registrar messenger]];
    FlutterAipocrPlugin* instance = [[FlutterAipocrPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    self.result = result;
    
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    }else if ([@"init" isEqualToString:call.method]) {
        NSString *appKey = call.arguments[@"appKey"];
        NSString *secretKey = call.arguments[@"secretKey"];
        //初始化百度ocr
        
        [[AipOcrService shardService] authWithAK:appKey andSK:secretKey];
        
        result([NSNumber numberWithBool:true]);
        
    }else if ([@"generalBasicOCR" isEqualToString:call.method]) {
        //通用文字识别
        [self generalBasicOCRCall:call result:result];
    }else if ([@"generalAccurateBasicOCR" isEqualToString:call.method]) {
        //通用文字识别(高精度版)
        [self generalAccurateBasicOCRCall:call result:result];
    }else if ([@"generalOCR" isEqualToString:call.method]) {
        //通用文字识别(含位置信息版)
        [self generalOCRCall:call result:result];
    }else if ([@"generalAccurateOCR" isEqualToString:call.method]) {
        //通用文字识别(高精度含位置版)
        [self generalAccurateOCRCall:call result:result];
    }else if ([@"generalEnchancedOCR" isEqualToString:call.method]) {
        //通用文字识别(含生僻字版)
        [self generalEnchancedOCRCall:call result:result];
    }else if ([@"webImageOCR" isEqualToString:call.method]) {
        //网络图片文字识别
        [self webImageOCRCall:call result:result];
    }else if ([@"idcardOCROnlineFront" isEqualToString:call.method]) {
        //身份证正面拍照识别
        [self idcardOCROnlineFrontCall:call result:result];
        
    }else if ([@"idcardOCROnlineBack" isEqualToString:call.method]) {
        //身份证反面拍照识别
        [self idcardOCROnlineBackCall:call result:result];
        
    }else if ([@"localIdcardOCROnlineFront" isEqualToString:call.method]) {
        //身份证正面(嵌入式质量控制+云端识别)
        [self localIdcardOCROnlineFrontCall:call result:result];
        
    }else if ([@"localIdcardOCROnlineBack" isEqualToString:call.method]) {
        //身份证反面(嵌入式质量控制+云端识别)
        [self localIdcardOCROnlineBackCall:call result:result];
        
    }else if ([@"bankCardOCROnline" isEqualToString:call.method]) {
        //银行卡正面拍照识别
        [self bankCardOCROnlineCall:call result:result];
        
    }else if ([@"drivingLicenseOCR" isEqualToString:call.method]) {
        //驾驶证识别
        [self drivingLicenseOCRCall:call result:result];
        
    }else if ([@"vehicleLicenseOCR" isEqualToString:call.method]) {
        //行驶证识别
        [self vehicleLicenseOCRCall:call result:result];
        
    }else if ([@"plateLicenseOCR" isEqualToString:call.method]) {
        //车牌识别
        [self plateLicenseOCRCall:call result:result];
        
    }else if ([@"receiptOCR" isEqualToString:call.method]) {
        //票据识别
        [self receiptOCRCall:call result:result];
        
    }else if ([@"iOCR" isEqualToString:call.method]) {
        //自定义模板识别
        [self iOCRCall:call result:result];
        
    }
    
    else if ([@"businessLicenseOCR" isEqualToString:call.method]) {
        //营业执照识别
        [self businessLicenseOCRCall:call result:result];
        
    }
    
    
    
    else {
        result(FlutterMethodNotImplemented);
    }
}

#pragma mark - 通用文字识别
- (void)generalBasicOCRCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSString *language_type = call.arguments[@"language_type"]?:@"CHN_ENG";
    NSString *detect_direction = call.arguments[@"detect_direction"]?:@"true";
    
    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image)
                             {
                                 NSDictionary *options = @{@"language_type": language_type, @"detect_direction": detect_direction};
                                 [[AipOcrService shardService] detectTextBasicFromImage:image
                                                                            withOptions:options
                                                                         successHandler:^(id aipOcrResult)
                                  {
                                      [self successWithResult:result image:image aipOcrResult:aipOcrResult];
                                  }
                                                                            failHandler:^(NSError *error)
                                  {
                                      
                                      [self errorWithResult:result error:error];
                                      
                                      
                                  }];
                                 
                             }];
    
    
    
    
    
    [FlutterAipocrPlugin presentViewContreller:vc target:self];
    //    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}
#pragma mark - 通用文字识别(高精度版)
- (void)generalAccurateBasicOCRCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSString *language_type = call.arguments[@"language_type"]?:@"CHN_ENG";
    NSString *detect_direction = call.arguments[@"detect_direction"]?:@"true";
    
    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image)
                             {
                                 NSDictionary *options = @{@"language_type": language_type, @"detect_direction": detect_direction};
                                 [[AipOcrService shardService] detectTextAccurateBasicFromImage:image
                                                                                    withOptions:options
                                                                                 successHandler:^(id aipOcrResult)
                                  {
                                      [self successWithResult:result image:image aipOcrResult:aipOcrResult];
                                  }
                                                                                    failHandler:^(NSError *error)
                                  {
                                      [self errorWithResult:result error:error];
                                      
                                  }];
                                 
                             }];
    
    [FlutterAipocrPlugin presentViewContreller:vc target:self];
    //    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}
#pragma mark - 通用文字识别(含位置信息版)
- (void)generalOCRCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSString *language_type = call.arguments[@"language_type"]?:@"CHN_ENG";
    NSString *detect_direction = call.arguments[@"detect_direction"]?:@"true";
    
    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image)
                             {
                                 // 在这个block里，image即为切好的图片，可自行选择如何处理
                                 NSDictionary *options = @{@"language_type": language_type, @"detect_direction": detect_direction};
                                 [[AipOcrService shardService] detectTextFromImage:image
                                                                       withOptions:options
                                                                    successHandler:^(id aipOcrResult)
                                  {
                                      [self successWithResult:result image:image aipOcrResult:aipOcrResult];
                                  }
                                                                       failHandler:^(NSError *error)
                                  {
                                      [self errorWithResult:result error:error];
                                      
                                  }];
                                 
                             }];
    
    [FlutterAipocrPlugin presentViewContreller:vc target:self];
    //    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
    
    
}
#pragma mark - 通用文字识别(高精度含位置版)
- (void)generalAccurateOCRCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSString *language_type = call.arguments[@"language_type"]?:@"CHN_ENG";
    NSString *detect_direction = call.arguments[@"detect_direction"]?:@"true";
    
    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image)
                             {
                                 
                                 // 在这个block里，image即为切好的图片，可自行选择如何处理
                                 NSDictionary *options = @{@"language_type": language_type, @"detect_direction": detect_direction};
                                 [[AipOcrService shardService] detectTextAccurateFromImage:image
                                                                               withOptions:options
                                                                            successHandler:^(id aipOcrResult)
                                  {
                                      [self successWithResult:result image:image aipOcrResult:aipOcrResult];
                                  }
                                                                               failHandler:^(NSError *error)
                                  {
                                      [self errorWithResult:result error:error];
                                      
                                  }];
                                 
                             }];
    [FlutterAipocrPlugin presentViewContreller:vc target:self];
    //    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
    
    
}
#pragma mark - 通用文字识别(含生僻字版)
- (void)generalEnchancedOCRCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSString *language_type = call.arguments[@"language_type"]?:@"CHN_ENG";
    NSString *detect_direction = call.arguments[@"detect_direction"]?:@"true";
    
    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image)
                             {
                                 NSDictionary *options = @{@"language_type": language_type, @"detect_direction": detect_direction};
                                 [[AipOcrService shardService] detectTextEnhancedFromImage:image
                                                                               withOptions:options
                                                                            successHandler:^(id aipOcrResult)
                                  {
                                      [self successWithResult:result image:image aipOcrResult:aipOcrResult];
                                  }
                                                                               failHandler:^(NSError *error)
                                  {
                                      [self errorWithResult:result error:error];
                                      
                                  }];
                             }];
    
    [FlutterAipocrPlugin presentViewContreller:vc target:self];
    //    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
    
}
#pragma mark - 网络图片文字识别
- (void)webImageOCRCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image)
                             {
                                 
                                 [[AipOcrService shardService] detectWebImageFromImage:image
                                                                           withOptions:nil
                                                                        successHandler:^(id aipOcrResult)
                                  {
                                      [self successWithResult:result image:image aipOcrResult:aipOcrResult];
                                  }
                                                                           failHandler:^(NSError *error)
                                  {
                                      [self errorWithResult:result error:error];
                                      
                                  }];
                                 
                             }];
    [FlutterAipocrPlugin presentViewContreller:vc target:self];
    //    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
    
}

#pragma mark - 身份证正面拍照识别
- (void)idcardOCROnlineFrontCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    UIViewController * vc =
    [AipCaptureCardVC ViewControllerWithCardType:CardTypeIdCardFont
                                 andImageHandler:^(UIImage *image)
     {
         
         [[AipOcrService shardService] detectIdCardFrontFromImage:image
                                                      withOptions:nil
                                                   successHandler:^(id aipOcrResult)
          {
              
              [self successWithResult:result image:image aipOcrResult:aipOcrResult];
          }
                                                      failHandler:^(NSError *error)
          {
              [self errorWithResult:result error:error];
              
          }];
     }];
    
    [FlutterAipocrPlugin presentViewContreller:vc target:self];
    //    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}
#pragma mark - 身份证反面拍照识别
- (void)idcardOCROnlineBackCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    //    result([FlutterAipocrPlugin dictionaryToJson:@{@"asdf":@"12312"}]);
    
    UIViewController * vc =
    [AipCaptureCardVC ViewControllerWithCardType:CardTypeIdCardBack
                                 andImageHandler:^(UIImage *image)
     {
         
         [[AipOcrService shardService] detectIdCardBackFromImage:image
                                                     withOptions:nil
                                                  successHandler:^(id aipOcrResult)
          {
              
              [self successWithResult:result image:image aipOcrResult:aipOcrResult];
          }
                                                     failHandler:^(NSError *error)
          {
              [self errorWithResult:result error:error];
              
          }];
     }];
    
    [FlutterAipocrPlugin presentViewContreller:vc target:self];
    //    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
    
}
#pragma mark - 身份证正面(嵌入式质量控制+云端识别)
- (void)localIdcardOCROnlineFrontCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    UIViewController * vc =
    [AipCaptureCardVC ViewControllerWithCardType:CardTypeLocalIdCardFont
                                 andImageHandler:^(UIImage *image)
     {
         
         [[AipOcrService shardService] detectIdCardFrontFromImage:image
                                                      withOptions:nil
                                                   successHandler:^(id aipOcrResult)
          {
              
              [self successWithResult:result image:image aipOcrResult:aipOcrResult];
          }
                                                      failHandler:^(NSError *error)
          {
              [self errorWithResult:result error:error];
          }];
     }];
    
    [FlutterAipocrPlugin presentViewContreller:vc target:self];
    //    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
    
}
#pragma mark - 身份证反面(嵌入式质量控制+云端识别)
- (void)localIdcardOCROnlineBackCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    UIViewController * vc =
    [AipCaptureCardVC ViewControllerWithCardType:CardTypeLocalIdCardBack
                                 andImageHandler:^(UIImage *image)
     {
         
         [[AipOcrService shardService] detectIdCardFrontFromImage:image
                                                      withOptions:nil
                                                   successHandler:^(id aipOcrResult)
          {
              
              [self successWithResult:result image:image aipOcrResult:aipOcrResult];
          }
                                                      failHandler:^(NSError *error)
          {
              [self errorWithResult:result error:error];
              
          }];
     }];
    
    [FlutterAipocrPlugin presentViewContreller:vc target:self];
    //    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
    
}
#pragma mark - 银行卡正面拍照识别
- (void)bankCardOCROnlineCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    UIViewController * vc =
    [AipCaptureCardVC ViewControllerWithCardType:CardTypeBankCard
                                 andImageHandler:^(UIImage *image)
     {
         
         [[AipOcrService shardService] detectBankCardFromImage:image
                                                successHandler:^(id aipOcrResult)
          {
              
              [self successWithResult:result image:image aipOcrResult:aipOcrResult];
          }
                                                   failHandler:^(NSError *error)
          {
              [self errorWithResult:result error:error];
          }];
     }];
    
    [FlutterAipocrPlugin presentViewContreller:vc target:self];
    //    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
    
}
#pragma mark - 驾驶证识别
- (void)drivingLicenseOCRCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image)
                             {
                                 
                                 [[AipOcrService shardService] detectDrivingLicenseFromImage:image
                                                                                 withOptions:nil
                                                                              successHandler:^(id aipOcrResult)
                                  {
                                      
                                      [self successWithResult:result image:image aipOcrResult:aipOcrResult];
                                  }
                                                                                 failHandler:^(NSError *error)
                                  {
                                      [self errorWithResult:result error:error];
                                      
                                  }];
                                 
                             }];
    
    [FlutterAipocrPlugin presentViewContreller:vc target:self];
    //    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
    
}
#pragma mark - 行驶证识别
- (void)vehicleLicenseOCRCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image)
                             {
                                 
                                 [[AipOcrService shardService] detectVehicleLicenseFromImage:image
                                                                                 withOptions:nil
                                                                              successHandler:^(id aipOcrResult)
                                  {
                                      
                                      [self successWithResult:result image:image aipOcrResult:aipOcrResult];
                                  }
                                                                                 failHandler:^(NSError *error)
                                  {
                                      [self errorWithResult:result error:error];
                                      
                                  }];
                             }];
    [FlutterAipocrPlugin presentViewContreller:vc target:self];
    //    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
    
}
#pragma mark - 车牌识别
- (void)plateLicenseOCRCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image)
                             {
                                 
                                 [[AipOcrService shardService] detectPlateNumberFromImage:image
                                                                              withOptions:nil
                                                                           successHandler:^(id aipOcrResult)
                                  {
                                      
                                      [self successWithResult:result image:image aipOcrResult:aipOcrResult];
                                  }
                                                                              failHandler:^(NSError *error)
                                  {
                                      [self errorWithResult:result error:error];
                                      
                                  }];
                                 
                             }];
    
    [FlutterAipocrPlugin presentViewContreller:vc target:self];
    //    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
    
}
#pragma mark - 营业执照识别
- (void)businessLicenseOCRCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image)
                             {
                                 
                                 [[AipOcrService shardService] detectBusinessLicenseFromImage:image
                                                                                  withOptions:nil
                                                                               successHandler:^(id aipOcrResult)
                                  {
                                      
                                      [self successWithResult:result image:image aipOcrResult:aipOcrResult];
                                      
                                      
                                  }
                                                                                  failHandler:^(NSError *error)
                                  {
                                      
                                      [self errorWithResult:result error:error];
                                      
                                  }];
                                 
                             }];
    
    [FlutterAipocrPlugin presentViewContreller:vc target:self];
    //    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
    
}



#pragma mark - 票据识别
- (void)receiptOCRCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image)
                             {
                                 
                                 [[AipOcrService shardService] detectReceiptFromImage:image
                                                                          withOptions:nil
                                                                       successHandler:^(id aipOcrResult)
                                  {
                                      
                                      [self successWithResult:result image:image aipOcrResult:aipOcrResult];
                                  }
                                                                          failHandler:^(NSError *error)
                                  {
                                      
                                      [self errorWithResult:result error:error];
                                      
                                  }];
                                 
                             }];
    
    [FlutterAipocrPlugin presentViewContreller:vc target:self];
    
}
#pragma mark - 自定义模板识别
- (void)iOCRCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image)
                             {
                                 
                                 NSDictionary *options = call.arguments[@"options"];
                                 [[AipOcrService shardService] iOCRRecognitionFromImage:image
                                                                            withOptions:options
                                                                         successHandler:^(id aipOcrResult)
                                  {
                                      
                                      [self successWithResult:result image:image aipOcrResult:aipOcrResult];
                                      
                                  }
                                                                            failHandler:^(NSError *error)
                                  
                                  {
                                      
                                      [self errorWithResult:result error:error];
                                      
                                  }];
                                 
                             }];
    
    [FlutterAipocrPlugin presentViewContreller:vc target:self];
    
}
- (void)successWithResult:(FlutterResult)result image:(UIImage *)image aipOcrResult:(id)aipOcrResult{
    
    NSString *imagePath = [self saveImage:image];
    
    if (imagePath) {
        NSDictionary * dic =@{
                              @"data":[FlutterAipocrPlugin dictionaryToJson:aipOcrResult],
                              @"imagePath":imagePath,
                              @"success":@(YES)
                              };
        
        result(dic);
        [[[UIApplication sharedApplication].keyWindow rootViewController] dismissViewControllerAnimated:YES completion:nil];
    }else {
        
        [[[UIApplication sharedApplication].keyWindow rootViewController] dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}



- (void)errorWithResult:(FlutterResult)result error:(NSError *)error{
    result(@{
             @"code":[NSString stringWithFormat:@"%ld",(long)error.code],
             @"description":error.description,
             @"success":@(NO)
             });
    
    [[[UIApplication sharedApplication].keyWindow rootViewController] dismissViewControllerAnimated:YES completion:nil];
}

+ (void)presentViewContreller:(UIViewController *)vc target:(id)target{
    
    UIButton * closeBtn = [vc.view viewWithTag:123];
    if (!closeBtn) {
        closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
        closeBtn.tag = 123;
        
        [closeBtn addTarget:target action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
        
        [vc.view addSubview:closeBtn];
    }
    
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)dismissView{
    
    
    [[[UIApplication sharedApplication].keyWindow rootViewController] dismissViewControllerAnimated:YES completion:nil];
    
    if(self.result){
        self.result(nil );
        
        self.result = nil;
    }
    
    
}

- (NSString *)saveImage:(UIImage *)image {
    
    CGSize size = [FlutterAipocrPlugin getImageSizeWithImage:image];
    UIImage * pImage =  [FlutterAipocrPlugin reSizeImage:image toSize:size];
    
    NSData *data = [FlutterAipocrPlugin imageCompressToData:pImage];
    
    NSString *fileExtension = @"ocr_%@.jpg";
    NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *tmpFile = [NSString stringWithFormat:fileExtension, guid];
    NSString *tmpDirectory = NSTemporaryDirectory();
    NSString *tmpPath = [tmpDirectory stringByAppendingPathComponent:tmpFile];
    
    if ([[NSFileManager defaultManager] createFileAtPath:tmpPath contents:data attributes:nil]) {
        
        return tmpPath;
    } else {
        return nil;
    }
    
}


+ (CGSize)getImageSizeWithImage:(UIImage *)image {
    
    CGSize imageSize = CGSizeZero;
    
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat aspectRatio = imageWidth /imageHeight;
    if (imageWidth > imageHeight) {
        imageWidth = MIN(1920, imageWidth);
        imageHeight = imageWidth / aspectRatio;
    }else if (imageWidth < imageHeight) {
        imageHeight = MIN(1920, imageHeight);
        imageWidth = imageHeight * aspectRatio;
    }else {
        imageWidth = MIN(1920, imageWidth);
        imageHeight = MIN(1920, imageHeight);
    }
    imageSize = CGSizeMake(imageWidth, imageHeight);
    return  imageSize;
}

+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

+ (NSMutableData *)imageCompressToData:(UIImage *)image {
    
    NSData *data;
    if (data.length > 300 * 1024) {
        if (data.length > 1024 * 1024) {//1M以及以上
            data = UIImageJPEGRepresentation(image, 0.5);
        }else if (data.length > 512 * 1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(image, 0.7);
        }else if (data.length > 300 * 1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(image, 0.9);
        }else {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
    }else {
        data = UIImageJPEGRepresentation(image, 1.0);
    }
    return [NSMutableData dataWithData:data];
}


+ (NSString*)dictionaryToJson:(NSDictionary *)dic{
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&parseError];
    NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];;
    
    return jsonStr?:@"";
}



@end







