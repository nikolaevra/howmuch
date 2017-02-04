package me.snadeem.howmuch;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.widget.Button;
import android.widget.EditText;

import static me.snadeem.howmuch.R.id.amountEdit;

public class MainActivity extends AppCompatActivity {

    public static final String AMOUNT = "amount";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);


    }
}
