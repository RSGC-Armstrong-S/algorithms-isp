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
  
    // Distance line
    var y = 0
    var x = 0
    
    // Number line
    var x2 = 0
    var y2 = 0
    
    // Moving the distance circle
    var s = 1
    var Speed = 3
    
    // Weight / Width
    var H = 10
    var W = 10
    


    
    // This runs once, equivalent to setup() in Processing
    override init() {
        
        // Create canvas object – specify size
        canvas = Canvas(width: 1200, height: 700)
       
        // While background
        canvas.fillColor = Color(hue: 0, saturation: 00, brightness: 100, alpha: 100)
        canvas.drawRectangle(bottomRightX: 0, bottomRightY: 0, width: canvas.width, height: canvas.height)
    
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
        
        canvas.drawShapesWithBorders = false


        // Horizontal position of circle
        x = x + s

        
        // Draw distance graph
        canvas.fillColor = Color(hue: Float(canvas.frameCount*4), saturation: 100, brightness: 100, alpha: 100)
        canvas.drawEllipse(centreX: x * Speed, centreY: y * 2 - 30, width: W, height: H)
        
        // Loop for x and y number lines
        while (x > 0 && x2 < 1200){
            
            canvas.fillColor = Color(hue: 0, saturation: 100, brightness: 00, alpha: 100)

            // X-axis
            canvas.drawRectangle(bottomRightX: x2, bottomRightY: 0, width: 5, height: 10)
            x2 = x2 + 20
            
            // Y-axis
            canvas.drawRectangle(bottomRightX: 0, bottomRightY: y2, width: 10, height: 5)
            y2 = y2 + 20

        }
        
        
  
        // Resetting backround, graph line and numberlines
        if (x * Speed > canvas.width) {
            x = 0
            x2 = 0
            y2 = 0
            canvas.fillColor = Color(hue: 0, saturation: 00, brightness: 100, alpha: 100)
            canvas.drawRectangle(bottomRightX: 0, bottomRightY: 0, width: canvas.width, height: canvas.height)
        }
        
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

