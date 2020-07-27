//
//  CatModel.m
//  CatTestProject
//
//  Created by Антон Потапчик on 7/24/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "CatModel.h"

@implementation CatModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _imageID = dictionary[@"id"];
        _url = dictionary[@"url"];
//        NSDictionary *breeds = dictionary[@"breeds"];
//        NSDictionary *categories = dictionary[@"categories"];
    }
    return self;
}

@end
