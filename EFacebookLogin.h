//
//  EFacebookLogin.h
//  EFacebookLogin
//
//  Created by Bruno on 08/10/14.
//  Copyright (c) 2014 Bruno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FacebookSDK.h"




typedef void(^EFacebookCallback)(BOOL success, id result);

@interface EFacebookLogin : NSObject{

}


@property (strong, nonatomic) FBSession *session;
@property (strong, nonatomic) NSArray *permissions;


/**
 *  Facebook login
 *
 * https://developers.facebook.com/docs/ios/graph
 *
 *  @param callBack (BOOL success, id result)
 */
+ (void)loginCallBack:(EFacebookCallback)callBack;


+ (void)initWithPermissions:(NSArray *)permissions;


@end
