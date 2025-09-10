package com.tggroup.flutter_bet;

import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;

import com.romain.hot.hotActivity;
import com.tiktok.TikTokBusinessSdk;

import java.util.ArrayList;
import java.util.List;

import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends hotActivity {

    private static final String CHANNEL = "flutter_plugin_tiktok"; // 替换为您的通道名称
    private static final String CHANNELZSTD = "zstd_flutter"; // zstd通道名称
    private MethodChannel methodChannel;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        initTTChannel();//创建toktik flutter 通信通道

        initZstd();//创建zstd解压

        //获取权限状态
        List<String> permissions = new ArrayList<>();
        String[] permission = new String[]{Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE};//WRITE_EXTERNAL_STORAGE   READ_PHONE_STATE
        for (String per : permission) {
            int permissionCode = ActivityCompat.checkSelfPermission(this, per);
            if (permissionCode != PackageManager.PERMISSION_GRANTED) {
                permissions.add(per);
            }
        }
        Log.e("MainActivity", "---权限"+permissions.toString());
        if (!permissions.isEmpty()) {
            Log.e("MainActivity", "无权限");
            ActivityCompat.requestPermissions(this, permissions.toArray(new String[0]), 0x12);
            Log.e("MainActivity", "无权限");
        }else {
            Log.e("MainActivity", "有权限");
            ((MainApplication)getApplication()).initso();
            Log.e("MainActivity", "有权限");
        }
    }

    private void initZstd() {
        final MethodChannel channel = new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNELZSTD);
        channel.setMethodCallHandler(new ZstdFlutterPlugin());
    }

    void initTTChannel() {
        if(methodChannel==null){
            methodChannel = new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL);
        }
        methodChannel.setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("androidMethodTiktok")) {
                        String name = call.argument("name");
                        TikTokBusinessSdk.trackEvent(name);
                        Object params = call.argument("params");
                        Log.e("获取渠道","---toktik 登录统计---name="+name+"---params="+params);
                    }
                    else {
                        result.notImplemented();
                    }
                }
        );
    }

}
