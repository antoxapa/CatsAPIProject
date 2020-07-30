//
//  CatModelTest.m
//  CatTestProjectTests
//
//  Created by Антон Потапчик on 7/30/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CatModel.h"

@interface CatModelTest : XCTestCase
@property (nonatomic, strong) NSDictionary *dataDictionary;
@property (nonatomic, strong) CatModel *item;
@end

@implementation CatModelTest

- (void)setUp {
    self.dataDictionary  = @{@"id":@"1",@"url":@"2"};
    self.item = [[CatModel alloc]initWithDictionary:self.dataDictionary];
}

- (void)tearDown {
    self.dataDictionary = nil;
    self.item = nil;
}

- (void)testInit {
    XCTAssertTrue([self.item.imageID  isEqual: @"1"]);
    XCTAssertTrue([self.item.url  isEqual: @"2"]);
}

@end
