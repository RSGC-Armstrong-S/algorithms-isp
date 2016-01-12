//
//  Sketch.swift
//  Animation
//
//  Created by Russell Gordon on 2015-12-05.
//  Copyright © 2015 Royal St. George's College. All rights reserved.
//

import Foundation

// NOTE: The Sketch class will define the methods required by the ORSSerialPortDelegate protocol
//
// “A protocol defines a blueprint of methods, properties, and other requirements that suit a
// particular task or piece of functionality.”
//
// Excerpt From: Apple Inc. “The Swift Programming Language (Swift 2).” iBooks. https://itun.es/ca/jEUH0.l
//
// In this case, the Sketch class implements methods that allow us to read and use the serial port, via
// the ORSSerialPort library.
class Sketch : NSObject, ORSSerialPortDelegate {
    
    // NOTE: Every sketch must contain an object of type Canvas named 'canvas'
    //       Therefore, the line immediately below must always be present.
    let canvas : Canvas
    
    // Declare any properties you need for your sketch below this comment, but before init()
    var serialPort : ORSSerialPort?       // Object required to read serial port
    var serialBuffer : String = ""
  
    var y = 0
    var x = 1
    var s = 1
    var W = 10
    var H = 10
    var i = 0
    var Ell = [0, 15, 30, 45, 60, 75, 90, 105, 120, 135, 150, 165, 180, 195, 210, 225, 240, 255, 270, 285, 300, 315, 330, 345, 360, 375, 390, 405, 420, 435, 450, 465, 480, 495, 510, 525, 540, 555, 570, 585, 600, 615, 630, 645, 660, 675, 690, 705, 720, 735, 750, 765, 780, 795, 810, 825, 840, 855, 870, 885, 900, 915, 930, 945, 960, 975, 990, 1005, 1020, 1035, 1050, 1065, 1080, 1095, 1110, 1125, 1140, 1155, 1170, 1185, 1200, 1215, 1230, 1245, 1260, 1275, 1290, 1305, 1320, 1335, 1350, 1365, 1380, 1395, 1410, 1425, 1440, 1455, 1470, 1485, 1500]
    
    
    // This runs once, equivalent to setup() in Processing
    override init() {
        
        // Create canvas object – specify size
        canvas = Canvas(width: 1200, height: 700)
    
        // The frame rate can be adjusted; the default is 60 fps
        canvas.framesPerSecond = 60
        
        // Call superclass initializer
        super.init()
        
        // Find and list available ports
        var availablePorts = ORSSerialPortManager.sharedSerialPortManager().availablePorts
        if availablePorts.count == 0 {
            
            // Show error message if no ports found
            print("No connected serial ports found. Please connect your USB to serial adapter(s) and run the program again.\n")
            exit(EXIT_SUCCESS)
            
        } else {
            
            // List available ports in debug window (view this and adjust
            print("Available ports are...")
            for (i, port) in availablePorts.enumerate() {
                print("\(i). \(port.name)")
            }
            
            // Open the desired port
            serialPort = availablePorts[0]  // selecting first item in list of available ports
            serialPort!.baudRate = 9600
            serialPort!.delegate = self
            serialPort!.open()
            
        }
        
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
        canvas.fillColor = Color(hue: 0, saturation: 100, brightness: 00, alpha: 100)
        canvas.drawRectangle(bottomRightX: 0, bottomRightY: 0, width: canvas.width, height: canvas.height)
        
        
        //borders
        canvas.fillColor = Color(hue: Float(canvas.frameCount*5), saturation: 99, brightness: 100, alpha: 100)
        canvas.drawRectangle(bottomRightX: 0, bottomRightY: 0, width: 1200, height: 50)
        
        canvas.fillColor = Color(hue: Float(canvas.frameCount*5), saturation: 99, brightness: 100, alpha: 100)
        canvas.drawRectangle(bottomRightX: 0, bottomRightY: 650, width: 1200, height: 50)
        
        
        // Draw a circle that moves across the screen
        canvas.drawShapesWithBorders = false
        canvas.fillColor = Color(hue: Float(canvas.frameCount*5), saturation: 80, brightness: 90, alpha: 100)
    
        canvas.drawEllipse(centreX: x*50, centreY: canvas.height / 2 + 0, width: W, height: H)
        canvas.drawEllipse(centreX: x*50, centreY: canvas.height / 2 + 15, width: W, height: H)
        canvas.drawEllipse(centreX: x*50, centreY: canvas.height / 2 + 30, width: W, height: H)
        canvas.drawEllipse(centreX: x*50, centreY: canvas.height / 2 + 45, width: W, height: H)
        canvas.drawEllipse(centreX: x*50, centreY: canvas.height / 2 + 60, width: W, height: H)
        canvas.drawEllipse(centreX: x*50, centreY: canvas.height / 2 + 75, width: W, height: H)
        canvas.drawEllipse(centreX: x*50, centreY: canvas.height / 2 + 90, width: W, height: H)
        canvas.drawEllipse(centreX: x*50, centreY: canvas.height / 2 + 105, width: W, height: H)
        canvas.drawEllipse(centreX: x*50, centreY: canvas.height / 2 + 120, width: W, height: H)
    }
    
    // ORSSerialPortDelegate
    // These four methods are required to conform to the ORSSerialPort protocol
    // (Basically, the methods will be invoked when serial port events happen)
    func serialPort(serialPort: ORSSerialPort, didReceiveData data: NSData) {
        
        // Print whatever we receive off the serial port to the console
        if let string = String(data: data, encoding: NSUTF8StringEncoding) {
            
            // Iterate over all the characters received from the serial port this time
            for chr in string.characters {
                
                // Check for delimiter
                if chr == "|" {
                    
                    // Entire value sent from Arduino board received, assign to
                    // variable that controls the vertical position of the circle on screen
                    y = Int(serialBuffer)!
                    
                    // Reset the string that is the buffer for data received from serial port
                    serialBuffer = ""
                    
                } else {
                    
                    // Have not received all the data yet, append what was received to buffer
                    serialBuffer += String(chr)
                }
                
            }
            
            // DEBUG: Print what's coming over the serial port
            print("\(string)", terminator: "")
            
        }
        
    }
    
    func serialPortWasRemovedFromSystem(serialPort: ORSSerialPort) {
        self.serialPort = nil
    }
    
    func serialPort(serialPort: ORSSerialPort, didEncounterError error: NSError) {
        print("Serial port (\(serialPort)) encountered error: \(error)")
    }
    
    func serialPortWasOpened(serialPort: ORSSerialPort) {
        print("Serial port \(serialPort) was opened")
    }
    
}