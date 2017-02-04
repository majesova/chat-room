package com.majesova.chatroom.presentation;

import com.google.firebase.auth.FirebaseUser;

/**
 * Created by plenumsoft on 03/02/17.
 */

public interface ICommandLoginRequest {
    void executeSuccess(FirebaseUser user);
    void executeError(String error);
}
