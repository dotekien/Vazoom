//
//  Payment.h
//  Vazoom
//
//  Created by Kien Do on 7/18/15.
//  Copyright (c) 2015 Vazoom. All rights reserved.
//

#import <Foundation/Foundation.h>
@class STPToken;
@class PFUser;

@interface Payment : NSObject
@property (strong, nonatomic) NSString *paymentMethodId;
@property (strong, nonatomic) NSString *nickName;
@property (nonatomic, strong) NSString *last4;
@property (nonatomic, strong) NSString *token;
@property (strong, nonatomic) PFUser *user;
@end
