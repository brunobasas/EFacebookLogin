//
//  EFacebookLogin.h
//  EFacebookLogin
//
//  Created by Bruno on 08/10/14.
//  Copyright (c) 2014 Bruno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>




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
/**
 *  Facebook logout
 *
 * https://developers.facebook.com/docs/ios/graph
 *
 *  @param callBack (BOOL success, id result)
 */
+ (void)logoutCallBack:(EFacebookCallback)callBack;
/**
 *  Checks if there is an open session, if it is not checked if a token is created and returned there to validate session.
 *
 *  @param callBack (BOOL success, id result)
 */
+ (void)isSessionValidReturnToken:(EFacebookCallback)callBack;

+ (BOOL)isSessionValid;

+ (void)initWithPermissions:(NSArray *)permissions;

/**
 *  Request publish permisions
 *
 *  @param callBack (BOOL success, id result)
 */
+ (void)requestPublishPermissions:(EFacebookCallback)callBack;

/**
 *  Check for publish permisions
 *
 *  @param callBack (BOOL success, id result)
 */
+(void)checkForPublishPermissions:(EFacebookCallback)callBack;



@end
