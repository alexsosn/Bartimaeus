//
//  SomeClass.h
//  Bartimaeus
//
//  Created by Alex on 3/30/16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeepNeuralNetwork : NSObject

- (NSString *)recognizeImageOnPath:(NSString *) imagePath;
- (void)unloadNetwork;
- (void)loadNetwork;

@end
