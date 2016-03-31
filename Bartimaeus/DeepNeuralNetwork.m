//
//  SomeClass.m
//  Bartimaeus
//
//  Created by Alex on 3/30/16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import "DeepNeuralNetwork.h"
#import <DeepBelief/DeepBelief.h>

@interface DeepNeuralNetwork()

@property (nonatomic) void* network;

@end

@implementation DeepNeuralNetwork

- (NSString *)recognizeImageOnPath:(NSString *)imagePath {
    void *inputImage = jpcnn_create_image_buffer_from_file([imagePath UTF8String]);
    
    float *predictions;
    int predictionsLength;
    char **predictionsLabels;
    int predictionsLabelsLength;
    jpcnn_classify_image(self.network, inputImage, 0, 0, &predictions, &predictionsLength, &predictionsLabels, &predictionsLabelsLength);
    
    jpcnn_destroy_image_buffer(inputImage);
    
    float maxVal = 0.0;
    NSString *prediction = @"I don't know.";
    
    for (int index = 0; index < predictionsLength; index += 1) {
        const float predictionValue = predictions[index];
        if (maxVal>predictionValue || predictionValue < 0.05f) {
            continue;
        }
        char *label = predictionsLabels[index % predictionsLabelsLength];
        prediction = [NSString stringWithFormat: @"%s", label];
    }
    
    return prediction;
}

- (void)dealloc {
    jpcnn_destroy_network(self.network);
}

- (void)unloadNetwork {
    jpcnn_destroy_network(self.network);
}

- (void)loadNetwork {
    NSString* networkPath = [[NSBundle mainBundle] pathForResource:@"ccv2012" ofType:@"ntwk"];
    if (networkPath == NULL) {
        fprintf(stderr, "Couldn't find the neural network parameters file - did you add it as a resource to your application?\n");
        assert(false);
    }
    self.network = jpcnn_create_network([networkPath UTF8String]);
    assert(self.network != NULL);
}

@end
