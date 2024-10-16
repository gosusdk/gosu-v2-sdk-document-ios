//
//  SdkLanguage.m
//  GameSDK
//
//  Created by Nero-Macbook on 11/1/21.
//

#import <Foundation/Foundation.h>
#import "SdkLanguage.h"
#import "SdkConfig.h"

static SdkLanguage *sharedInstance;

@implementation SdkLanguage

#pragma mark Singleton Methods
+ (SdkLanguage *)sharedInstance
{
    @synchronized(self) {
        if(sharedInstance == nil) {
            sharedInstance = [[super alloc] init];
            sharedInstance.langCode = @"vi";
            NSString *lang = [SdkConfig sharedInstance].sdkLanguage;
            if(lang){
                sharedInstance.langCode = [lang lowercaseString];
            }
        }
    }
    return sharedInstance;
}

- (void) loadLangConfig {
    /*
    NSString *gamesdkLanguage = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"gamesdk_language.plist"];
     */
    NSBundle *GameSDKResource = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"SDKDataResource" withExtension:@"bundle"]];
    NSString *gamesdkLanguage = [[GameSDKResource bundlePath] stringByAppendingPathComponent:@"gamesdk_language.plist"];
    NSDictionary<NSString *, NSDictionary *> *infoDictionary = [NSDictionary dictionaryWithContentsOfFile:gamesdkLanguage];
    if(infoDictionary != nil) {
        _langData = infoDictionary;
    }
}

- (NSString *)translate:(NSString *)textCode
{
    NSDictionary *langDataWithTextCode = [_langData objectForKey:textCode];
    NSString *tranText = textCode;
    if(langDataWithTextCode && [langDataWithTextCode objectForKey:_langCode]) {
        tranText = [langDataWithTextCode objectForKey:_langCode];
    }
    return tranText;
}
- (NSString *)translateWithCode:(NSString *)textCode andCode:(int)code
{
    NSDictionary *langDataWithTextCode = [_langData objectForKey:textCode];
    NSString *tranText = textCode;
    if(langDataWithTextCode && [langDataWithTextCode objectForKey:_langCode]) {
        if([[langDataWithTextCode objectForKey:_langCode] isKindOfClass:[NSDictionary class]]){
            NSDictionary *tranGroup = [langDataWithTextCode objectForKey:_langCode];
            if([tranGroup objectForKey:[NSString stringWithFormat:@"%u", code]]){
                tranText = [tranGroup objectForKey:[NSString stringWithFormat:@"%u", code]];
            } else {
                tranText = [NSString stringWithFormat:@"%@(%u)",[langDataWithTextCode objectForKey:_langCode], code];
            }
        } else {
            tranText = [NSString stringWithFormat:@"%@(%u)",[langDataWithTextCode objectForKey:_langCode], code];
        }
    }
    return tranText;
}
@end

