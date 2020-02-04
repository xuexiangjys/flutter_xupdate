package com.xuexiang.flutter_xupdate;

import android.app.Activity;
import android.app.Application;

import androidx.annotation.NonNull;

import com.xuexiang.xupdate.UpdateManager;
import com.xuexiang.xupdate.XUpdate;
import com.xuexiang.xupdate.entity.UpdateError;
import com.xuexiang.xupdate.listener.OnUpdateFailureListener;
import com.xuexiang.xupdate.utils.UpdateUtils;

import java.lang.ref.WeakReference;
import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterXUpdatePlugin
 *
 * @author xuexiang
 * @since 2020-02-04 16:33
 */
public class FlutterXUpdatePlugin implements FlutterPlugin, ActivityAware, MethodCallHandler {

    private MethodChannel mMethodChannel;
    private Application mApplication;
    private WeakReference<Activity> mActivity;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        mMethodChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "com.xuexiang/flutter_xupdate");
        mApplication = (Application) flutterPluginBinding.getApplicationContext();
        mMethodChannel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        mMethodChannel.setMethodCallHandler(null);
        mMethodChannel = null;
    }

    public FlutterXUpdatePlugin initPlugin(MethodChannel methodChannel, Registrar registrar) {
        mMethodChannel = methodChannel;
        mApplication = (Application) registrar.context().getApplicationContext();
        mActivity = new WeakReference<>(registrar.activity());
        return this;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "getPlatformVersion":
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;
            case "initXUpdate":
                initXUpdate(call, result);
                break;
            case "checkUpdate":
                checkUpdate(call, result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    /**
     * 初始化
     *
     * @param call
     * @param result
     */
    private void initXUpdate(MethodCall call, Result result) {
        Map<String, Object> map = (Map<String, Object>) call.arguments;
        Boolean debug = (Boolean) map.get("debug");
        Boolean isGet = (Boolean) map.get("isGet");
        Boolean isPostJson = (Boolean) map.get("isPostJson");
        Boolean isWifiOnly = (Boolean) map.get("isWifiOnly");
        Boolean isAutoMode = (Boolean) map.get("isAutoMode");
        Boolean supportSilentInstall = (Boolean) map.get("supportSilentInstall");
        Boolean enableRetry = (Boolean) map.get("enableRetry");
        String retryContent = (String) map.get("retryContent");
        String retryUrl = (String) map.get("retryUrl");

        XUpdate.get()
                .debug(debug)
                //默认设置使用get请求检查版本
                .isGet(isGet)
                //默认设置只在wifi下检查版本更新
                .isWifiOnly(isWifiOnly)
                //默认设置非自动模式，可根据具体使用配置
                .isAutoMode(isAutoMode)
                //是否支持静默安装
                .supportSilentInstall(supportSilentInstall)
                .setOnUpdateFailureListener(new OnUpdateFailureListener() {
                    @Override
                    public void onFailure(UpdateError error) {
                        Map<String, Object> errorMap = new HashMap<>();
                        errorMap.put("code", error.getCode());
                        errorMap.put("message", error.getMessage());
                        errorMap.put("detailMsg", error.getDetailMsg());
                        if (mMethodChannel != null) {
                            mMethodChannel.invokeMethod("onUpdateError", errorMap);
                        }
                    }
                })
                //设置默认公共请求参数
                .param("versionCode", UpdateUtils.getVersionCode(mApplication))
                .param("appKey", mApplication.getPackageName())
                .setIUpdateDownLoader(new RetryUpdateDownloader(enableRetry, retryContent, retryUrl))
                //这个必须设置！实现网络请求功能。
                .setIUpdateHttpService(new OKHttpUpdateHttpService(isPostJson));
        if (map.get("params") != null) {
            XUpdate.get().params((Map<String, Object>) map.get("params"));
        }
        XUpdate.get().init(mApplication);

        result.success(map);

    }

    /**
     * 版本更新
     *
     * @param call
     * @param result
     */
    private void checkUpdate(MethodCall call, Result result) {
        if (mActivity == null || mActivity.get() == null) {
            result.error("1001", "Not attach a Activity", null);
        }

        String url = call.argument("url");
        boolean supportBackgroundUpdate = call.argument("supportBackgroundUpdate");
        boolean isAutoMode = call.argument("isAutoMode");
        Double widthRatio = call.argument("widthRatio");
        Double heightRatio = call.argument("heightRatio");

        boolean overrideGlobalRetryStrategy = call.argument("overrideGlobalRetryStrategy");
        boolean enableRetry = call.argument("enableRetry");
        String retryContent = call.argument("retryContent");
        String retryUrl = call.argument("retryUrl");

        UpdateManager.Builder builder = XUpdate.newBuild(mActivity.get())
                .updateUrl(url)
                .isAutoMode(isAutoMode)
                .supportBackgroundUpdate(supportBackgroundUpdate);
        if (call.argument("params") != null) {
            builder.params((Map<String, Object>) call.argument("params"));
        }
        if (widthRatio != null) {
            builder.promptWidthRatio(widthRatio.floatValue());
        }
        if (heightRatio != null) {
            builder.promptHeightRatio(heightRatio.floatValue());
        }
        if (overrideGlobalRetryStrategy) {
            builder.updateDownLoader(new RetryUpdateDownloader(enableRetry, retryContent, retryUrl));
        }
        builder.update();
    }


    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        mActivity = new WeakReference<>(binding.getActivity());
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {
        mActivity = null;
    }

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_xupdate");
        channel.setMethodCallHandler(new FlutterXUpdatePlugin().initPlugin(channel, registrar));
    }
}
