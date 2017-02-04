package com.majesova.chatroom.models;

import com.google.firebase.database.Exclude;
import com.google.firebase.database.IgnoreExtraProperties;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

/**
 * Created by plenumsoft on 03/02/17.
 */

@IgnoreExtraProperties
public class Message {

    public String from;
    public String text;
    public String username;
    public String imageUrl="";

    public Message(){

    }


    public Message(String from, String text, String username, String imageUrl){
        this.from = from;
        this.text = text;
        this.username = username;
        this.imageUrl = imageUrl;
    }

    @Exclude
    public Map<String, Object> toMap() {

        HashMap<String,Object> result = new HashMap<>();
        result.put("from",from);
        result.put("text",text);
        result.put("username",username);
        result.put("imageUrl", imageUrl);
        return result;
    }

}
