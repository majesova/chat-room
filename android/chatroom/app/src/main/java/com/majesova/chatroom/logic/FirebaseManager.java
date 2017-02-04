package com.majesova.chatroom.logic;

/**
 * Created by plenumsoft on 02/02/17.
 */

import android.support.annotation.NonNull;
import android.util.Log;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.ChildEventListener;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.majesova.chatroom.models.Message;
import com.majesova.chatroom.models.User;
import com.majesova.chatroom.presentation.ICommandLoginRequest;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class FirebaseManager {


    public static DatabaseReference databaseRef = FirebaseDatabase.getInstance().getReference();
    public static FirebaseUser currentUser;
    public static String currentUserId = null;
    public static FirebaseAuth auth = FirebaseAuth.getInstance();

    public static List<User> Users;

   public static void AddUser(String username, String email){

        String uid = auth.getCurrentUser().getUid();
        User user = new User(uid,username,email);
        databaseRef.child("users").child(uid).setValue(user);
    }


    public static void AddMessage(String from, String text, String username, String imageUrl){
        //https://chat-room-c9d8c.firebaseio.com/

        String key = databaseRef.child("messages").push().getKey();
        Message message = new Message(from, text, username,imageUrl);
        Map<String, Object> values = message.toMap();

        DatabaseReference mypostref = databaseRef.push();
        mypostref.child("messages").setValue(message);
        Map<String, Object> childUpdates = new HashMap<>();
        childUpdates.put("/messages/" + key, values);

        databaseRef.updateChildren(childUpdates);
    }


    public static void Login (String email, String password, final ICommandLoginRequest commandRequest){

        auth.signInWithEmailAndPassword(email, password).addOnCompleteListener(new OnCompleteListener<AuthResult>() {
            @Override
            public void onComplete(@NonNull Task<AuthResult> task) {

                if (!task.isSuccessful()){

                    commandRequest.executeError(task.getException().getMessage());

                }else {
                    commandRequest.executeSuccess(auth.getCurrentUser());
                }
            }
        });
    }

    public static  void CreateAccount(final String username, final String email, final String password, final ICommandLoginRequest commandRequest){

        auth.createUserWithEmailAndPassword(email, password).addOnCompleteListener(new OnCompleteListener<AuthResult>() {
            @Override
            public void onComplete(@NonNull Task<AuthResult> task) {

                if( !task.isSuccessful()){
                    commandRequest.executeError(task.getException().getMessage());
                }else{
                    AddUser(username,email);
                    Login(email, password, commandRequest);
                }
            }
        });
    }


    public static void SyncUsers(){

            Users = new ArrayList<>();
            databaseRef.child("users").addChildEventListener(new ChildEventListener() {
            @Override
            public void onChildAdded(DataSnapshot dataSnapshot, String s) {
                User user = dataSnapshot.getValue(User.class);
                Users.add(user);
            }

            @Override
            public void onChildChanged(DataSnapshot dataSnapshot, String s) {

            }

            @Override
            public void onChildRemoved(DataSnapshot dataSnapshot) {

            }

            @Override
            public void onChildMoved(DataSnapshot dataSnapshot, String s) {

            }

            @Override
            public void onCancelled(DatabaseError databaseError) {

            }
        });

    }

    public static String CurrentUserName() {

        String username = "No name";
        for ( int i=0; i< Users.size(); i++){
            if ( currentUserId.compareTo(Users.get(i).uid )==0 ){
                    username = Users.get(i).username;
            }
        }
        return username;

    }

}
