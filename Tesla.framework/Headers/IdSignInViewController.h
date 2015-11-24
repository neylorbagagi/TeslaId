//
//  IdSignInViewController.h
//  TeslaId
//
//  Created by Neylor Bagagi on 10/20/15.
//  Copyright © 2015 Neylor Bagagi. All rights reserved.
//

#import "Tesla.h"

@interface IdSignInViewController : UIViewController
	@property Firebase  *firebase;
	@property GIDSignIn *googleSignIn;
	@property NSString  *googleSignInClientId;
@end
