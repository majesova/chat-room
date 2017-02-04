package com.majesova.chatroom.models;

import com.google.firebase.database.IgnoreExtraProperties;

/**
 * Created by plenumsoft on 03/02/17.
 */


    @IgnoreExtraProperties
    public class User {
        public String uid;
        public String username;
        public String email;

        public User() {
            // Default constructor required for calls to DataSnapshot.getValue(User.class)
        }

        public User(String uid, String username, String email) {
            this.username = username;
            this.email = email;
            this.uid = uid;
        }

    }
