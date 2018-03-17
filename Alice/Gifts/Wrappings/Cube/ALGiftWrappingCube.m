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
//        SCNGeometry *geometry = [SCNBox boxWithWidth:1.f height:1.f length:1.f chamferRadius:0.f];
        SCNGeometry *geometry = [SCNBox boxWithWidth:.01f height:.1f length:.1f chamferRadius:0.f];
        self.geometry = geometry;
        SCNPhysicsShape *shape = [SCNPhysicsShape shapeWithGeometry:geometry options:@{}];
        self.physicsBody = [SCNPhysicsBody bodyWithType:SCNPhysicsBodyTypeDynamic shape:shape];
        [self.physicsBody setAffectedByGravity:NO];
        SCNMaterial *materialA = [SCNMaterial material];
        materialA.diffuse.contents = [UIImage imageNamed:@"A"];
        SCNMaterial *materialB = [SCNMaterial material];
        materialB.diffuse.contents = [UIImage imageNamed:@"B"];
//        material.diffuse.contents = [UIImage imageNamed:@"cherries"];
        
        
        
        
        SCNMaterial *material2 = [SCNMaterial material];
        material2.diffuse.contents = [UIImage imageNamed:@"___"];

        [self makeGlass:materialA];
        [self makeGlass:materialB];
        [self makeGlass:material2];

        
        self.geometry.materials = @[material2, materialB, material2, material2, material2, material2];
//        self.geometry.materials = @[material2, materialB, material2, materialA, material2, material2];

    }
    return self;
}

- (void)makeGlass:(SCNMaterial *)material
{
    material.lightingModelName = SCNLightingModelBlinn;
    
    material.transparencyMode = SCNTransparencyModeDualLayer;
    
    material.fresnelExponent = 1.5;
    
    material.doubleSided = YES;
    
    material.specular.contents = [UIColor colorWithWhite:0.6 alpha:1.f];
    
    material.shininess = 62.5;
}

@end
