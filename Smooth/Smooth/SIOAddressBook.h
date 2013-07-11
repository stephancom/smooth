//
//  SIOAddressBook.h
//  Smooth
//
//  Created by Neil Burchfield on 7/9/13.
//  Copyright (c) 2013 Smooth.IO. All rights reserved.
//

#import <AddressBook/AddressBook.h>

@interface SIOContact : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *homeEmail;
@property (nonatomic, strong) NSString *workEmail;

@end

@interface SIOAddressBook : NSObject
@property (nonatomic, retain) NSArray *data;
@property (nonatomic, strong) NSDictionary *payload;
- (bool)canAccessAddressBook;
- (void)fetchAllAddressBookContacts:(void (^)(NSArray *results, NSError *error))completion;
@end