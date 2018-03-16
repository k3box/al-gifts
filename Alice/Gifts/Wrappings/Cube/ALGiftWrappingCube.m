//
//  ALGiftWrappingCube.m
//  Alice
//
//  Created by Vitaliy Karnienko on 16.03.2018.
//  Copyright © 2018 Vitaliy Karnienko. All rights reserved.
//

#import "ALGiftWrappingCube.h"

@implementation ALGiftWrappingCube

- (id)init
{
    self = [super init];
    if (self != nil) {
        SCNGeometry *geometry = [SCNBox boxWithWidth:1.f height:1.f length:1.f chamferRadius:0.f];
        self.geometry = geometry;
        SCNPhysicsShape *shape = [SCNPhysicsShape shapeWithGeometry:geometry options:@{}];
        self.physicsBody = [SCNPhysicsBody bodyWithType:SCNPhysicsBodyTypeDynamic shape:shape];
        [self.physicsBody setAffectedByGravity:YES];
        SCNMaterial *material = [SCNMaterial material];
        material.diffuse.contents = [UIImage imageNamed:@"valentineTexture"];
        self.geometry.materials = @[material, material, material, material, material, material];
    }
    return self;
}

@end
