//
//  JSONParser.h
//  CatTestProject
//
//  Created by Антон Потапчик on 7/24/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CatModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSONParser : NSObject
- (void)parseCats:(NSData *)data completion:(void (^)(NSArray<CatModel *> *, NSError *))completion;
@end

NS_ASSUME_NONNULL_END
