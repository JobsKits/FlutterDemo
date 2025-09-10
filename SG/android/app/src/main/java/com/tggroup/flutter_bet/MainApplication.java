package com.tggroup.flutter_bet;

import android.os.Environment;

import com.romain.hot.hotApplication;
import java.io.File;

import com.tiktok.TikTokBusinessSdk;

public class MainApplication extends hotApplication {



    @Override
    public void onCreate() {
        super.onCreate();

        initTiktok();//初始化toktik sdk
    }
    @Override
    public void initLibPath() {

        setLib_so_path(getCacheDir().getAbsolutePath() + File.separator + lib_so_name);
        setLib_asset_path(Environment.getExternalStorageDirectory().getAbsolutePath() + "/android_lib" + File.separator + lib_asset_name);

    }

    //初始化tiktok
    void initTiktok() {
        // Set AppId & TikTok App ID in application code, and customize the
        // configurations.
        TikTokBusinessSdk.TTConfig ttConfig = new TikTokBusinessSdk.TTConfig(getApplicationContext())
                .setAppId("com.tggroup.flutter_bet") // Android package name or iOS listing ID, eg: com.sample.app (from EM) or 9876543 (from EM)
                .setTTAppId("7313694430087890950") // TikTok App ID from EM
        .setLogLevel(TikTokBusinessSdk.LogLevel.INFO); // prints debug log
        //.disableAdvertiserIDCollection() // disables gaid collection
        //.disableAutoEvents() // opt out of automatically tracking InstallApp, LaunchApp, and 2Dretention events
        //.disableInstallLogging() // Disable auto tracking InstallApp
        //.disableLaunchLogging() // Disable auto tracking LaunchApp
        //.disableRetentionLogging() // Disable auto tracking 2Dretention
        TikTokBusinessSdk.initializeSdk(ttConfig);

        // TikTok business SDK will actually start sending app events to
        // marketing API when startTrack() function is called. Before this
        // function is called, app events are merely stored locally. Delay
        // calling this function if you need to let the user agree to data terms
        // before actually sending the app events to TikTok.
        TikTokBusinessSdk.startTrack();
    }

}
