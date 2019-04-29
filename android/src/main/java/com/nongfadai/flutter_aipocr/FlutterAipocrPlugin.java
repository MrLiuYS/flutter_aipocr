package com.nongfadai.flutter_aipocr;

import android.app.Activity;
import android.content.Intent;

import android.text.TextUtils;
import android.util.Log;

import com.baidu.ocr.sdk.OCR;
import com.baidu.ocr.sdk.OnResultListener;
import com.baidu.ocr.sdk.exception.OCRError;
import com.baidu.ocr.sdk.model.AccessToken;
import com.baidu.ocr.sdk.model.IDCardParams;
import com.baidu.ocr.sdk.model.IDCardResult;
import com.baidu.ocr.ui.camera.CameraActivity;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterAipocrPlugin */
public class FlutterAipocrPlugin implements MethodCallHandler {
  /** Plugin registration. */

  private Map<String,Result> resultMap;
  private Activity activity;
  private Registrar registrar;

  private static final int REQUEST_CODE_CAMERA = 102;//身份证
  private static final int REQUEST_CODE_GENERAL = 105;//通用文字识别（含位置信息版）
  private static final int REQUEST_CODE_GENERAL_BASIC = 106;//通用文字识别
  private static final int REQUEST_CODE_ACCURATE_BASIC = 107;//通用文字识别(高精度版)
  private static final int REQUEST_CODE_ACCURATE = 108;//通用文字识别（含位置信息高精度版）
  private static final int REQUEST_CODE_GENERAL_ENHANCED = 109;//通用文字识别（含生僻字版）
  private static final int REQUEST_CODE_GENERAL_WEBIMAGE = 110;//网络图片识别
  private static final int REQUEST_CODE_BANKCARD = 111;//银行卡识别
  private static final int REQUEST_CODE_VEHICLE_LICENSE = 120;//行驶证识别
  private static final int REQUEST_CODE_DRIVING_LICENSE = 121;// 驾驶证识别
  private static final int REQUEST_CODE_LICENSE_PLATE = 122;//车牌识别
  private static final int REQUEST_CODE_BUSINESS_LICENSE = 123;//营业执照
  private static final int REQUEST_CODE_RECEIPT = 124;//通用票据识别


  private FlutterAipocrPlugin(Activity activity) {
    this.resultMap = new HashMap<>();
    this.activity = activity;
  }

  public static void registerWith(final Registrar registrar) {

    final FlutterAipocrPlugin plugin = new FlutterAipocrPlugin(registrar.activity());

    plugin.registrar = registrar;

    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_aipocr");
    channel.setMethodCallHandler(plugin);

  }


  private void recIDCard(String idCardSide, String filePath, final String contentType) {
    IDCardParams param = new IDCardParams();
    param.setImageFile(new File(filePath));
    // 设置身份证正反面
    param.setIdCardSide(idCardSide);
    // 设置方向检测
    param.setDetectDirection(true);
    // 设置图像参数压缩质量0-100, 越大图像质量越好但是请求时间越长。 不设置则默认值为20
    param.setImageQuality(20);

    OCR.getInstance(activity).recognizeIDCard(param, new OnResultListener<IDCardResult>() {
      @Override
      public void onResult(IDCardResult result) {
        if (result != null) {
          Log.d("mrliuys", result.getJsonRes());
          Result result1 = resultMap.get(contentType);
          if (result1 != null){
            result1.success(result.getJsonRes());
          }
        }
      }
      @Override
      public void onError(OCRError error) {
        Result result1 = resultMap.get(contentType);
        if (result1 != null){
          result1.error(String.valueOf(error.getErrorCode()),error.getMessage(),null);
        }
      }
    });
  }

  /// 添加返回监听
  private void addActivityResultListener() {

    registrar.addActivityResultListener(new PluginRegistry.ActivityResultListener() {
      @Override
      public boolean onActivityResult(int requestCode, int resultCode, Intent data) {

        // 识别成功回调，通用文字识别
        if (requestCode == REQUEST_CODE_GENERAL_BASIC && resultCode == Activity.RESULT_OK) {
          RecognizeService.recGeneralBasic(registrar.context(), FileUtil.getSaveFile(registrar.context()).getAbsolutePath(),
                  new RecognizeService.ServiceListener() {
                    @Override
                    public void onResult(String result) {
                      Log.d("mrliuys", result);

                      Result result1 = resultMap.get(String.valueOf(REQUEST_CODE_GENERAL_BASIC));
                      if (result1 != null){
                        result1.success(result);
                      }
                    }
                  });
        }
        // 识别成功回调，通用文字识别（高精度版）
        if (requestCode == REQUEST_CODE_ACCURATE_BASIC && resultCode == Activity.RESULT_OK) {
          RecognizeService.recAccurateBasic(registrar.context(), FileUtil.getSaveFile(registrar.context()).getAbsolutePath(),
                  new RecognizeService.ServiceListener() {
                    @Override
                    public void onResult(String result) {
                      Log.d("mrliuys", result);

                      Result result1 = resultMap.get(String.valueOf(REQUEST_CODE_ACCURATE_BASIC));
                      if (result1 != null){
                        result1.success(result);
                      }
                    }
                  });
        }
        // 识别成功回调，通用文字识别（含位置信息）
        if (requestCode == REQUEST_CODE_GENERAL && resultCode == Activity.RESULT_OK) {
          RecognizeService.recGeneral(registrar.context(), FileUtil.getSaveFile(registrar.context()).getAbsolutePath(),
                  new RecognizeService.ServiceListener() {
                    @Override
                    public void onResult(String result) {
                      Result result1 = resultMap.get(String.valueOf(REQUEST_CODE_GENERAL));
                      if (result1 != null){
                        result1.success(result);
                      }
                    }
                  });
        }
        // 识别成功回调，通用文字识别（含位置信息高精度版）
        if (requestCode == REQUEST_CODE_ACCURATE && resultCode == Activity.RESULT_OK) {
          RecognizeService.recAccurate(registrar.context(), FileUtil.getSaveFile(registrar.context()).getAbsolutePath(),
                  new RecognizeService.ServiceListener() {
                    @Override
                    public void onResult(String result) {
                      Result result1 = resultMap.get(String.valueOf(REQUEST_CODE_ACCURATE));
                      if (result1 != null){
                        result1.success(result);
                      }
                    }
                  });
        }
        // 识别成功回调，通用文字识别（含生僻字版）
        if (requestCode == REQUEST_CODE_GENERAL_ENHANCED && resultCode == Activity.RESULT_OK) {
          RecognizeService.recGeneralEnhanced(registrar.context(), FileUtil.getSaveFile(registrar.context()).getAbsolutePath(),
                  new RecognizeService.ServiceListener() {
                    @Override
                    public void onResult(String result) {
                      Result result1 = resultMap.get(String.valueOf(REQUEST_CODE_GENERAL_ENHANCED));
                      if (result1 != null){
                        result1.success(result);
                      }
                    }
                  });
        }
        // 识别成功回调，网络图片文字识别
        if (requestCode == REQUEST_CODE_GENERAL_WEBIMAGE && resultCode == Activity.RESULT_OK) {
          RecognizeService.recWebimage(registrar.context(), FileUtil.getSaveFile(registrar.context()).getAbsolutePath(),
                  new RecognizeService.ServiceListener() {
                    @Override
                    public void onResult(String result) {
                      Result result1 = resultMap.get(String.valueOf(REQUEST_CODE_GENERAL_WEBIMAGE));
                      if (result1 != null){
                        result1.success(result);
                      }
                    }
                  });
        }

        // 识别成功回调，银行卡识别
        if (requestCode == REQUEST_CODE_BANKCARD && resultCode == Activity.RESULT_OK) {
          RecognizeService.recBankCard(registrar.context(), FileUtil.getSaveFile(registrar.context()).getAbsolutePath(),
                  new RecognizeService.ServiceListener() {
                    @Override
                    public void onResult(String result) {
                      Result result1 = resultMap.get(String.valueOf(REQUEST_CODE_BANKCARD));
                      if (result1 != null){
                        result1.success(result);
                      }
                    }
                  });
        }
        // 识别成功回调，行驶证识别
        if (requestCode == REQUEST_CODE_VEHICLE_LICENSE && resultCode == Activity.RESULT_OK) {
          RecognizeService.recVehicleLicense(registrar.context(), FileUtil.getSaveFile(registrar.context()).getAbsolutePath(),
                  new RecognizeService.ServiceListener() {
                    @Override
                    public void onResult(String result) {
                      Result result1 = resultMap.get(String.valueOf(REQUEST_CODE_VEHICLE_LICENSE));
                      if (result1 != null){
                        result1.success(result);
                      }
                    }
                  });
        }
        // 识别成功回调，驾驶证识别
        if (requestCode == REQUEST_CODE_DRIVING_LICENSE && resultCode == Activity.RESULT_OK) {
          RecognizeService.recDrivingLicense(registrar.context(), FileUtil.getSaveFile(registrar.context()).getAbsolutePath(),
                  new RecognizeService.ServiceListener() {
                    @Override
                    public void onResult(String result) {
                      Result result1 = resultMap.get(String.valueOf(REQUEST_CODE_DRIVING_LICENSE));
                      if (result1 != null){
                        result1.success(result);
                      }
                    }
                  });
        }
        // 识别成功回调，车牌识别
        if (requestCode == REQUEST_CODE_LICENSE_PLATE && resultCode == Activity.RESULT_OK) {
          RecognizeService.recLicensePlate(registrar.context(), FileUtil.getSaveFile(registrar.context()).getAbsolutePath(),
                  new RecognizeService.ServiceListener() {
                    @Override
                    public void onResult(String result) {
                      Result result1 = resultMap.get(String.valueOf(REQUEST_CODE_LICENSE_PLATE));
                      if (result1 != null){
                        result1.success(result);
                      }
                    }
                  });
        }
        // 识别成功回调，通用票据识别
        if (requestCode == REQUEST_CODE_RECEIPT && resultCode == Activity.RESULT_OK) {
          RecognizeService.recReceipt(registrar.context(), FileUtil.getSaveFile(registrar.context()).getAbsolutePath(),
                  new RecognizeService.ServiceListener() {
                    @Override
                    public void onResult(String result) {
                      Result result1 = resultMap.get(String.valueOf(REQUEST_CODE_RECEIPT));
                      if (result1 != null){
                        result1.success(result);
                      }
                    }
                  });
        }

        // 身份证
        if (requestCode == REQUEST_CODE_CAMERA && resultCode == Activity.RESULT_OK) {
          if (data != null) {
            String contentType = data.getStringExtra(CameraActivity.KEY_CONTENT_TYPE);
            String filePath = FileUtil.getSaveFile(registrar.context()).getAbsolutePath();
            if (!TextUtils.isEmpty(contentType)) {

              if (CameraActivity.CONTENT_TYPE_ID_CARD_FRONT.equals(contentType)) {
                // 身份证正面
                recIDCard(IDCardParams.ID_CARD_SIDE_FRONT, filePath,contentType);
              } else if (CameraActivity.CONTENT_TYPE_ID_CARD_BACK.equals(contentType)) {
                // 身份证反面
                recIDCard(IDCardParams.ID_CARD_SIDE_BACK, filePath,contentType);
              }
            }
          }
        }
        // 识别成功回调，营业执照识别
        if (requestCode == REQUEST_CODE_BUSINESS_LICENSE && resultCode == Activity.RESULT_OK) {
          final String contentType = data.getStringExtra(CameraActivity.KEY_CONTENT_TYPE);
          RecognizeService.recBusinessLicense(registrar.context(), FileUtil.getSaveFile(registrar.context()).getAbsolutePath(),
                  new RecognizeService.ServiceListener() {
                    @Override
                    public void onResult(String result) {
                      Log.d("mrliuys", result);

                      Result result1 = resultMap.get(String.valueOf(REQUEST_CODE_BUSINESS_LICENSE));
                      if (result1 != null){
                        result1.success(result);
                      }
                    }
                  });
        }

        return true;
      }
    });

  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {

    addActivityResultListener();

    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    }

    else if ("init".equals(call.method)) {
      String appKey = call.argument("appKey").toString();
      String secretKey = call.argument("secretKey").toString();
      //初始化百度ocr
      OCR.getInstance(activity).initAccessTokenWithAkSk(new OnResultListener<AccessToken>() {
        @Override
        public void onResult(AccessToken result) {
          String token = result.getAccessToken();
        }
        @Override
        public void onError(OCRError error) {
          error.printStackTrace();
        }
      }, activity,  appKey, secretKey);

      result.success(true);
    }
    else if ("generalBasicOCR".equals(call.method)) {
      //通用文字识别
      generalBasicOCRCall(call, result);

    }
    else if ("generalAccurateBasicOCR".equals(call.method)) {
      //通用文字识别(高精度版)
      generalAccurateBasicOCRCall(call, result);

    }
    else if ("generalOCR".equals(call.method)) {
      //通用文字识别(含位置信息版)
      generalOCRCall(call, result);

    }else if ("generalAccurateOCR".equals(call.method)) {
      //通用文字识别(高精度含位置版)
      generalAccurateOCRCall(call, result);

    }else if ("generalEnchancedOCR".equals(call.method)) {
      //通用文字识别(含生僻字版)
      generalEnchancedOCRCall(call, result);
    }else if ("webImageOCR".equals(call.method)) {
      //网络图片文字识别
      webImageOCRCall(call, result);
    }else if ("idcardOCROnlineFront".equals(call.method)) {
      //身份证正面拍照识别

      idcardOCROnlineFrontCall(call, result);

    }else if ("idcardOCROnlineBack".equals(call.method)) {
      //身份证反面拍照识别
      idcardOCROnlineBackCall(call, result);

    }else if ("localIdcardOCROnlineFront".equals(call.method)) {
      //身份证正面(嵌入式质量控制+云端识别)
//        [self localIdcardOCROnlineFrontCall:call result:result];

    }else if ("localIdcardOCROnlineBack".equals(call.method)) {
      //身份证反面(嵌入式质量控制+云端识别)
//        [self localIdcardOCROnlineBackCall:call result:result];

    }else if ("bankCardOCROnline".equals(call.method)) {
      //银行卡正面拍照识别

      bankCardOCROnlineCall(call, result);

    }else if ("drivingLicenseOCR".equals(call.method)) {
      //驾驶证识别
      drivingLicenseOCRCall(call, result);

    }else if ("vehicleLicenseOCR".equals(call.method)) {
      //行驶证识别
      vehicleLicenseOCRCall(call, result);

    }else if ("plateLicenseOCR".equals(call.method)) {
      //车牌识别

      plateLicenseOCRCall(call, result);

    }else if ("receiptOCR".equals(call.method)) {
      //票据识别
      receiptOCRCall(call, result);

    }else if ("iOCR".equals(call.method)) {
      //自定义模板识别

    }
    else if ("businessLicenseOCR".equals(call.method)) {
      //营业执照识别
      businessLicenseOCRCall(call, result);
    }
    else {
      result.notImplemented();
    }
  }

  /// 通用文字识别
  private void generalBasicOCRCall(MethodCall call, Result result) {

    Intent intent = new Intent(activity, CameraActivity.class);
    intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH,
            FileUtil.getSaveFile(activity).getAbsolutePath());
    intent.putExtra(CameraActivity.KEY_CONTENT_TYPE,
            CameraActivity.CONTENT_TYPE_GENERAL);
    activity.startActivityForResult(intent, REQUEST_CODE_GENERAL_BASIC);

    resultMap.put(String.valueOf(REQUEST_CODE_GENERAL_BASIC),result);

  }
  /// 通用文字识别(高精度版)
  private void generalAccurateBasicOCRCall(MethodCall call, Result result) {

    Intent intent = new Intent(activity, CameraActivity.class);
    intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH,
            FileUtil.getSaveFile(activity).getAbsolutePath());
    intent.putExtra(CameraActivity.KEY_CONTENT_TYPE,
            CameraActivity.CONTENT_TYPE_GENERAL);
    activity.startActivityForResult(intent, REQUEST_CODE_ACCURATE_BASIC);

    resultMap.put(String.valueOf(REQUEST_CODE_ACCURATE_BASIC),result);

  }

  /// 通用文字识别(含位置信息版)
  private void generalOCRCall(MethodCall call, Result result) {

    Intent intent = new Intent(activity, CameraActivity.class);
    intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH,
            FileUtil.getSaveFile(activity).getAbsolutePath());
    intent.putExtra(CameraActivity.KEY_CONTENT_TYPE,
            CameraActivity.CONTENT_TYPE_GENERAL);
    activity.startActivityForResult(intent, REQUEST_CODE_GENERAL);


    resultMap.put(String.valueOf(REQUEST_CODE_GENERAL), result);
  }
  /// 通用文字识别（含位置信息高精度版）
  private void generalAccurateOCRCall(MethodCall call, Result result) {

    Intent intent = new Intent(activity, CameraActivity.class);
    intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH,
            FileUtil.getSaveFile(activity).getAbsolutePath());
    intent.putExtra(CameraActivity.KEY_CONTENT_TYPE,
            CameraActivity.CONTENT_TYPE_GENERAL);
    activity.startActivityForResult(intent, REQUEST_CODE_ACCURATE);
    resultMap.put(String.valueOf(REQUEST_CODE_ACCURATE), result);
  }
  /// 通用文字识别（含生僻字版）
  private void generalEnchancedOCRCall(MethodCall call, Result result) {


    Intent intent = new Intent(activity, CameraActivity.class);
    intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH,
            FileUtil.getSaveFile(activity).getAbsolutePath());
    intent.putExtra(CameraActivity.KEY_CONTENT_TYPE,
            CameraActivity.CONTENT_TYPE_GENERAL);
    activity.startActivityForResult(intent, REQUEST_CODE_GENERAL_ENHANCED);


    resultMap.put(String.valueOf(REQUEST_CODE_GENERAL_ENHANCED), result);
  }
  /// 网络图片识别
  private void webImageOCRCall(MethodCall call, Result result) {

    Intent intent = new Intent(activity, CameraActivity.class);
    intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH,
            FileUtil.getSaveFile(activity).getAbsolutePath());
    intent.putExtra(CameraActivity.KEY_CONTENT_TYPE,
            CameraActivity.CONTENT_TYPE_GENERAL);
    activity.startActivityForResult(intent, REQUEST_CODE_GENERAL_WEBIMAGE);

    resultMap.put(String.valueOf(REQUEST_CODE_GENERAL_WEBIMAGE), result);
  }

  /// 身份证反面拍照识别
  private void idcardOCROnlineBackCall(MethodCall call, Result result) {

    Intent intent = new Intent(activity, CameraActivity.class);
    intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH,
            FileUtil.getSaveFile(activity).getAbsolutePath());
    intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_ID_CARD_BACK);

    activity.startActivityForResult(intent, REQUEST_CODE_CAMERA);

    resultMap.put(CameraActivity.CONTENT_TYPE_ID_CARD_BACK,result);

  }
  /// 身份证正面拍照识别
  private void idcardOCROnlineFrontCall(MethodCall call, Result result) {

    Intent intent = new Intent(activity, CameraActivity.class);
    intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH,
            FileUtil.getSaveFile(activity).getAbsolutePath());
    intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_ID_CARD_FRONT);

    activity.startActivityForResult(intent, REQUEST_CODE_CAMERA);

    resultMap.put(CameraActivity.CONTENT_TYPE_ID_CARD_FRONT,result);

  }

  /// 银行卡识别
  private void bankCardOCROnlineCall(MethodCall call, Result result) {


    Intent intent = new Intent(activity, CameraActivity.class);
    intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH,
            FileUtil.getSaveFile(activity).getAbsolutePath());
    intent.putExtra(CameraActivity.KEY_CONTENT_TYPE,
            CameraActivity.CONTENT_TYPE_BANK_CARD);
    activity.startActivityForResult(intent, REQUEST_CODE_BANKCARD);


    resultMap.put(String.valueOf(REQUEST_CODE_BANKCARD),result);

  }
  /// 驾驶证识别
  private void drivingLicenseOCRCall(MethodCall call, Result result) {

    Intent intent = new Intent(activity, CameraActivity.class);
    intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH,
            FileUtil.getSaveFile(activity).getAbsolutePath());
    intent.putExtra(CameraActivity.KEY_CONTENT_TYPE,
            CameraActivity.CONTENT_TYPE_GENERAL);
    activity.startActivityForResult(intent, REQUEST_CODE_DRIVING_LICENSE);

    resultMap.put(String.valueOf(REQUEST_CODE_DRIVING_LICENSE),result);

  }

  private void vehicleLicenseOCRCall(MethodCall call, Result result) {

    Intent intent = new Intent(activity, CameraActivity.class);
    intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH,
            FileUtil.getSaveFile(activity).getAbsolutePath());
    intent.putExtra(CameraActivity.KEY_CONTENT_TYPE,
            CameraActivity.CONTENT_TYPE_GENERAL);
    activity.startActivityForResult(intent,REQUEST_CODE_VEHICLE_LICENSE );

    resultMap.put(String.valueOf(REQUEST_CODE_VEHICLE_LICENSE),result);

  }
  /// 车牌识别
  private void plateLicenseOCRCall(MethodCall call, Result result) {


    Intent intent = new Intent(activity, CameraActivity.class);
    intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH,
            FileUtil.getSaveFile(activity).getAbsolutePath());
    intent.putExtra(CameraActivity.KEY_CONTENT_TYPE,
            CameraActivity.CONTENT_TYPE_GENERAL);
    activity.startActivityForResult(intent, REQUEST_CODE_LICENSE_PLATE);

    resultMap.put(String.valueOf(REQUEST_CODE_LICENSE_PLATE),result);

  }
  /// 通用票据识别
  private void receiptOCRCall(MethodCall call, Result result) {

    Intent intent = new Intent(activity, CameraActivity.class);
    intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH,
            FileUtil.getSaveFile(activity).getAbsolutePath());
    intent.putExtra(CameraActivity.KEY_CONTENT_TYPE,
            CameraActivity.CONTENT_TYPE_GENERAL);
    activity.startActivityForResult(intent, REQUEST_CODE_RECEIPT);

    resultMap.put(String.valueOf(REQUEST_CODE_RECEIPT),result);

  }


  /// 营业执照
  private void businessLicenseOCRCall(MethodCall call, Result result) {

    Intent intent = new Intent(activity, CameraActivity.class);
    intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH,
            FileUtil.getSaveFile(activity).getAbsolutePath());
    intent.putExtra(CameraActivity.KEY_CONTENT_TYPE,
            CameraActivity.CONTENT_TYPE_GENERAL);
    activity.startActivityForResult(intent, REQUEST_CODE_BUSINESS_LICENSE);

    // TODO: 2019-04-26 唯一编码要调整

    resultMap.put(String.valueOf(REQUEST_CODE_BUSINESS_LICENSE),result);

  }




}
