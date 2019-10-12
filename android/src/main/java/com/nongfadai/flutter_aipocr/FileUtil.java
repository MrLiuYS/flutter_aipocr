/*
 * Copyright (C) 2017 Baidu, Inc. All Rights Reserved.
 */
package com.nongfadai.flutter_aipocr;

import java.io.File;

import android.content.Context;
import android.os.Environment;

public class FileUtil {
    public static File getSaveFile(Context context,String imgName) {
//        File file = new File(context.getFilesDir(), imgName);

        File file = new File(FileUtil.getDiskDir(context,"image"), imgName);

        return file;
    }


    public static String getDiskDir(Context context, String dirName) {
        String filesPath = null;
        File file;
        if (isSDCardEnable()) {
            file = context.getExternalFilesDir((String)null);
            if (file != null) {
                filesPath = file.getPath();
            }
        }

        if (filesPath == null) {
            file = context.getFilesDir();
            if (file != null && file.exists()) {
                filesPath = file.getPath();
            }
        }

        if (dirName != null) {
            filesPath = filesPath + File.separator + dirName;
            file = new File(filesPath);
            if (!file.exists() && file.mkdirs()) {
            }
        }

        return filesPath;
    }

    public static boolean isSDCardEnable() {
        return "mounted".equals(Environment.getExternalStorageState());
    }

}
