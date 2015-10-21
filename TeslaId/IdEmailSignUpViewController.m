//
//  IdEmailSignUpViewController.m
//  TeslaId
//
//  Created by Neylor Bagagi on 10/21/15.
//  Copyright © 2015 Neylor Bagagi. All rights reserved.
//

#import "IdEmailSignUpViewController.h"

@interface IdEmailSignUpViewController () <UITextFieldDelegate>
- (IBAction)cancelSignUp:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *emailSignUpTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordSignUpTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordRetypeSignUpTextField;

@end

@implementation IdEmailSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	[_emailSignUpTextField setDelegate:self];
	[_passwordSignUpTextField setDelegate:self];
	[_passwordRetypeSignUpTextField setDelegate:self];
}

- (IBAction)cancelSignUp:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	
	if (textField.tag == 2) {
		if ([_passwordRetypeSignUpTextField.text isEqualToString:_passwordSignUpTextField.text]) {
			[_firebase createUser:_emailSignUpTextField.text password:_passwordRetypeSignUpTextField.text
											 withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
										 if (error) {
											 // There was an error creating the account
											 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign Up Failed! : ["
																							 message:error.localizedDescription
																							delegate:nil
																				   cancelButtonTitle:@"OK"
																				   otherButtonTitles:nil];
											 [alert show];

										 } else {
											 NSString *uid = [result objectForKey:@"uid"];
											 NSLog(@"Successfully created user account with uid: %@",uid);
											 
											 [_firebase authUser:_emailSignUpTextField.text password:_passwordRetypeSignUpTextField.text
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
											 

										 }
									 }];
		}else{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign Up Failed! : ["
															message:@"The typed passwords don't match"
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
			[alert show];
		}
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
