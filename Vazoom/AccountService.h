//
//  AccountService.h
//  Vazoom
//
//  Created by Kien Do on 7/12/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PFUser;

typedef void(^CompletionBlock)(NSError *error);

@interface AccountService : NSObject
+(AccountService*)service;

-(void)loginWithUserName:(NSString *)userName password:(NSString *)password completionBlock:(CompletionBlock)compBlock;
@end
