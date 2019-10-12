# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in D:\Program Files\Android\sdk/tools/proguard/proguard-android.txt
# You can edit the include path and order by changing the proguardFiles
# directive in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# Add any project specific keep options here:

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}
-dontwarn    android.content.res.AssetManager
-dontwarn    android.content.pm.PackageParser
-dontwarn    android.content.pm.PackageParser$Package
-dontwarn    android.R$styleable

-keepclasseswithmembers  class  com.baidu.techain.jni.Asc{*;}
-keep    class    com.baidu.techain.ac.Callback{*;}
-keep    class    com.baidu.techain.ac.FI{*;}
-keepclasseswithmembers  class  com.baidu.sofire.push.TechainPushConnService{*;}
-keepclasseswithmembers  class  com.baidu.techain.ac.F{*;}
-keep    class    com.baidu.techain.ac.TH    {*;}
-keep    class    com.baidu.techain.ac.U    {*;}
-keep    class    com.baidu.techain.core.ApkInfo{*;}
-keep    class    com.baidu.techain.rp.Report    {
<methods>;
}