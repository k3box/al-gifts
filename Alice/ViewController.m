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
}

- (void)setInFrontOfCameraTransformForNode:(SCNNode *)node
{
    simd_float4x4 translation = matrix_identity_float4x4;
    translation.columns[3].z = -.5f;
    node.simdTransform = matrix_multiply(self.sceneView.session.currentFrame.camera.transform, translation);

}

- (void)addDAECube
{
    
    
////    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
////    let scene = SCNScene(named: documentsURL.absoluteString+"idle.dae")
//
////    NSString * resourcePath = [[NSBundle mainBundle] pathForResource:@"Excited" ofType:nil];
//    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
//    NSString * resourcePath = [bundle pathForResource:@"eyes" ofType:@"png"];
//
//    NSError *e = nil;
////
////    NSArray *es = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:resourcePath error:&e];
////
////    NSURL *documentsURL = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
////    NSArray *a = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:documentsURL includingPropertiesForKeys:nil options:kNilOptions error:&e];
//
////    NSString *name = [resourcePath stringByAppendingPathComponent:@"Excited"];
////    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:name isDirectory:nil];
//
//    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:resourcePath isDirectory:nil];
//    NSData *data = [NSData dataWithContentsOfFile:resourcePath];
//
////    SCNSceneSource *scr = [SCNSceneSource sceneSourceWithData:data options:nil];
////    SCNScene *knucklesExcitedScene = [scr sceneWithOptions:nil error:&e];
////    SCNScene *knucklesExcitedScene = [SCNScene

    UIImage *eyes = [UIImage imageNamed:@"eyes"];

//    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/Excited.dae"];

    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/BOX.obj"];

//    self.sceneView.scene = scene;
//
    for (SCNNode *node in scene.rootNode.childNodes) {
        SCNNode *cp = [node copy];
        [self setInFrontOfCameraTransformForNode:cp];
        cp.scale = SCNVector3Make(1.f / 450.f, 1.f / 450.f, 1.f / 450.f);
        [self.sceneView.scene.rootNode addChildNode:cp];
    }
}

@end
