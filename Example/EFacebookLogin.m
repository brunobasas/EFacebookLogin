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




#pragma mark -
#pragma mark - Public Methods

+ (void)loginCallBack:(EFacebookCallback)callBack
{
    [[EFacebookLogin sharedManager] loginCallBack:callBack];
}

+ (void)initWithPermissions:(NSArray *)permissions;
{
    [[EFacebookLogin sharedManager] initWithPermissions:permissions];
}

@end
