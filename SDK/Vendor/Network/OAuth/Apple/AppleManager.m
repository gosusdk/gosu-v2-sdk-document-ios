//
//  AppleManager.m
//  GameSDK
//
//  Created by Nero-Macbook on 11/8/21.
//

#import "AppleManager.h"
#import "GlobalVariable.h"
#import "AppleLoginResponse.h"
#import "SdkLanguage.h"

static AppleManager *sharedInstance;
@interface AppleManager()<ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>{
    
}

@end
@implementation AppleManager

#pragma mark Singleton Methods
+ (AppleManager *)sharedInstance
{
    @synchronized(self) {
        if(sharedInstance == nil)
            sharedInstance = [[super alloc] init];
    }
    return sharedInstance;
}

- (BOOL) showLoginView:(id<OpenIDDelegate>) openIDDelegate
{
    if (@available(iOS 13.0, *)) {
        //NSLog(@"AppleID1");
        ASAuthorizationAppleIDProvider *appleIDProvider = [ASAuthorizationAppleIDProvider new];
        ASAuthorizationAppleIDRequest  *request = appleIDProvider.createRequest;
        request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        //
        ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
        controller.delegate = self;
        controller.presentationContextProvider = self;
        [controller performRequests];
        self.openIDDelegate = openIDDelegate;
        return TRUE;
    } else {
        return FALSE;
    }
}
#pragma - mark ASAuthorizationControllerDelegate
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization NS_SWIFT_NAME(authorizationController(controller:didCompleteWithAuthorization:))
API_AVAILABLE(ios(13.0)){
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        //NSLog(@"AppleID3");
        ASAuthorizationAppleIDCredential *appleIDCredential = authorization.credential;
        NSString *user          = appleIDCredential.user;
        NSString *email         = appleIDCredential.email;
        //NSString *familyName    = appleIDCredential.fullName.familyName;
        //NSString *givenName     = appleIDCredential.fullName.givenName;
        /*
        */
        NSString *identityToken = [[NSString alloc] initWithData:appleIDCredential.identityToken encoding:NSUTF8StringEncoding];
        NSLog(@"identityToken = %@", identityToken);
        NSLog(@"email = %@", email);
        if(!email || [email isKindOfClass:[NSNull class]]){
            email = [NSString stringWithFormat:@"%@@apple", user];
        }
        
        if(!user || [user isKindOfClass:[NSNull class]]){
            /*
            if([_gameInfo.sdk_language isEqualToString:@"en"])
                [self showAlert:@"Warning!" andContent:@"Sorry, AppleID invalidate!"];
            else
                [self showAlert:@"Thông báo!" andContent:@"Tài khoản AppleID không hợp lệ!"];
            return;
             */
            
           if(self.openIDDelegate) {
               AppleLoginResponse *appleLogin = [[AppleLoginResponse alloc] init];
               appleLogin.status = @"authenticate-error";
               appleLogin.errorTitle = @"User Error";
               appleLogin.message = [[SdkLanguage sharedInstance] translate:@"t_account_041"];
               [self.openIDDelegate loginAppleFailed:appleLogin];
           } else {
               NSLog(@"Apple login user error");
           }
        } else {
           if(self.openIDDelegate) {
               AppleLoginResponse *appleLogin = [[AppleLoginResponse alloc] init];
               appleLogin.status = @"authenticate-success";
               appleLogin.userID = user;
               appleLogin.email = email;
               [self.openIDDelegate loginAppleSuccess:appleLogin];
           } else {
               NSLog(@"Apple login user success, but open id delegate does not exist");
           }
        }
    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        /*ASPasswordCredential *passwordCredential = authorization.credential;
        NSString *user = passwordCredential.user;
        NSString *password = passwordCredential.password;*/
    }
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error  NS_SWIFT_NAME(authorizationController(controller:didCompleteWithError:)) API_AVAILABLE(ios(13.0)){
    NSString *errorTitle = @"Error!";
    NSString *errorMsg = nil;
    
    errorMsg = error.description;
    if (error.localizedDescription) {
        errorMsg = error.localizedDescription;
    }
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorTitle = @"ASAuthorizationErrorCancelled";
            errorTitle = @"Login Cancelled";
            break;
        case ASAuthorizationErrorFailed:
            errorTitle = @"ASAuthorizationErrorFailed";
            errorTitle = @"Connect Failed";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorTitle = @"ASAuthorizationErrorInvalidResponse";
            errorTitle = @"ErrorInvalidResponse";
            [self.openIDDelegate loginAppleDisconnect];
            return;
        case ASAuthorizationErrorNotHandled:
            errorTitle = @"ASAuthorizationErrorNotHandled";
            errorTitle = @"NotHandled";
            [self.openIDDelegate loginAppleDisconnect];
            return;
        case ASAuthorizationErrorUnknown:
            errorTitle = @"ASAuthorizationErrorUnknown";
            errorTitle = @"Error Unknown";
            errorMsg = @"please check your internet connection and try again";
            [self.openIDDelegate loginAppleDisconnect];
            return;
    }
    if(self.openIDDelegate) {
        AppleLoginResponse *appleLogin = [[AppleLoginResponse alloc] init];
        appleLogin.status = @"authenticate-error";
        appleLogin.message = errorMsg;
        appleLogin.errorTitle = errorTitle;
        if (error.code != ASAuthorizationErrorCanceled) {
            [self.openIDDelegate loginAppleFailed:appleLogin];
        } else {
            [self.openIDDelegate loginAppleDisconnect];
        }
    } else {
        NSLog(@"Apple login error: %@ - %@",errorTitle, errorMsg);
    }
}

#pragma - mark ASAuthorizationControllerPresentationContextProviding
- (ASPresentationAnchor) presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)){
    return nil;
//    return self.view.window;
}
@end
