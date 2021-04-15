//
//  MyOperation.m
//  NSOperationNote
//
//  Created by chenyehong on 2021/4/15.
//

#import "MyOperation.h"

@implementation MyOperation

- (void)main {
    if (!self.isCancelled) {
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@", [NSThread currentThread]);
        }
    }
}

@end
