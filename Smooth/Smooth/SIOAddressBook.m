//
//  SIOAddressBook.m
//  Smooth
//
//  Created by Neil Burchfield on 7/9/13.
//  Copyright (c) 2013 Smooth.IO. All rights reserved.
//

#import "SIOAddressBook.h"

@implementation SIOContact : NSObject
- (id)init { return self = [super init]; }
@end

@implementation SIOAddressBook

- (bool)canAccessAddressBook {
    
    __block bool success = NO;
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            success = YES;
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        success = YES;
    } 

    return success;
}

- (void)fetchAllAddressBookContacts:(void (^)(NSArray *results, NSError *error))completion
{
    if (![self canAccessAddressBook]) {
        completion(NO, [NSError errorWithDomain:@"com.io.smooth" code:123 userInfo:nil]);
    }
    
    NSMutableArray *container = [NSMutableArray array];
    
    CFErrorRef error = NULL;
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if (addressBook != nil)
    {        
        NSArray *allContacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
        
        NSUInteger i = 0;
        for (i = 0; i < [allContacts count]; i++)
        {
            SIOContact *person = [[SIOContact alloc] init];
            
            NSMutableDictionary *object = [NSMutableDictionary dictionary];

            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
            
            NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
            NSString *lastName =  (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];

            person.firstName = firstName;
            person.lastName = lastName;
            person.fullName = fullName;
            
            person.homeEmail = @"";
            person.workEmail = @"";

            ABMultiValueRef emails = ABRecordCopyValue(contactPerson, kABPersonEmailProperty);
            for (NSUInteger j = 0; j < ABMultiValueGetCount(emails); j++)
            {
                NSString *email = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emails, j);
                if (j == 0)
                    person.homeEmail = email;
                else if (j==1)
                    person.workEmail = email;
            }
            
            [object setObject:person.firstName forKey:@"firstName"];
            [object setObject:person.lastName forKey:@"lastName"];
            [object setObject:person.fullName forKey:@"name"];
            [object setObject:person.homeEmail forKey:@"homeEmail"];
            [object setObject:person.workEmail forKey:@"workEmail"];

            [container addObject:object];
        }
    }
    
    CFRelease(addressBook);
    
    completion([NSArray arrayWithArray:container], nil);
}

@end
