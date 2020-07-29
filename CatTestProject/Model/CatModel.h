//
//  CatModel.h
//  CatTestProject
//
//  Created by Антон Потапчик on 7/24/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CatModel : NSObject

@property (nonatomic, strong) NSString *imageID;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *apiKey;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

