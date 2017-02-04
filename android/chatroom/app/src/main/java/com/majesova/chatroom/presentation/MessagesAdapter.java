package com.majesova.chatroom.presentation;

import android.content.Context;
import android.os.Message;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.majesova.chatroom.R;
import com.squareup.picasso.Picasso;

import java.util.List;

/**
 * Created by plenumsoft on 03/02/17.
 */

public class MessagesAdapter extends RecyclerView.Adapter<MessagesAdapter.ViewHolder> {

    private static final int TEXT_MESS = 1;
    private static final int IMAGE_MESS = 2;

    private List<com.majesova.chatroom.models.Message> messageList;

    public  class ViewHolder extends RecyclerView.ViewHolder {
        // each data item is just a string in this case
        View v;
        Context context;
        public TextView usernameText;
        public TextView messageText;
        public ImageView imageView;

        public void setText(String text){
            messageText = (TextView) v.findViewById(R.id.messagecell_text);
            messageText.setText(text);
        }
        public void setUserName(String text){
            messageText.setText(text);
        }

        public void setImage(String url){
            imageView = (ImageView)v.findViewById(R.id.messagecell_imagen);
            Picasso.with(context).load(url).into(imageView);
        }

        public ViewHolder(View v) {
            super(v);
            this.v = v;
            usernameText = (TextView) v.findViewById(R.id.messagecell_username);
        }

        public ViewHolder(View v, Context context) {
            super(v);
            this.v = v;
            this.context = context;
            usernameText = (TextView) v.findViewById(R.id.messagecell_username);
        }
    }

    public MessagesAdapter(List<com.majesova.chatroom.models.Message> messagesList){
        this.messageList = messagesList;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View v;

        if (viewType == TEXT_MESS){
            v = LayoutInflater.from(parent.getContext()).inflate(R.layout.message_cell, parent, false);

        }else{
            v = LayoutInflater.from(parent.getContext()).inflate(R.layout.message_cell_image, parent, false);
        }

        ViewHolder vh = new ViewHolder(v, parent.getContext());

        return vh;
    }

    @Override
    public int getItemCount() {
        return messageList.size();
    }

    @Override
    public int getItemViewType(int position) {
        com.majesova.chatroom.models.Message message = messageList.get(position);
        if (message.imageUrl.compareTo("")==0)  {
            return TEXT_MESS;
        }else{
        return IMAGE_MESS;
        }
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        com.majesova.chatroom.models.Message message = messageList.get(position);

        holder.usernameText.setText(message.username);
        //holder.setText(message.text);
        Log.e("MYLOG","Tratando de bindear: "+ message.imageUrl);
        if(message.imageUrl.compareTo("")==0)
            holder.setText(message.text);
        else
            holder.setImage(message.imageUrl);


    }
}
