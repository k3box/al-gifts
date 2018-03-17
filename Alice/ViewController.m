//
//  ViewController.m
//  Alice
//
//  Created by Vitaliy Karnienko on 16.03.2018.
//  Copyright © 2018 Vitaliy Karnienko. All rights reserved.
//

#import "ViewController.h"
#import "ALGiftWrappingCube.h"

@interface ViewController () <ARSCNViewDelegate>

@property (nonatomic, strong) IBOutlet ARSCNView *sceneView;

@end

    
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    rec.numberOfTapsRequired = 1;
    [self.sceneView addGestureRecognizer:rec];
    
    // Set the view's delegate
    self.sceneView.delegate = self;
    
    // Show statistics such as fps and timing information
    self.sceneView.showsStatistics = YES;
//    self.sceneView.debugOptions = ARSCNDebugOptionShowFeaturePoints;
    
    self.sceneView.autoenablesDefaultLighting = YES;

    // Create a new scene
    SCNScene *scene = [SCNScene scene];
    
    // Set the scene to the view
    self.sceneView.scene = scene;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Create a session configuration
    ARWorldTrackingConfiguration *configuration = [ARWorldTrackingConfiguration new];
    configuration.planeDetection = ARPlaneDetectionHorizontal;
//    self.sceneView.automaticallyUpdatesLighting = YES;

    // Run the view's session
    [self.sceneView.session runWithConfiguration:configuration];
    
//    [self addGiftWrappingCube];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Pause the view's session
    [self.sceneView.session pause];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - ARSCNViewDelegate

//- (void)renderer:(id<SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
//{
//    [self addGiftWrappingCube];
////    [self.sceneView pause:self];
////    self.sceneView.backgroundColor = [UIColor yellowColor];
////    [NSThread sleepForTimeInterval:.5];
////    self.sceneView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.f];
////    [self.sceneView play:self];
//}
//
//// Override to create and configure nodes for anchors added to the view's session.
//- (SCNNode *)renderer:(id<SCNSceneRenderer>)renderer nodeForAnchor:(ARAnchor *)anchor {
//    SCNNode *cube = [ALGiftWrappingCube new];
//    SCNVector3 position = self.sceneView.pointOfView.position;
//    position.z -= 0.5f;
//    cube.position = position;
//
//    // Add geometry to the node...
//
//    return cube;
//}


- (void)session:(ARSession *)session didFailWithError:(NSError *)error {
    // Present an error message to the user
    
}

- (void)sessionWasInterrupted:(ARSession *)session {
    // Inform the user that the session has been interrupted, for example, by presenting an overlay
    
}

- (void)sessionInterruptionEnded:(ARSession *)session {
    // Reset tracking and/or remove existing anchors if consistent tracking is required
    
}

#pragma mark private functions

- (void)addGiftWrappingCube
{
    ALGiftWrappingCube *cube = [[ALGiftWrappingCube alloc] init];
//    SCNQuaternion orientation = self.sceneView.pointOfView.worldOrientation;
//    SCNVector3 position = SCNVector3Make(orientation.x, orientation.y, orientation.z - .5f);
//    cube.worldPosition = position;

    [self setInFrontOfCameraTransformForNode:cube];

    [self.sceneView.scene.rootNode addChildNode:cube];
}

- (void)tap
{
//    [self addGiftWrappingCube];
    [self addDAECube];
    [self addParticleSystem];
}

- (simd_float4x4)rotateMatrix:(simd_float4x4)tr byAngle:(float)angle onAxis:(NSString *)axis
{
    simd_float4x4 translation = tr;
    if ([axis isEqualToString:@"x"]) {
        translation.columns[0].x += 1;
        translation.columns[1].y += cosf(angle);
        translation.columns[2].y += -sinf(angle);
        translation.columns[1].z += sinf(angle);
        translation.columns[2].z += cosf(angle);
    }
    if ([axis isEqualToString:@"y"]) {
        translation.columns[0].x += cosf(-angle);
        translation.columns[2].x += -sinf(-angle);
        translation.columns[1].y += 1;
        translation.columns[0].z += sinf(-angle);
        translation.columns[2].z += cosf(-angle);
    }
    if ([axis isEqualToString:@"z"]) {
        translation.columns[0].x += cosf(angle);
        translation.columns[1].x += -sinf(angle);
        translation.columns[0].y += sinf(angle);
        translation.columns[1].y += cosf(angle);
        translation.columns[2].z += 1;
//        translation.columns[0].x += cosf(angle);
//        translation.columns[0].y += -sinf(angle);
//        translation.columns[1].x += sinf(angle);
//        translation.columns[1].y += cosf(angle);

    }
    return translation;
}

- (simd_float4x4)matrixWithDepth:(CGFloat)depth
{
    simd_float4x4 translation = matrix_identity_float4x4;
    simd_float4x4 cameraTransform = self.sceneView.session.currentFrame.camera.transform;
    translation.columns[3].z = depth;
    return matrix_multiply(cameraTransform, translation);
}

- (void)setInFrontOfCameraTransformForNode:(SCNNode *)node
{
    simd_float4x4 translation = matrix_identity_float4x4;
    simd_float4x4 cameraTransform = self.sceneView.session.currentFrame.camera.transform;
    translation.columns[3].z = -.5f;
    
    // Мне нужен чисто перенос от них! То есть я раньше умножал матрицу камеры на перенос по z на -0.5.
    // А теперь что? Я просто возьму матрицу переноса с некоторыми данными от камеры!
    
    translation = [self rotateMatrix:translation byAngle:-M_PI onAxis:@"x"];
    
//    NSLog(@"x = %f", self.sceneView.session.currentFrame.camera.eulerAngles.x);
//    NSLog(@"y = %f", self.sceneView.session.currentFrame.camera.eulerAngles.y);
//    NSLog(@"z = %f", self.sceneView.session.currentFrame.camera.eulerAngles.z);

//       translation = [self rotateMatrix:translation byAngle:self.sceneView.session.currentFrame.camera.eulerAngles.x onAxis:@"x"];
    
    
    
    //    translation.columns[0].x += cosf(M_PI_2);
    //    translation.columns[0].y += -sinf(M_PI_2);
    //    translation.columns[1].x += sinf(M_PI_2);
    //    translation.columns[1].y += cosf(M_PI_2);
    
    node.simdWorldTransform = matrix_multiply(cameraTransform, translation);

//    SCNBillboardConstraint *constraint = [[SCNBillboardConstraint alloc] init];
//    constraint.freeAxes = SCNBillboardAxisY;
//    node.constraints = @[constraint];
//    node.simdEulerAngles = self.sceneView.session.currentFrame.camera.eulerAngles;
//    node.simdPosition = simd_make_float3(self.sceneView.session.currentFrame.camera.)
}
//
//- (void)setInFrontOfCameraTransformForNode_:(SCNNode *)node
//{
//    simd_float4x4 translation = matrix_identity_float4x4;
//    simd_float4x4 cameraTransform = self.sceneView.session.currentFrame.camera.transform;
////    translation.columns[3].z = -.5f;
//
//    float tx = translation.columns[3].x = cameraTransform.columns[3].x;
//    float ty = translation.columns[3].y = cameraTransform.columns[3].y;
//    float tz = translation.columns[3].z = cameraTransform.columns[3].z - 0.5f;
//    float tw = translation.columns[3].w = 1.f;
//
//    // cameraTransform вообще без переноса
//
////    cameraTransform.columns[0].x = 1;
////    cameraTransform.columns[0].y = 0;
////    cameraTransform.columns[0].z = 0;
////    cameraTransform.columns[0].w = 0;
////    cameraTransform.columns[1].x = 0;
////    cameraTransform.columns[1].y = 1;
////    cameraTransform.columns[1].z = 0;
////    cameraTransform.columns[1].w = 0;
////    cameraTransform.columns[2].x = 0;
////    cameraTransform.columns[2].y = 0;
////    cameraTransform.columns[2].z = 1;
////    cameraTransform.columns[2].w = 0;
////    cameraTransform.columns[3].w = 1;
//
//    // Мне нужен чисто перенос от них! То есть я умножаю матрицу
//
//    //    translation = [self rotateMatrix:translation byAngle:M_PI_2 onAxis:@"y"];
////    translation = [self rotateMatrix:translation byAngle:-M_PI onAxis:@"x"];
//    //    translation = [self rotateMatrix:translation byAngle:-self.sceneView.session.currentFrame.camera.eulerAngles.x onAxis:@"x"];
//    //    translation.columns[0].x += cosf(M_PI_2);
//    //    translation.columns[0].y += -sinf(M_PI_2);
//    //    translation.columns[1].x += sinf(M_PI_2);
//    //    translation.columns[1].y += cosf(M_PI_2);
//
////    node.simdWorldTransform = matrix_multiply(cameraTransform, translation);
//    node.simdWorldTransform = translation;
//
//}

- (void)addParticleSystem
{
    SCNParticleSystem *system = [SCNParticleSystem particleSystem];
    system.particleLifeSpan = 3;
    system.birthRate = 20;
    system.particleColor = [UIColor colorWithRed:0xB2 / 255.f green:0x26 / 255.f blue:1.f alpha:1.f];
    system.particleVelocity = 240;
    system.particleVelocityVariation = 240;
    system.particleAngle = 360;
    system.particleAngleVariation = 360;
    system.spreadingAngle = 180;

    system.particleSize = 1.f;
    system.particleSizeVariation = .5;
    
    [self.sceneView.scene addParticleSystem:system withTransform:(SCNMatrix4FromMat4([self matrixWithDepth:-100.f]))];
    
    
//    Opacity 1
//    scale 0
//    Color change - 6325FF - B226FF
    // ???
//    Size Range 36,5
//    Size delta 0,99

}

- (void)addDAECube
{
    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/BOX.obj"];
    for (SCNNode *node in scene.rootNode.childNodes) {
        SCNNode *cp = [node copy];
        [self setInFrontOfCameraTransformForNode:cp];
        cp.scale = SCNVector3Make(1.f / 450.f, 1.f / 450.f, 1.f / 450.f);
        [self.sceneView.scene.rootNode addChildNode:cp];
    }
}

- (void)addLightening
{
}

@end
