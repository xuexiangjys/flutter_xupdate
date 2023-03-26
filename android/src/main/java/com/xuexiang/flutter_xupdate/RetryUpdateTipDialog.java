/*
 * Copyright (C) 2019 xuexiangjys(xuexiangjys@163.com)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

package com.xuexiang.flutter_xupdate;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.xuexiang.xupdate.XUpdate;


/**
 * 版本更新重试提示弹窗
 *
 * @author xuexiang
 * @since 2019-06-15 00:06
 */
public class RetryUpdateTipDialog extends AppCompatActivity implements DialogInterface.OnDismissListener {

    public static final String KEY_CONTENT = "com.xuexiang.flutter_xupdate.KEY_CONTENT";
    public static final String KEY_URL = "com.xuexiang.flutter_xupdate.KEY_URL";


    /**
     * 显示版本更新重试提示弹窗
     *
     * @param content
     * @param url
     */
    public static void show(String content, String url) {
        Intent intent = new Intent(XUpdate.getContext(), RetryUpdateTipDialog.class);
        intent.putExtra(KEY_CONTENT, content);
        intent.putExtra(KEY_URL, url);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        XUpdate.getContext().startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);


        String content = getIntent().getStringExtra(KEY_CONTENT);
        final String url = getIntent().getStringExtra(KEY_URL);

        if (TextUtils.isEmpty(content)) {
            content = getString(R.string.xupdate_retry_tip_dialog_content);
        }

        AlertDialog dialog = new AlertDialog.Builder(this)
                .setMessage(content)
                .setPositiveButton(android.R.string.yes, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        dialog.dismiss();
                        goWeb(url);
                    }
                })
                .setNegativeButton(android.R.string.no, null)
                .setCancelable(false)
                .show();
        dialog.setOnDismissListener(this);
    }

    /**
     * 以系统API的方式请求浏览器
     *
     * @param url
     */
    public void goWeb(final String url) {
        Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
        try {
            startActivity(intent);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onDismiss(DialogInterface dialog) {
        finish();
    }
}
