package com.nongfadai.flutter_aipocr;

import android.app.Dialog;
import android.content.Context;


/**
 * 自定义进度对话框
 * Created by cy on 2019/6/21.
 */
public class SubmitDialog extends Dialog {


    private Context context;


    /**
     * 构造函数
     *
     * @param context {@link Context}
     */
    public SubmitDialog(Context context) {
        super(context, R.style.CustomDialog);
        this.context = context;
        initView();
    }


    private void initView() {
        setContentView(R.layout.dialog_submit);
        setCancelable(false);
    }

}
