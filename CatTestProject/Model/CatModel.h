//
//  CatModel.h
//  CatTestProject
//
//  Created by Антон Потапчик on 7/24/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CatModel : NSObject

@property (nonatomic, copy) NSString *imageID;
@property (nonatomic, copy) NSString *url;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

