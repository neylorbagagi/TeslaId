//
//  ViewController.m
//  TeslaId
//
//  Created by Neylor Bagagi on 10/13/15.
//  Copyright (c) 2015 Neylor Bagagi. All rights reserved.
//

#import "ViewController.h"
#import <Firebase/Firebase.h>
#import "IdSignInViewController.h"

@interface ViewController ()
	@property IdSignInViewController *idSignInView;
	@property Firebase *firebase;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
	
	
	// settup
	_firebase = [[Firebase alloc] initWithUrl:@"https://teslaid.firebaseio.com"];
	[_firebase unauth];
	
	[[GIDSignIn sharedInstance] signOut];
    
    

	//FBSDKLoginManager *facebookLogin = [[FBSDKLoginManager alloc] init];
	//[facebookLogin logOut];

}

- (void)viewDidAppear:(BOOL)animated{
	
	if (_firebase.authData) {
		NSLog(@"Root View Says: %@",_firebase.authData);
		//[self performSegueWithIdentifier:@"YOUR-SEGUE" sender:self]; // Perform segue to app home
	}else{
		_idSignInView = [[IdSignInViewController alloc]init]; // instance IdSignInViewControllet
		[_idSignInView setFirebase:_firebase];				  // Set Firebase instance to view
		[_idSignInView setModalInPopover:YES];				  // Set presentation for PopUp style
		[self presentViewController:_idSignInView animated:YES completion:nil]; // present _idSignInView
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
