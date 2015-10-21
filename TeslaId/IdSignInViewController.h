//
//  IdSignInViewController.h
//  TeslaId
//
//  Created by Neylor Bagagi on 10/20/15.
//  Copyright © 2015 Neylor Bagagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
#import <Firebase/Firebase.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface IdSignInViewController : UIViewController
	@property Firebase *firebase;
@end
