//
//  Sketch.swift
//  Animation
//
//  Created by Russell Gordon on 2015-12-05.
//  Copyright © 2015 Royal St. George's College. All rights reserved.
//

import Foundation

class Sketch {

    // NOTE: Every sketch must contain an object of type Canvas named 'canvas'
    //       Therefore, the line immediately below must always be present.
    let canvas : Canvas
    
    // Declare any properties you need for your sketch below this comment, but before init()
    var x = 1
    var s = 1

    // This runs once, equivalent to setup() in Processing
    init() {
        
        // Create canvas object – specify size (size)
        canvas = Canvas(width: 1200, height: 700)
        
        // The frame rate can be adjusted; the default is 60 fps
        canvas.framesPerSecond = 60
        
    }
    
    // Runs repeatedly, equivalent to draw() in Processing
    func draw() {
                
        // Horizontal position of circle
        x = x + s
        
        // Bounce when hitting wall
        if (x*50 > canvas.width || x < 0) {
            s *= -1
        }
        
    // Clear the background
    canvas.drawShapesWithBorders = false
    canvas.fillColor = Color(hue: Float(canvas.frameCount/2), saturation: 100, brightness: 100, alpha: 100)
    canvas.drawRectangle(bottomRightX: 0, bottomRightY: 0, width: canvas.width, height: canvas.height)
        
    // Draw a circle that moves across the screen
    canvas.drawShapesWithBorders = false
    canvas.fillColor = Color(hue: Float(canvas.frameCount*5), saturation: 80, brightness: 90, alpha: 100)
    canvas.drawEllipse(centreX: x*50, centreY: canvas.height / 2, width: 100, height: 100)
        
        
    canvas.fillColor = Color(hue: Float(canvas.frameCount*5), saturation: 99, brightness: 100, alpha: 100)
    canvas.drawRectangle(bottomRightX: 0, bottomRightY: 0, width: 1200, height: 50)

    canvas.fillColor = Color(hue: Float(canvas.frameCount*5), saturation: 99, brightness: 100, alpha: 100)
    canvas.drawRectangle(bottomRightX: 0, bottomRightY: 650, width: 1200, height: 50)

        
    }
    
}