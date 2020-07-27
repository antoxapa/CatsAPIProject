//
//  JSONParser.m
//  CatTestProject
//
//  Created by Антон Потапчик on 7/24/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "JSONParser.h"
#import "CatModel.h"

@implementation JSONParser

- (void)parseCats:(NSData *)data completion:(void (^)(NSMutableArray<CatModel *> *, NSError *))completion {
    NSError *error;
    NSArray *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error) {
        completion(nil, error);
        return;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dictionary) {
        [array addObject:dict];
    }
    NSMutableArray<CatModel *> *cats = [NSMutableArray new];
    for (NSDictionary *item in array) {
        [cats addObject:[[CatModel alloc] initWithDictionary:item]];
    }
    completion(cats, nil);
}

@end
