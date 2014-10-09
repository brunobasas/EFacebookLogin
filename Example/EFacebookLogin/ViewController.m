//
//  ViewController.m
//  EFacebookLogin
//
//  Created by Bruno on 09/10/14.
//  Copyright (c) 2014 Bruno. All rights reserved.
//

#import "ViewController.h"
#import "EFacebookLogin.h"
#define Alert(title,msg)  [[[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)LoginPressed:(id)sender {
    
    [EFacebookLogin initWithPermissions:@[@"user_about_me",
                                          @"email",]];
    
    [EFacebookLogin loginCallBack:^(BOOL success, id result) {
        if (success) {
            Alert(@"Alert", @"Success");
        }else{
            Alert(@"Alert", [result description]);
        }
    }];
}
- (IBAction)LogoutPressed:(id)sender {
    
    [EFacebookLogin logoutCallBack:^(BOOL success, id result) {
        if (success) {
            Alert(@"Alert", [result description]);
        }
    }];
    
}
- (IBAction)PublishPermissionsPressed:(id)sender {
    
    [EFacebookLogin checkForPublishPermissions:^(BOOL success, id result) {
        if (success) {
            
            Alert(@"Alert", @"Yoy already have permissions");

        }else{
            
            [EFacebookLogin requestPublishPermissions:^(BOOL success, id result) {
                if (success) {
                    Alert(@"Alert", @"Publish permissions granted");
                }else{
                    Alert(@"Alert", [result description]);
                }
            }];
        }
    }];
    


}

@end
