//
//  IdEmailSignInViewController.m
//  TeslaId
//
//  Created by Neylor Bagagi on 10/20/15.
//  Copyright © 2015 Neylor Bagagi. All rights reserved.
//

#import "IdEmailSignInViewController.h"
#import "IdEmailSignUpViewController.h"

@interface IdEmailSignInViewController () <UITextFieldDelegate>
@property IdEmailSignUpViewController *idEmailSignUpView;
- (IBAction)cancelSignIn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *emailSignInTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordSignInTextField;
- (IBAction)signUp:(id)sender;
- (IBAction)forgotPassword:(id)sender;
@end

@implementation IdEmailSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	[_emailSignInTextField setDelegate:self];
	[_passwordSignInTextField setDelegate:self];
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	
	if (textField.tag == 1) {
		[_firebase authUser:_emailSignInTextField.text password:_passwordSignInTextField.text
		withCompletionBlock:^(NSError *error, FAuthData *authData) {
			if (error) {
				// There was an error logging in to this account
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign In Failed! : ["
																message:error.localizedDescription
															   delegate:nil
													  cancelButtonTitle:@"OK"
													  otherButtonTitles:nil];
				[alert show];
			} else {
				// We are now logged in
				NSLog(@"Successfully logged in! %@", authData);
				[self dismissViewControllerAnimated:YES completion:nil];
			}
		}];
	}else{
		NSInteger nextTag = textField.tag + 1;
		// Try to find next responder
		UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
		if (nextResponder) {
			// Found next responder, so set it.
			[nextResponder becomeFirstResponder];
		} else {
			// Not found, so remove keyboard.
			[textField resignFirstResponder];
		}
		return NO; // We do not want UITextField to insert line-breaks.
	}
	
	return YES;
}

- (IBAction)cancelSignIn:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)signUp:(id)sender {
	_idEmailSignUpView = [[IdEmailSignUpViewController alloc]init]; // instance IdEmailSignUpViewController
	[_idEmailSignUpView setFirebase:_firebase];						// Set Firebase instance to view
	[_idEmailSignUpView setModalInPopover:YES];						// Set presentation for PopUp style
	[self presentViewController:_idEmailSignUpView animated:YES completion:nil]; // present _idEmailSignUpView

}

- (IBAction)forgotPassword:(id)sender {
	[_firebase resetPasswordForUser:_emailSignInTextField.text withCompletionBlock:^(NSError *error) {
		if (error) {
			// There was an error processing the request
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry : ["
															message:error.localizedDescription
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
			[alert show];

		} else {
			// Password reset sent successfully
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"We Sent You An Email : ]"
															message:@"Use the temporary password we sent you within the next 24 hours to log in and update your account"
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
			[alert show];

		}
	}];
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
