//
//  AccountService.m
//  Vazoom
//
//  Created by Kien Do on 7/12/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import "AccountService.h"
#import <PFUser.h>

@interface AccountService ()
@property (strong, nonatomic) PFUser *account;
@end

@implementation AccountService
+(AccountService*)service
{
    static AccountService *accountService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        accountService = [[self alloc] init];
    });
    return accountService;
}

-(void)loginWithUserName:(NSString *)userName password:(NSString *)password completionBlock:(CompletionBlock)compBlock
{
    [PFUser logInWithUsernameInBackground:userName password:password
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            //self.account = user;
                                        } else {
                                            
                                        }
                                        compBlock(error);
                                    }];
}
@end
