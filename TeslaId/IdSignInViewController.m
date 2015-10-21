//
//  IdSignInViewController.m
//  TeslaId
//
//  Created by Neylor Bagagi on 10/20/15.
//  Copyright © 2015 Neylor Bagagi. All rights reserved.
//

#import "IdSignInViewController.h"
#import "IdEmailSignInViewController.h"

@interface IdSignInViewController () <GIDSignInDelegate, GIDSignInUIDelegate>
@property IdEmailSignInViewController *idEmailSignInView;
@property FirebaseHandle *handle;
- (IBAction)emailSignIn:(id)sender;
- (IBAction)googleSignIn:(id)sender;
- (IBAction)facebookSignIn:(id)sender;
@end

@implementation IdSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	// Setup delegates
	GIDSignIn *googleSignIn = [GIDSignIn sharedInstance];
	[googleSignIn setDelegate:self];
	[googleSignIn setUiDelegate:self];
	
}

-(void)viewDidAppear:(BOOL)animated{

	if (_firebase.authData) {
		// user authenticated
		NSLog(@"IdSignInView says: %@", _firebase.authData);
		[self dismissViewControllerAnimated:NO completion:nil];
		
	} else {
		// No user is signed in
		NSLog(@"IdSignInView says: No user is signed in");
	}
	
}

- (IBAction)emailSignIn:(id)sender {
	_idEmailSignInView = [[IdEmailSignInViewController alloc]init]; // instance IdEmailSignInViewController
	[_idEmailSignInView setFirebase:_firebase];						// Set Firebase instance to view
	[_idEmailSignInView setModalInPopover:YES];						// Set presentation for PopUp style
	[self presentViewController:_idEmailSignInView animated:YES completion:nil]; // present _idEmailSignInView
}

// Google SignIn process
- (IBAction)googleSignIn:(id)sender {
	[[GIDSignIn sharedInstance] signIn];
}

- (IBAction)googleSignOut:(id)sender {
	[[GIDSignIn sharedInstance] signOut];
}

// Facebook SignIn process
- (IBAction)facebookSignIn:(id)sender {
	FBSDKLoginManager *facebookLogin = [[FBSDKLoginManager alloc] init];
	[facebookLogin logInWithReadPermissions:@[@"email"] fromViewController:self
									handler:^(FBSDKLoginManagerLoginResult *facebookResult, NSError *facebookError) {
										if (facebookError) {
											NSLog(@"Facebook login failed. Error: %@", facebookError);
											UIAlertView *alert = [[UIAlertView alloc] initWithTitle:facebookError.localizedDescription
																							message:facebookError.localizedRecoverySuggestion
																						   delegate:nil
																				  cancelButtonTitle:@"OK"
																				  otherButtonTitles:nil];
											[alert show];
										} else if (facebookResult.isCancelled) {
											NSLog(@"Facebook login got cancelled.");
										} else {
											NSString *accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
											[_firebase authWithOAuthProvider:@"facebook" token:accessToken
												   withCompletionBlock:^(NSError *error,FAuthData *authData) {
													   if (error) {
														   NSLog(@"Erros! %@", error);
														   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.localizedDescription
																										   message:error.localizedRecoverySuggestion
																										  delegate:nil
																								 cancelButtonTitle:@"OK"
																								 otherButtonTitles:nil];
														   [alert show];

													   } else {
														   NSLog(@"Facebook Logged");
														   
														   // Create a new user dictionary accessing the user's info
														   // provided by the authData parameter
														   NSDictionary *newUser = @{ @"provider": authData.provider,
																					  @"displayName": authData.providerData[@"displayName"],
																					  @"email": authData.providerData[@"email"],
																					  @"profileImage": authData.providerData[@"profileImageURL"],
																					  @"providerToken": authData.providerData[@"accessToken"],
																					  @"firebaseToken": authData.token};
														   
														   // Create a child path with a key set to the uid underneath the "users" node
														   // This creates a URL path like the following:
														   [[[_firebase childByAppendingPath:@"users"]childByAppendingPath:authData.uid] setValue:newUser];
														   
														   [self dismissViewControllerAnimated:YES completion:nil];

													   }
												   }];
										}
									}];

}

- (IBAction)facebookSignOut:(id)sender {
	FBSDKLoginManager *facebookLogin = [[FBSDKLoginManager alloc] init];
	[facebookLogin logOut];
	[_firebase unauth];
}


# pragma required GIDSignInDelegate methods
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
	if (error == nil) {
		[_firebase authWithOAuthProvider: @"google"
								   token:user.authentication.accessToken
					 withCompletionBlock:^(NSError *error, FAuthData *authData) {
						 if (error) {
							 // Error authenticating with Firebase with OAuth token
							 NSLog(@"Erros! %@", error);
							 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.localizedDescription
																			 message:error.localizedRecoverySuggestion
																			delegate:nil
																   cancelButtonTitle:@"OK"
																   otherButtonTitles:nil];
							 [alert show];
						 } else {
							 // User is now logged in!
							 NSLog(@"Successfully logged in! %@", authData);
							 
							 // Create a new user dictionary accessing the user's info
							 // provided by the authData parameter
							 NSDictionary *newUser = @{ @"provider": authData.provider,
														@"displayName": authData.providerData[@"displayName"],
														@"email": authData.providerData[@"email"],
														@"profileImage": authData.providerData[@"profileImageURL"],
														@"providerToken": authData.providerData[@"accessToken"],
														@"firebaseToken": authData.token};

							 // Create a child path with a key set to the uid underneath the "users" node
							 // This creates a URL path like the following:
							 [[[_firebase childByAppendingPath:@"users"]childByAppendingPath:authData.uid] setValue:newUser];
							 
							 [self dismissViewControllerAnimated:YES completion:nil];
						 }
					 }];
	}
}

// Unauth when disconnected from Google
- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
	[_firebase unauth];
}



- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
