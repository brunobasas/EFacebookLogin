//
//  EFacebookLogin.m
//  EFacebookLogin
//
//  Created by Bruno on 08/10/14.
//  Copyright (c) 2014 Bruno. All rights reserved.
//

#import "EFacebookLogin.h"


@interface EFacebookLogin()

+ (EFacebookLogin *)sharedManager;

@end



@implementation EFacebookLogin



#pragma mark -
#pragma mark - Singleton
+ (EFacebookLogin *)sharedManager
{
    static EFacebookLogin *scFacebook = nil;
    
    @synchronized (self){
        
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            scFacebook = [[EFacebookLogin alloc] init];
        });
    }
    
    return scFacebook;
}



#pragma mark -
#pragma mark - Private Methods


- (void)initWithPermissions:(NSArray *)permissions
{
    self.permissions = permissions;
}

- (void)loginCallBack:(EFacebookCallback)callBack
{
    [FBSession openActiveSessionWithReadPermissions:self.permissions allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        
        if (status == FBSessionStateOpen) {
            
            FBRequest *fbRequest = [FBRequest requestForMe];
            [fbRequest setSession:session];
            
            [fbRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error){
                NSMutableDictionary *userInfo = nil;
                if( [result isKindOfClass:[NSDictionary class]] ){
                    userInfo = (NSMutableDictionary *)result;
                    if( [userInfo count] > 0 ){
                        [userInfo setObject:session.accessTokenData.accessToken forKey:@"accessToken"];
                    }
                }
                if(callBack){
                    callBack(!error, userInfo);
                }
            }];
        }else if(status == FBSessionStateClosedLoginFailed){
            callBack(NO, @"Closed session state indicating that a login attempt failed");
        }
    }];
}

-(void)logoutCallBack:(EFacebookCallback)callBack{

    if (FBSession.activeSession.isOpen){
        [FBSession.activeSession closeAndClearTokenInformation];
        [FBSession setActiveSession:nil];
    }
    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* facebookCookies = [cookies cookiesForURL:[NSURL URLWithString:@"https://facebook.com/"]];
    
    for (NSHTTPCookie* cookie in facebookCookies) {
        [cookies deleteCookie:cookie];
    }
    
    callBack(YES, @"Logout successfully");
}

- (void)isSessionValidReturnToken:(EFacebookCallback)callBack
{
    if (!FBSession.activeSession.isOpen){
        
        if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded){
            [FBSession.activeSession openWithCompletionHandler:^(FBSession *session,
                                                                 FBSessionState status,
                                                                 
                                                                 NSError *error) {
                FBSession.activeSession = session;
                
            }];
        }
    }

    if (FBSession.activeSession.isOpen){
        if(callBack){
            callBack(YES, FBSession.activeSession.accessTokenData.accessToken);
        }
    }else{
        callBack(NO,nil);
        
    }
}

- (BOOL)isSessionValid
{
    if (!FBSession.activeSession.isOpen){
        
        if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded){
            [FBSession.activeSession openWithCompletionHandler:^(FBSession *session,
                                                                 FBSessionState status,
                                                                 NSError *error) {
                FBSession.activeSession = session;
            }];
        }
    }
    
    return FBSession.activeSession.isOpen;
}

-(void)requestPublishPermissions:(EFacebookCallback)callBack{
    
    if ([self isSessionValid]) {
        [FBSession.activeSession requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    if ([FBSession.activeSession.permissions
                                                         indexOfObject:@"publish_actions"] == NSNotFound){
                                                        callBack(NO, @"Permission not granted");
                                                    } else {
                                                        if(callBack){
                                                            callBack(YES,@"Granted");
                                                        }
                                                    }
                                                    
                                                } else {
                                                    callBack(NO, error);
                                                }
                                            }];
    }else{
        callBack(NO, @"Not logged in");
        return;
    }
    
}

-(void)checkForPublishPermissions:(EFacebookCallback)callBack{
    
    
    [FBSession.activeSession refreshPermissionsWithCompletionHandler:^(FBSession *session, NSError *error) {
        if (!error) {
            FBSession.activeSession = session;
            
            if ([session hasGranted:@"publish_actions"]) {
                if(callBack){
                    callBack(YES,@"Have permissions");
                }
            }else{
                callBack(NO, @"Don't have permissions");

            }

        }else{
            callBack(NO, error);
            
        }
    }];
    
}


#pragma mark -
#pragma mark - Public Methods

+ (void)loginCallBack:(EFacebookCallback)callBack{
    
    [[EFacebookLogin sharedManager] loginCallBack:callBack];
}

+ (void)logoutCallBack:(EFacebookCallback)callBack{
    
    [[EFacebookLogin sharedManager] logoutCallBack:callBack];
    
}

+ (void)initWithPermissions:(NSArray *)permissions{
    
    [[EFacebookLogin sharedManager] initWithPermissions:permissions];
}

+ (BOOL)isSessionValid{
    
    return [[EFacebookLogin sharedManager] isSessionValid];
}

+ (void)isSessionValidReturnToken:(EFacebookCallback)callBack{
    
    [[EFacebookLogin sharedManager] isSessionValidReturnToken:callBack];
}

+ (void)requestPublishPermissions:(EFacebookCallback)callBack{
    
    [[EFacebookLogin sharedManager] requestPublishPermissions:callBack];
    
}

+(void)checkForPublishPermissions:(EFacebookCallback)callBack{
    
    [[EFacebookLogin sharedManager] checkForPublishPermissions:callBack];
    
}

@end
