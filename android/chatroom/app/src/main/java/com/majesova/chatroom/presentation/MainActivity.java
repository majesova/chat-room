package com.majesova.chatroom.presentation;

import android.content.Context;
import android.content.Intent;
import android.support.annotation.NonNull;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;

import com.google.firebase.auth.FirebaseUser;
import com.majesova.chatroom.R;
import com.majesova.chatroom.logic.FirebaseManager;

public class MainActivity extends AppCompatActivity {

    private EditText txtUsername, txtPassword, txtEmail;
    private Button btnRegistrarse, btnEntrar;
    private FirebaseAuth auth;

    private class MyFocusChangeListener implements View.OnFocusChangeListener {

        public void onFocusChange(View v, boolean hasFocus){

            if(!hasFocus) {

                InputMethodManager imm =  (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
                imm.hideSoftInputFromWindow(v.getWindowToken(), 0);

            }
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        auth = FirebaseAuth.getInstance();

        FirebaseManager.SyncUsers();

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        txtUsername =(EditText)findViewById(R.id.login_username);
        txtPassword = (EditText)findViewById(R.id.login_password);
        txtEmail = (EditText)findViewById(R.id.login_email);
        btnEntrar = (Button)findViewById(R.id.login_ingresar);
        btnRegistrarse = (Button)findViewById(R.id.login_registrarse);

        View.OnFocusChangeListener ofcListener = new MyFocusChangeListener();
        txtEmail.setOnFocusChangeListener(ofcListener);
        txtPassword.setOnFocusChangeListener(ofcListener);
        txtUsername.setOnFocusChangeListener(ofcListener);


        btnEntrar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                Log.e("MYLOG","Entrando");
                String email = txtEmail.getText().toString().trim();
                String password = txtPassword.getText().toString().trim();

                if (TextUtils.isEmpty(email)) {
                    Toast.makeText(getApplicationContext(), "Enter email address!", Toast.LENGTH_SHORT).show();
                    return;
                }

                if (TextUtils.isEmpty(password)) {
                    Toast.makeText(getApplicationContext(), "Enter password!", Toast.LENGTH_SHORT).show();
                    return;
                }

               FirebaseManager.Login(email, password, new ICommandLoginRequest() {
                   @Override
                   public void executeSuccess(FirebaseUser user) {
                       FirebaseManager.currentUser = user;
                       FirebaseManager.currentUserId = user.getUid();
                       Intent intent = new Intent(MainActivity.this, MessagesActivity.class);
                       startActivity(intent);
                   }

                   @Override
                   public void executeError(String error) {
                       Toast.makeText(MainActivity.this, "Authentication failed." + error,
                               Toast.LENGTH_SHORT).show();
                   }
               });

            }
        });


        btnRegistrarse.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                final String email = txtEmail.getText().toString().trim();
                final String password = txtPassword.getText().toString().trim();
                final String username = txtUsername.getText().toString().trim();

                if (TextUtils.isEmpty(email)) {
                    Toast.makeText(getApplicationContext(), "Enter email address!", Toast.LENGTH_SHORT).show();
                    return;
                }

                if (TextUtils.isEmpty(password)) {
                    Toast.makeText(getApplicationContext(), "Enter password!", Toast.LENGTH_SHORT).show();
                    return;
                }

                if (TextUtils.isEmpty(username)) {
                    Toast.makeText(getApplicationContext(), "Enter username!", Toast.LENGTH_SHORT).show();
                    return;
                }

                FirebaseManager.CreateAccount(username, email, password, new ICommandLoginRequest() {
                    @Override
                    public void executeSuccess(FirebaseUser user) {
                        FirebaseManager.currentUser = user;
                        FirebaseManager.currentUserId = user.getUid();
                        Intent intent = new Intent(MainActivity.this, MessagesActivity.class);
                        startActivity(intent);
                    }

                    @Override
                    public void executeError(String error) {
                        Toast.makeText(MainActivity.this, "Authentication failed." + error,
                                Toast.LENGTH_SHORT).show();
                    }
                });


            }
        });


    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        InputMethodManager imm = (InputMethodManager)getSystemService(Context.
                INPUT_METHOD_SERVICE);
        imm.hideSoftInputFromWindow(getCurrentFocus().getWindowToken(), 0);
        return true;
    }


}
