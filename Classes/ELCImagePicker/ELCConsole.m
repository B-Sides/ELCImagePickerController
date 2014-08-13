//
//  ELCConsole.m
//  ELCImagePickerDemo
//
//  Created by Seamus on 14-7-11.
//  Copyright (c) 2014年 ELC Technologies. All rights reserved.
//

#import "ELCConsole.h"

static ELCConsole *_maniconsole;

@implementation ELCConsole
+ (ELCConsole *)mainConsole
{
    if (!_maniconsole) {
        _maniconsole = [[ELCConsole alloc] init];
    }
    return _maniconsole;
}

- (id)init
{
    self = [super init];
    if (self) {
        myIndex = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    myIndex = nil;
    _maniconsole = nil;
}

- (void)addIndex:(int)index
{
    if (![myIndex containsObject:@(index)]) {
        [myIndex addObject:@(index)];
    }
}

- (void)removeIndex:(int)index
{
    [myIndex removeObject:@(index)];
}

- (void)removeAllIndex
{
    [myIndex removeAllObjects];
}

- (int)currIndex
{
    [myIndex sortUsingSelector:@selector(compare:)];
    
    for (int i = 0; i < [myIndex count]; i++) {
        int c = [[myIndex objectAtIndex:i] intValue];
        if (c != i) {
            return i;
        }
    }
    return (int)[myIndex count];
}

@end
