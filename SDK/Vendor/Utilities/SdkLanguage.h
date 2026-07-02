//
//  SdkLanguage.h
//  GameSDK
//
//  Created by Nero-Macbook on 11/1/21.
//

@interface SdkLanguage : NSObject {
    
}
@property (nonatomic, strong) NSDictionary<NSString *, NSDictionary *> *langData;
@property (nonatomic, strong) NSString *langCode;

+ (SdkLanguage *) sharedInstance;
- (void) loadLangConfig;
- (NSString *)translate:(NSString *)textCode;
- (NSString *)translateWithCode:(NSString *)textCode andCode:(int)code;
- (NSString *)getCurentLangCode;
- (BOOL)hasKey:(NSString *)key;

@end
