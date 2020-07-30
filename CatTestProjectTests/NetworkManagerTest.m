//
//  NetworkManagerTest.m
//  CatTestProjectTests
//
//  Created by Антон Потапчик on 7/30/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NetworkManager.h"
#import "JSONParser.h"
#import "RLURLSessionMock.h"

@interface NetworkManagerTest : XCTestCase

@property (nonatomic, strong) NetworkManager *networkManager;
@property (nonatomic, strong) JSONParser *parser;

@property (nonatomic, strong) RLURLSessionMock *mockSession;

@end

@implementation NetworkManagerTest

- (void)setUp {
    _parser = [[JSONParser alloc]init];
    _networkManager = [[NetworkManager alloc]initWithParser:_parser];
    _mockSession = [[RLURLSessionMock alloc]init];
}

- (void)tearDown {
    _networkManager = nil;
}

- (void)testLoadCats {
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Mock_JSON" ofType:nil];
    NSData *mockData = [[NSData alloc]initWithContentsOfFile:filePath];
    self.mockSession.data = mockData;
    self.networkManager.session = self.mockSession;
    [self.networkManager loadCats:filePath completion:^(NSData *data, NSError *error) {
        XCTAssertEqual(mockData, data);
    }];
}

- (void)testParsing {
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Mock_JSON" ofType:nil];
    NSData *mockData = [[NSData alloc]initWithContentsOfFile:filePath];
    self.mockSession.data = mockData;
    self.networkManager.session = self.mockSession;
    
    [self.networkManager parseData:^(NSMutableArray<CatModel *> * array, NSError * error) {
        XCTAssertTrue(array.count == 2);
    }];
}

- (void)testLoadingImage {
    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"cat"]);
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"cat.png" ofType:nil];
    [self.networkManager loadImageForURL:filePath completion:^(NSData * data, NSURLResponse *response, NSError *error) {
        XCTAssertEqual(imageData, data);
    }];
}

- (void)testGetFromCacheImage {
    UIImage *cachedImage = [UIImage imageNamed:@"icon"];
    [self.networkManager.cache setObject:cachedImage forKey:@"URL"];
    [self.networkManager getCachedImageWithURL:@"URL" completion:^(NSString *string, UIImage *image, NSError *error) {
        XCTAssertEqual(cachedImage, image);
        XCTAssertEqual(@"URL", string);
    }];
}

- (void)testLoadCacheImage {
    UIImage *cat = [UIImage imageNamed:@"cat"];
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"cat.png" ofType:nil];
    [self.networkManager getCachedImageWithURL:filePath completion:^(NSString *string, UIImage *image, NSError *error) {
        XCTAssertEqual(cat, image);
    }];
}

- (void)testUploadImage {
    
}


@end
