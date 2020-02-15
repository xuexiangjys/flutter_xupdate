package com.xuexiang.flutter_xupdate;

import com.xuexiang.xupdate.entity.UpdateEntity;
import com.xuexiang.xupdate.listener.IUpdateParseCallback;
import com.xuexiang.xupdate.proxy.IUpdateParser;

import java.lang.ref.WeakReference;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;

/**
 * Flutter端自定义版本更新解析器
 *
 * @author xuexiang
 * @since 2020-02-15 15:21
 */
public class FlutterCustomUpdateParser implements IUpdateParser {

    private WeakReference<MethodChannel> mMethodChannel;

    public FlutterCustomUpdateParser(MethodChannel channel) {
        mMethodChannel = new WeakReference<>(channel);
    }

    @Override
    public UpdateEntity parseJson(String json) throws Exception {
        return null;
    }

    @Override
    public void parseJson(String json, final IUpdateParseCallback callback) throws Exception {
        Map<String, Object> map = new HashMap<>(3);
        map.put("update_json", json);
        mMethodChannel.get().invokeMethod("onCustomUpdateParse", map, new MethodChannel.Result() {
            @Override
            public void success(Object result) {
                handleCustomParseResult((HashMap<String, Object>) result, callback);
            }

            @Override
            public void error(String errorCode, String errorMessage, Object errorDetails) {

            }

            @Override
            public void notImplemented() {
            }
        });
    }

    /**
     * 处理flutter端自定义处理的json解析
     *
     * @param result
     * @param callback
     */
    private void handleCustomParseResult(HashMap<String, Object> result, IUpdateParseCallback callback) {

        callback.onParseResult(parseUpdateEntityMap(result));
    }

    /**
     * 解析Flutter传过来的UpdateEntity Map
     *
     * @param map
     * @return
     */
    public static UpdateEntity parseUpdateEntityMap(HashMap<String, Object> map) {
        //必填项
        boolean hasUpdate = (boolean) map.get("hasUpdate");
        int versionCode = (int) map.get("versionCode");
        String versionName = (String) map.get("versionName");
        String updateContent = (String) map.get("updateContent");
        String downloadUrl = (String) map.get("downloadUrl");

        UpdateEntity updateEntity = new UpdateEntity();
        updateEntity.setHasUpdate(hasUpdate)
                .setVersionCode(versionCode)
                .setVersionName(versionName)
                .setUpdateContent(updateContent)
                .setDownloadUrl(downloadUrl);

        Object isForce = map.get("isForce");
        Object isIgnorable = map.get("isIgnorable");
        Object apkSize = map.get("apkSize");
        Object apkMd5 = map.get("apkMd5");

        if (isForce != null) {
            updateEntity.setForce((Boolean) isForce);
        }
        if (isIgnorable != null) {
            updateEntity.setIsIgnorable((Boolean) isIgnorable);
        }
        if (apkSize != null) {
            updateEntity.setSize((Integer) apkSize);
        }
        if (apkMd5 != null) {
            updateEntity.setMd5((String) apkMd5);
        }

        return updateEntity;
    }


    @Override
    public boolean isAsyncParser() {
        return true;
    }
}
