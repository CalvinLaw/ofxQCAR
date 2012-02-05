#include "testApp.h"

//--------------------------------------------------------------
void testApp :: setup()
{	
	ofRegisterTouchEvents( this );
	ofxAccelerometer.setup();
	ofxiPhoneAlerts.addListener( this );
	ofBackground( 127 );
    
    teapotImage.loadImage( "qcar_assets/TextureTeapotBrass.png" );
    teapotImage.mirror( true, false );  //-- flip texture vertically since the texture coords are set that way on the teapot.
    
    touchPoint.x = touchPoint.y = -1;
    
    ofxQCAR::getInstance()->setup();
}

//--------------------------------------------------------------
void testApp :: update()
{
    ofxQCAR::getInstance()->update();
}

//--------------------------------------------------------------
void testApp :: draw()
{
    ofxQCAR *qcar;
    qcar = ofxQCAR::getInstance();
    qcar->draw();
    
    bool bPressed;
    bPressed = touchPoint.x >= 0 && touchPoint.y >= 0;
    
    if( qcar->hasFoundMarker() )
    {
        glDisable( GL_DEPTH_TEST );
        ofEnableBlendMode( OF_BLENDMODE_ALPHA );
        ofSetLineWidth( 3 );
        
        bool bInside = false;
        if( bPressed )
        {
            vector<ofPoint> markerPoly;
            markerPoly.push_back( qcar->getMarkerCorner( (ofxQCAR_MarkerCorner)0 ) );
            markerPoly.push_back( qcar->getMarkerCorner( (ofxQCAR_MarkerCorner)1 ) );
            markerPoly.push_back( qcar->getMarkerCorner( (ofxQCAR_MarkerCorner)2 ) );
            markerPoly.push_back( qcar->getMarkerCorner( (ofxQCAR_MarkerCorner)3 ) );
            bInside = ofInsidePoly( touchPoint, markerPoly );
        }
        
        ofSetColor( ofColor( 255, 0, 255, bInside ? 150 : 50 ) );
        qcar->drawMarkerRect();
        
        ofSetColor( ofColor :: yellow );
        qcar->drawMarkerBounds();
        ofSetColor( ofColor :: cyan );
        qcar->drawMarkerCenter();
        qcar->drawMarkerCorners();
        
        ofSetColor( ofColor::white );
        ofSetLineWidth( 1 );
        
        glEnable( GL_DEPTH_TEST );
        ofEnableNormalizedTexCoords();
        
        teapotImage.getTextureReference().bind();
        ofDrawTeapot( qcar->getProjectionMatrix(), qcar->getModelViewMatrix(), 3 );
        teapotImage.getTextureReference().unbind();
        
        ofDisableNormalizedTexCoords();
    }
    
    glEnable( GL_DEPTH_TEST );
    
    if( bPressed )
    {
        ofSetColor( ofColor :: red );
        ofDrawBitmapString( "touch x = " + ofToString( (int)touchPoint.x ), 20, 40 );
        ofDrawBitmapString( "touch y = " + ofToString( (int)touchPoint.y ), 20, 60 );
    }
}

//--------------------------------------------------------------
void testApp :: exit()
{
    ofUnregisterTouchEvents( this );
	ofxiPhoneAlerts.removeListener( this );
    
    ofxQCAR::getInstance()->exit();
}

//--------------------------------------------------------------
void testApp :: touchDown(ofTouchEventArgs &touch)
{
    touchPoint.set( touch.x, touch.y );
}

//--------------------------------------------------------------
void testApp :: touchMoved(ofTouchEventArgs &touch)
{
    touchPoint.set( touch.x, touch.y );
}

//--------------------------------------------------------------
void testApp :: touchUp(ofTouchEventArgs &touch)
{
    touchPoint.set( -1, -1 );
}

//--------------------------------------------------------------
void testApp :: touchDoubleTap(ofTouchEventArgs &touch)
{
    //
}

//--------------------------------------------------------------
void testApp :: lostFocus()
{
    //
}

//--------------------------------------------------------------
void testApp :: gotFocus()
{
    //
}

//--------------------------------------------------------------
void testApp :: gotMemoryWarning()
{
    //
}

//--------------------------------------------------------------
void testApp :: deviceOrientationChanged(int newOrientation)
{
    //
}

//--------------------------------------------------------------
void testApp :: touchCancelled(ofTouchEventArgs& args)
{
    //
}

