//
//  ViewController.swift
//  Core_Graphics
//
//  Created by Arvin Shen on 1/12/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var currentDrawType = 0
    var width: CGFloat = 512
    var height: CGFloat = 512
    
    override func viewDidLoad() {
        super.viewDidLoad()

        drawRectangle()
    }

    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        
        if currentDrawType > 7 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawRectangle()
            
        case 1:
            drawCircle()
            
        case 2:
            drawCheckerboard()
            
        case 3:
            drawRotatedSquares()
            
        case 4:
            drawLines()
            
        case 5:
            drawImagesAndText()
            
        case 6:
            drawStar()
            
        case 7:
            drawTwin()
            
        default:
            break
        }
    }
    
    func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
        
        let img = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: width, height: height)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = img
    }
    
    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
        
        let img = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: width, height: height).insetBy(dx: 5, dy: 5)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = img
    }
    
    func drawCheckerboard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
        
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col) % 2 == 0 {
                        ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }
        
        imageView.image = img
    }
    
    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
        
        let img = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            
            for _ in 0 ..< rotations {
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = img
    }
    
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
        
        let img = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length: CGFloat = 256
            
            for _ in 0 ..< 256 {
                ctx.cgContext.rotate(by: .pi / 2)
                
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                
                length *= 0.99
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = img
    }
    
    func drawImagesAndText() {
        // 1. Create a renderer at the correct size.
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
        
        let img = renderer.image { ctx in
            // 2. Define a paragraph style that aligns text to the center.
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            // 3. Create an attributes dictionary containing that paragraph style, and also a font.
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
            
            // 4. Wrap that attributes dictionary and a string into an instance of NSAttributedString.
            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            
            // 5. Load an image from the project and draw it to the context.
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        
        // 6. Update the image view with the finished result.
        imageView.image = img
    }
    
    func drawStar() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
        
        let img = renderer.image { ctx in            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            let center = CGPoint(x: width / 2, y: height / 2)
            var outerPoints = [CGPoint]()
            var innerPoints = [CGPoint]()
            var x: CGFloat = 0
            var y: CGFloat = 0
            let degree = Double.pi / 180
            let outerRadius: CGFloat = 256
            let innerRadius: CGFloat = 256 / 3
            for i in 0 ..< 5 {
                // add star's outer point coordinates
                x = outerRadius * cos(CGFloat((18 + 72 * Double(i)) * degree))
                y = outerRadius * sin(CGFloat((18 + 72 * Double(i)) * degree))
                outerPoints.append(CGPoint(x: center.x + x, y: center.y - y))
                
                // add star's inner point coordinates
                x = innerRadius * cos(CGFloat((54 + 72 * Double(i)) * degree))
                y = innerRadius * sin(CGFloat((54 + 72 * Double(i)) * degree))
                innerPoints.append(CGPoint(x: center.x + x, y: center.y - y))
            }
            
            // draw triangles for star's outer points
            for (i, j) in zip(0 ..< outerPoints.count, 0 ..< innerPoints.count) {
                // draw line from outer point to one side of inner point
                ctx.cgContext.move(to: CGPoint(x: outerPoints[i].x, y: outerPoints[i].y))
                ctx.cgContext.addLine(to: CGPoint(x: innerPoints[j].x, y: innerPoints[j].y))
                
                // draw line from inner point to inner point on other side of outer point
                ctx.cgContext.addLine(to: CGPoint(x: innerPoints[j <= 0 ? innerPoints.count - 1 : j - 1].x, y: innerPoints[j <= 0 ? innerPoints.count - 1 : j - 1].y))
                
                // draw line from inner point to outer point
                ctx.cgContext.addLine(to: CGPoint(x: outerPoints[i].x, y: outerPoints[i].y))
                                
                ctx.cgContext.closePath()
                ctx.cgContext.drawPath(using: .fill)
            }
            
            // draw pentagon for star's inner points
            for i in 0 ..< innerPoints.count {
                if i == 0 && (i + 1) <= innerPoints.count {
                    ctx.cgContext.move(to: CGPoint(x: innerPoints[i].x, y: innerPoints[i].y))
                    ctx.cgContext.addLine(to: CGPoint(x: innerPoints[i+1].x, y: innerPoints[i+1].y))
                }
                else if i == innerPoints.count - 1 {
                    ctx.cgContext.addLine(to: CGPoint(x: innerPoints[0].x, y: innerPoints[0].y))
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: innerPoints[i+1].x, y: innerPoints[i+1].y))
                }
            }
            ctx.cgContext.closePath()
            ctx.cgContext.drawPath(using: .fill)
        }
        
        imageView.image = img
    }
    
    func drawTwin() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
        
        let img = renderer.image { ctx in
            //letter T:
            ctx.cgContext.move(to: CGPoint(x: 20, y: 156))
            ctx.cgContext.addLine(to: CGPoint(x: 160, y: 156))
            
            ctx.cgContext.move(to: CGPoint(x: 90, y: 156))
            ctx.cgContext.addLine(to: CGPoint(x: 90, y: 356))

            //letter W:
            ctx.cgContext.move(to: CGPoint(x: 178, y: 156))
            ctx.cgContext.addLine(to: CGPoint(x: 213, y: 356))
            
            ctx.cgContext.move(to: CGPoint(x: 213, y: 356))
            ctx.cgContext.addLine(to: CGPoint(x: 248, y: 306))
            
            ctx.cgContext.move(to: CGPoint(x: 248, y: 306))
            ctx.cgContext.addLine(to: CGPoint(x: 283, y: 356))
            
            ctx.cgContext.move(to: CGPoint(x: 283, y: 356))
            ctx.cgContext.addLine(to: CGPoint(x: 318, y: 156))
                        
            // letter I:
            ctx.cgContext.move(to: CGPoint(x: 334, y: 156))
            ctx.cgContext.addLine(to: CGPoint(x: 334, y: 356))
            
            // letter N:
            ctx.cgContext.move(to: CGPoint(x: 352, y: 156))
            ctx.cgContext.addLine(to: CGPoint(x: 352, y: 356))
            
            ctx.cgContext.move(to: CGPoint(x: 352, y: 156))
            ctx.cgContext.addLine(to: CGPoint(x: 492, y: 356))
            
            ctx.cgContext.move(to: CGPoint(x: 492, y: 356))
            ctx.cgContext.addLine(to: CGPoint(x: 492, y: 156))
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = img
    }
}

