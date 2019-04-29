#import "FlutterAipocrPlugin.h"

#import <AipOcrSdk.h>

@implementation FlutterAipocrPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"flutter_aipocr"
                                     binaryMessenger:[registrar messenger]];
    FlutterAipocrPlugin* instance = [[FlutterAipocrPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
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
    
    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        NSDictionary *options = @{@"language_type": language_type, @"detect_direction": detect_direction};
        [[AipOcrService shardService] detectTextBasicFromImage:image
                                                   withOptions:options
                                                successHandler:^(id aipOcrResult){
                                                    NSLog(@"通用文字识别:%@\n",aipOcrResult);
                                                    result([FlutterAipocrPlugin dictionaryToJson:aipOcrResult]);
                                                    [[[UIApplication sharedApplication].keyWindow rootViewController] dismissViewControllerAnimated:YES completion:nil];
                                                }
                                                   failHandler:^(NSError *error){
                                                       
                                                       result([FlutterError errorWithCode:[NSString stringWithFormat:@"%ld",(long)error.code]
                                                                                  message:error.description
                                                                                  details:nil] );
                                                       
                                                   }];
        
    }];
    
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}
#pragma mark - 通用文字识别(高精度版)
- (void)generalAccurateBasicOCRCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSString *language_type = call.arguments[@"language_type"]?:@"CHN_ENG";
    NSString *detect_direction = call.arguments[@"detect_direction"]?:@"true";
    
    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        NSDictionary *options = @{@"language_type": language_type, @"detect_direction": detect_direction};
        [[AipOcrService shardService] detectTextAccurateBasicFromImage:image
                                                           withOptions:options
                                                        successHandler:^(id aipOcrResult){
                                                            NSLog(@"通用文字识别(高精度版):%@\n",aipOcrResult);
                                                            result([FlutterAipocrPlugin dictionaryToJson:aipOcrResult]);
                                                            [[[UIApplication sharedApplication].keyWindow rootViewController] dismissViewControllerAnimated:YES completion:nil];
                                                        }
                                                           failHandler:^(NSError *error){
                                                               result([FlutterError errorWithCode:[NSString stringWithFormat:@"%ld",(long)error.code]
                                                                                          message:error.description
                                                                                          details:nil] );
                                                           }];
        
    }];
    
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}
#pragma mark - 通用文字识别(含位置信息版)
- (void)generalOCRCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSString *language_type = call.arguments[@"language_type"]?:@"CHN_ENG";
    NSString *detect_direction = call.arguments[@"detect_direction"]?:@"true";
    
    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        // 在这个block里，image即为切好的图片，可自行选择如何处理
        NSDictionary *options = @{@"language_type": language_type, @"detect_direction": detect_direction};
        [[AipOcrService shardService] detectTextFromImage:image
                                              withOptions:options
                                           successHandler:^(id aipOcrResult){
                                               NSLog(@"通用文字识别(含位置信息版):%@\n",aipOcrResult);
                                               result([FlutterAipocrPlugin dictionaryToJson:aipOcrResult]);
                                               [[[UIApplication sharedApplication].keyWindow rootViewController] dismissViewControllerAnimated:YES completion:nil];
                                           }
                                              failHandler:^(NSError *error){
                                                  result([FlutterError errorWithCode:[NSString stringWithFormat:@"%ld",(long)error.code]
                                                                             message:error.description
                                                                             details:nil] );
                                              }];
        
    }];
    
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
    
    
}
#pragma mark - 通用文字识别(高精度含位置版)
- (void)generalAccurateOCRCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSString *language_type = call.arguments[@"language_type"]?:@"CHN_ENG";
    NSString *detect_direction = call.arguments[@"detect_direction"]?:@"true";
    
    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        // 在这个block里，image即为切好的图片，可自行选择如何处理
        NSDictionary *options = @{@"language_type": language_type, @"detect_direction": detect_direction};
        [[AipOcrService shardService] detectTextAccurateFromImage:image
                                                      withOptions:options
                                                   successHandler:^(id aipOcrResult){
                                                       NSLog(@"通用文字识别(高精度含位置版):%@\n",aipOcrResult);
                                                       result([FlutterAipocrPlugin dictionaryToJson:aipOcrResult]);
                                                       [[[UIApplication sharedApplication].keyWindow rootViewController] dismissViewControllerAnimated:YES completion:nil];
                                                   }
                                                      failHandler:^(NSError *error){
                                                          result([FlutterError errorWithCode:[NSString stringWithFormat:@"%ld",(long)error.code]
                                                                                     message:error.description
                                                                                     details:nil] );
                                                      }];
        
    }];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
    
    
}
#pragma mark - 通用文字识别(含生僻字版)
- (void)generalEnchancedOCRCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSString *language_type = call.arguments[@"language_type"]?:@"CHN_ENG";
    NSString *detect_direction = call.arguments[@"detect_direction"]?:@"true";
    
    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        NSDictionary *options = @{@"language_type": language_type, @"detect_direction": detect_direction};
        [[AipOcrService shardService] detectTextEnhancedFromImage:image
                                                      withOptions:options
                                                   successHandler:^(id aipOcrResult){
                                                       NSLog(@"通用文字识别(含生僻字版):%@\n",aipOcrResult);
                                                    
                                                       result([FlutterAipocrPlugin dictionaryToJson:aipOcrResult]);
                                                       [[[UIApplication sharedApplication].keyWindow rootViewController] dismissViewControllerAnimated:YES completion:nil];
                                                   }
                                                      failHandler:^(NSError *error){
                                                          result([FlutterError errorWithCode:[NSString stringWithFormat:@"%ld",(long)error.code]
                                                                                     message:error.description
                                                                                     details:nil] );
                                                      }];
    }];
    
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
    
}
#pragma mark - 网络图片文字识别
- (void)webImageOCRCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        
        [[AipOcrService shardService] detectWebImageFromImage:image
                                                  withOptions:nil
                                               successHandler:^(id aipOcrResult){
                                                   NSLog(@"网络图片文字识别:%@\n",aipOcrResult);
                                                   result([FlutterAipocrPlugin dictionaryToJson:aipOcrResult]);
                                                   [[[UIApplication sharedApplication].keyWindow rootViewController] dismissViewControllerAnimated:YES completion:nil];
                                               }
                                                  failHandler:^(NSError *error){
                                                      result([FlutterError errorWithCode:[NSString stringWithFormat:@"%ld",(long)error.code]
                                                                                 message:error.description
                                                                                 details:nil] );
                                                  }];
        
    }];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
    
}

#pragma mark - 身份证正面拍照识别
- (void)idcardOCROnlineFrontCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    UIViewController * vc =
    [AipCaptureCardVC ViewControllerWithCardType:CardTypeIdCardFont
                                 andImageHandler:^(UIImage *image) {
                                     
                                     [[AipOcrService shardService] detectIdCardFrontFromImage:image
                                                                                  withOptions:nil
                                                                               successHandler:^(id aipOcrResult){
                                                                                   
                                                                                   NSLog(@"身份证正面拍照识别:%@\n",aipOcrResult);
                                                                                  
                                                                                   result([FlutterAipocrPlugin dictionaryToJson:aipOcrResult]);
                                                                                   [[[UIApplication sharedApplication].keyWindow rootViewController] dismissViewControllerAnimated:YES completion:nil];
                                                                               }
                                                                                  failHandler:^(NSError *error){
                                                                                      result([FlutterError errorWithCode:[NSString stringWithFormat:@"%ld",(long)error.code]
                                                                                                                 message:error.description
                                                                                                                 details:nil] );
                                                                                  }];
                                 }];
    
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
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

              NSLog(@"身份证反面拍照识别:%@\n",aipOcrResult);
              result([FlutterAipocrPlugin dictionaryToJson:aipOcrResult]);
              [[[UIApplication sharedApplication].keyWindow rootViewController] dismissViewControllerAnimated:YES
                                                                                                   completion:nil];
          }
                                                     failHandler:^(NSError *error)
          {
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%ld",(long)error.code]
                                         message:error.description
                                         details:nil] );
          }];
     }];

    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
    
}
#pragma mark - 身份证正面(嵌入式质量控制+云端识别)
- (void)localIdcardOCROnlineFrontCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    UIViewController * vc =
    [AipCaptureCardVC ViewControllerWithCardType:CardTypeLocalIdCardFont
                                 andImageHandler:^(UIImage *image) {
                                     
                                     [[AipOcrService shardService] detectIdCardFrontFromImage:image
                                                                                  withOptions:nil
                                                                               successHandler:^(id aipOcrResult){
                                                                                   
                                                                                   NSLog(@"身份证反面拍照识别:%@\n",aipOcrResult);
                                                                                   result([FlutterAipocrPlugin dictionaryToJson:aipOcrResult]);
                                                                                   [[[UIApplication sharedApplication].keyWindow rootViewController] dismissViewControllerAnimated:YES completion:nil];
                                                                               }
                                                                                  failHandler:^(NSError *error){
                                                                                      result([FlutterError errorWithCode:[NSString stringWithFormat:@"%ld",(long)error.code]
                                                                                                                 message:error.description
                                                                                                                 details:nil] );
                                                                                  }];
                                 }];
    
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
    
}
#pragma mark - 身份证反面(嵌入式质量控制+云端识别)
- (void)localIdcardOCROnlineBackCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    UIViewController * vc =
    [AipCaptureCardVC ViewControllerWithCardType:CardTypeLocalIdCardBack
                                 andImageHandler:^(UIImage *image) {
                                     
                                     [[AipOcrService shardService] detectIdCardFrontFromImage:image
                                                                                  withOptions:nil
                                                                               successHandler:^(id aipOcrResult){
                                                                                   
                                                                                   NSLog(@"身份证反面拍照识别:%@\n",aipOcrResult);
                                                                                   result([FlutterAipocrPlugin dictionaryToJson:aipOcrResult]);
                                                                                   [[[UIApplication sharedApplication].keyWindow rootViewController] dismissViewControllerAnimated:YES completion:nil];
                                                                               }
                                                                                  failHandler:^(NSError *error){
                                                                                      result([FlutterError errorWithCode:[NSString stringWithFormat:@"%ld",(long)error.code]
                                                                                                                 message:error.description
                                                                                                                 details:nil] );
                                                                                  }];
                                 }];
    
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
    
}
#pragma mark - 银行卡正面拍照识别
- (void)bankCardOCROnlineCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    UIViewController * vc =
    [AipCaptureCardVC ViewControllerWithCardType:CardTypeBankCard
                                 andImageHandler:^(UIImage *image) {
                                     
                                     [[AipOcrService shardService] detectBankCardFromImage:image
                                                                            successHandler:^(id aipOcrResult){
                                                                                
                                                                                NSLog(@"银行卡正面拍照识别:%@\n",aipOcrResult);
                                                                                result([FlutterAipocrPlugin dictionaryToJson:aipOcrResult]);
                                                                                [[[UIApplication sharedApplication].keyWindow rootViewController] dismissViewControllerAnimated:YES completion:nil];
                                                                            }
                                                                               failHandler:^(NSError *error){
                                                                                   result([FlutterError errorWithCode:[NSString stringWithFormat:@"%ld",(long)error.code]
                                                                                                              message:error.description
                                                                                                              details:nil] );
                                                                               }];
                                 }];
    
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
    
}
#pragma mark - 驾驶证识别
- (void)drivingLicenseOCRCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        
        [[AipOcrService shardService] detectDrivingLicenseFromImage:image
                                                        withOptions:nil
                                                     successHandler:^(id aipOcrResult){
                                                         
                                                         NSLog(@"驾驶证识别:%@\n",aipOcrResult);
                                                         result([FlutterAipocrPlugin dictionaryToJson:aipOcrResult]);
                                                         [[[UIApplication sharedApplication].keyWindow rootViewController] dismissViewControllerAnimated:YES completion:nil];
                                                     }
                                                        failHandler:^(NSError *error){
                                                            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%ld",(long)error.code]
                                                                                       message:error.description
                                                                                       details:nil] );
                                                        }];
        
    }];
    
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
    
}
#pragma mark - 行驶证识别
- (void)vehicleLicenseOCRCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        
        [[AipOcrService shardService] detectVehicleLicenseFromImage:image
                                                        withOptions:nil
                                                     successHandler:^(id aipOcrResult){
                                                         
                                                         NSLog(@"行驶证识别:%@\n",aipOcrResult);
                                                         result([FlutterAipocrPlugin dictionaryToJson:aipOcrResult]);
                                                         [[[UIApplication sharedApplication].keyWindow rootViewController] dismissViewControllerAnimated:YES completion:nil];
                                                     }
                                                        failHandler:^(NSError *error){
                                                            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%ld",(long)error.code]
                                                                                       message:error.description
                                                                                       details:nil] );
                                                        }];
    }];
    
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
    
}
#pragma mark - 车牌识别
- (void)plateLicenseOCRCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        
        [[AipOcrService shardService] detectPlateNumberFromImage:image
                                                     withOptions:nil
                                                  successHandler:^(id aipOcrResult){
                                                      
                                                      NSLog(@"车牌识别:%@\n",aipOcrResult);
                                                      result([FlutterAipocrPlugin dictionaryToJson:aipOcrResult]);
                                                      [[[UIApplication sharedApplication].keyWindow rootViewController] dismissViewControllerAnimated:YES completion:nil];
                                                  }
                                                     failHandler:^(NSError *error){
                                                         result([FlutterError errorWithCode:[NSString stringWithFormat:@"%ld",(long)error.code]
                                                                                    message:error.description
                                                                                    details:nil] );
                                                     }];
        
    }];
    
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
    
}
#pragma mark - 营业执照识别
- (void)businessLicenseOCRCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        
        [[AipOcrService shardService] detectBusinessLicenseFromImage:image
                                                         withOptions:nil
                                                      successHandler:^(id aipOcrResult){
                                                          
                                                          NSLog(@"营业执照识别:%@\n",aipOcrResult);
                                                          result([FlutterAipocrPlugin dictionaryToJson:aipOcrResult]);
                                                          [[[UIApplication sharedApplication].keyWindow rootViewController] dismissViewControllerAnimated:YES completion:nil];
                                                      }
                                                         failHandler:^(NSError *error){
                                                             result([FlutterError errorWithCode:[NSString stringWithFormat:@"%ld",(long)error.code]
                                                                                        message:error.description
                                                                                        details:nil] );
                                                         }];
        
    }];
    
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
    
}

#pragma mark - 票据识别
- (void)receiptOCRCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        
        [[AipOcrService shardService] detectReceiptFromImage:image
                                                 withOptions:nil
                                              successHandler:^(id aipOcrResult){
                                                  
                                                  NSLog(@"票据识别:%@\n",aipOcrResult);
                                                  result([FlutterAipocrPlugin dictionaryToJson:aipOcrResult]);
                                                  [[[UIApplication sharedApplication].keyWindow rootViewController] dismissViewControllerAnimated:YES completion:nil];
                                              }
                                                 failHandler:^(NSError *error){
                                                     result([FlutterError errorWithCode:[NSString stringWithFormat:@"%ld",(long)error.code]
                                                                                message:error.description
                                                                                details:nil] );
                                                 }];
        
    }];
    
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
    
}
#pragma mark - 自定义模板识别
- (void)iOCRCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        
        NSDictionary *options = call.arguments[@"options"];
        [[AipOcrService shardService] iOCRRecognitionFromImage:image
                                                   withOptions:options
                                                successHandler:^(id aipOcrResult){
                                                    
                                                    NSLog(@"自定义模板识别:%@\n",aipOcrResult);
                                                    result([FlutterAipocrPlugin dictionaryToJson:aipOcrResult]);
                                                    [[[UIApplication sharedApplication].keyWindow rootViewController] dismissViewControllerAnimated:YES completion:nil];
                                                }
                                                   failHandler:^(NSError *error){
                                                       result([FlutterError errorWithCode:[NSString stringWithFormat:@"%ld",(long)error.code]
                                                                                  message:error.description
                                                                                  details:nil] );
                                                   }];
        
    }];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
    
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


