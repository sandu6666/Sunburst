//
//  AddNode.swift
//  SunBurst
//
//  Created by sandeep kumar on 11/01/21.
//

import Foundation
import UIKit
public class AddNode:UIView{
    var tempCount = 0

       func findAllChild(data:Node){
           if data.children != nil{
               tempCount += 1
               for items in data.children!{
                   findAllChild(data: items)
               }

           }
       }
       var bgColor:UIColor = UIColor.white
       var allowAutoFill = false
       let startAngle = CGFloat(Double.pi)
       let middleAngle = CGFloat(Double.pi + Double.pi / 2)
       let endAngle = CGFloat(2 * Double.pi)
       var currentStrokeValue = CGFloat(0)
       var addTitle = false
       let animationLineWidth:CGFloat = 30.0
       func addNodes(nodes:[Node]){
           self.backgroundColor = bgColor
           for items in nodes{
               if items.children != nil{
                   for childrens in items.children!{
                        tempCount = 1
                       findAllChild(data: childrens)

                   }
               }
           }


           var startValue:CGFloat = 0
           var completionValue = 0


           for items in nodes{
               let basLineC0unt = tempCount + 1
               let animationCenter:CGPoint = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
               let animationRadius:CGFloat = (self.frame.width)/2 - ((CGFloat(basLineC0unt) * animationLineWidth))

                   //(Int(self.frame.width)/2) - ((totalLineCount * Int(Float16(animationLineWidth)))+20)
               if let value = items.value{
                   let endValue = CGFloat((Double.pi * 2) / (10/(value+Double(completionValue))))
                   let arcPath = UIBezierPath(arcCenter: animationCenter, radius: animationRadius, startAngle: startValue, endAngle:endValue, clockwise: true)
                  //arcPath = UIBezierPath(text: NSAttributedString(string: "sgdghdgddddd"))
                   let arcLayer = CAShapeLayer()

                   arcLayer.path = arcPath.cgPath

                   arcLayer.fillColor = UIColor.clear.cgColor
                   arcLayer.strokeColor = items.color
                   arcLayer.lineWidth = animationLineWidth
                   arcLayer.masksToBounds = false
                   self.layer.addSublayer(arcLayer)
                   let pathRect = arcPath.cgPath.boundingBoxOfPath
                   arcLayer.bounds = pathRect
                   arcLayer.position = CGPoint(x: pathRect.midX, y: pathRect.midY)
                   if addTitle{
                       arcLayer.addSublayer(addTextLayer(textBound: arcLayer.bounds, name:items.name))
                   }

                       guard let childrens = items.children else {return}
                   var childStartValue = startValue
                                for children in childrens{
                                   let childEndAngle = childStartValue + ((endValue - startValue)*(CGFloat(children.value ?? 0.0) / 10))
                                    addChild(item: children, stratPoint:childStartValue, endPoint:childEndAngle, childCount: basLineC0unt-1)
                                     childStartValue = childEndAngle
                                }
                   startValue = CGFloat((Double.pi * 2) / (10/(value+Double(completionValue))))
                   completionValue += Int(value)

               }
           }
       }


       func addChild(item:Node,stratPoint:CGFloat,endPoint:CGFloat,childCount:Int){
           let childLineCount = childCount
           let animationCenter:CGPoint = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
           let animationRadius:CGFloat = (self.frame.width)/2 - ((CGFloat(childLineCount) * animationLineWidth))
           let aarcPath = UIBezierPath(arcCenter: animationCenter, radius: animationRadius, startAngle: stratPoint,
                                       endAngle:endPoint,
                                       clockwise: true)
           let aarcLayer = CAShapeLayer()
           aarcLayer.path = aarcPath.cgPath
           aarcLayer.fillColor = UIColor.clear.cgColor
           aarcLayer.strokeColor = item.color
           aarcLayer.lineWidth = animationLineWidth
           self.layer.insertSublayer(aarcLayer, at: 1)

           let pathRect = aarcPath.cgPath.boundingBoxOfPath
           aarcLayer.bounds = pathRect
           aarcLayer.position = CGPoint(x: pathRect.midX, y: pathRect.midY)
           if addTitle{
               aarcLayer.addSublayer(addTextLayer(textBound: aarcLayer.bounds, name: item.name))
           }
           guard let childrens = item.children else{return}
           var childStartValue = stratPoint
           for children in childrens{
               let childEndAngle = childStartValue + ((endPoint - stratPoint)*(CGFloat(children.value ?? 0.0) / 10))
               addChild(item: children, stratPoint: childStartValue, endPoint: childEndAngle, childCount: childLineCount-1)
               childStartValue = childEndAngle
           }
       }
       override init(frame: CGRect) {
           super.init(frame: frame)
       }

       public required init?(coder: NSCoder) {
           super.init(coder: coder)

       }
   }
public struct Node{
    public let name :String
    public var value :Double? = nil
    public var color:CGColor? = nil
    public var children:[Node]?
}

public func randomColor()->CGColor{
    return UIColor(red: .random(),
                   green: .random(),
                   blue: .random(),
                   alpha: 1).cgColor
}

fileprivate extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}



/////////
extension CGFloat {
  /** Degrees to Radian **/
  var degrees: CGFloat {
    return self * (180.0 / .pi)
  }

  /** Radians to Degrees **/
  var radians: CGFloat {
    return self / 180.0 * .pi
  }
}

func drawCurvedString(on layer: CALayer, text: NSAttributedString, angle: CGFloat, radius: CGFloat) {
  var radAngle = angle.radians

  let textSize = text.boundingRect(
    with: CGSize(width: .max, height: .max),
    options: [.usesLineFragmentOrigin, .usesFontLeading],
    context: nil)
  .integral
  .size

  let perimeter: CGFloat = 2 * .pi * radius
  let textAngle: CGFloat = textSize.width / perimeter * 2 * .pi

  var textRotation: CGFloat = 0
  var textDirection: CGFloat = 0

  if angle > CGFloat(10).radians, angle < CGFloat(170).radians {
    // bottom string
    textRotation = 0.5 * .pi
    textDirection = -2 * .pi
    radAngle += textAngle / 2
  } else {
    // top string
    textRotation = 1.5 * .pi
    textDirection = 2 * .pi
    radAngle -= textAngle / 2
  }

  for c in 0..<text.length {
    let letter = text.attributedSubstring(from: NSRange(c..<c+1))
    let charSize = letter.boundingRect(
      with: CGSize(width: .max, height: .max),
      options: [.usesLineFragmentOrigin, .usesFontLeading],
      context: nil)
    .integral
    .size

    let letterAngle = (charSize.width / perimeter) * textDirection
    let x = radius * cos(radAngle + (letterAngle / 2))
    let y = radius * sin(radAngle + (letterAngle / 2))

    let singleChar = drawText(
      on: layer,
      text: letter,
      frame: CGRect(
        x: (layer.frame.size.width / 2) - (charSize.width / 2) + x,
        y: (layer.frame.size.height / 2) - (charSize.height / 2) + y,
        width: charSize.width,
        height: charSize.height))
    layer.addSublayer(singleChar)
    singleChar.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: radAngle - textRotation))
    radAngle += letterAngle
  }
}


func drawText(on layer: CALayer, text: NSAttributedString, frame: CGRect) -> CATextLayer {
  let textLayer = CATextLayer()
  textLayer.frame = frame
  textLayer.string = text
textLayer.alignmentMode = CATextLayerAlignmentMode.center
  textLayer.contentsScale = UIScreen.main.scale
  return textLayer
}





func characterPaths(attributedString: NSAttributedString, position: CGPoint) -> [CGPath] {

 let line = CTLineCreateWithAttributedString(attributedString)

 guard let glyphRuns = CTLineGetGlyphRuns(line) as? [CTRun] else { return []}

 var characterPaths = [CGPath]()

 for glyphRun in glyphRuns {
     guard let attributes = CTRunGetAttributes(glyphRun) as? [String:AnyObject] else { continue }
     let font = attributes[kCTFontAttributeName as String] as! CTFont

     for index in 0..<CTRunGetGlyphCount(glyphRun) {
         let glyphRange = CFRangeMake(index, 1)

         var glyph = CGGlyph()
         CTRunGetGlyphs(glyphRun, glyphRange, &glyph)

         var characterPosition = CGPoint()
         CTRunGetPositions(glyphRun, glyphRange, &characterPosition)
         characterPosition.x += position.x
         characterPosition.y += position.y

         if let glyphPath = CTFontCreatePathForGlyph(font, glyph, nil) {
             var transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: characterPosition.x, ty: characterPosition.y)
             if let charPath = glyphPath.copy(using: &transform) {
                 characterPaths.append(charPath)
             }
         }
     }
 }
 return characterPaths
}

func drawTextData(charLayers:[CAShapeLayer])->[CAShapeLayer] {
    var test = charLayers
       for layer in charLayers {
           layer.removeFromSuperlayer()
       }
    let font = [NSAttributedString.Key.font:UIFont.systemFontSize ]
       let attributedString = NSMutableAttributedString(string: "myStringHere", attributes: font)
       let charPaths = characterPaths(attributedString: attributedString, position: CGPoint(x: 255, y: 632))

    test = charPaths.map { path -> CAShapeLayer in
           let shapeLayer = CAShapeLayer()
           shapeLayer.fillColor = UIColor.clear.cgColor
           shapeLayer.strokeColor = UIColor.black.cgColor
           shapeLayer.lineWidth = 30
           shapeLayer.path = path
           return shapeLayer
       }
    return test
}


func addTextLayer(textBound:CGRect,name:String)->CATextLayer{
    let test = CATextLayer()
       test.font = UIFont.systemFont(ofSize: 13)
       test.fontSize = 13
    test.foregroundColor = UIColor.white.cgColor
       test.string = name
    test.frame = textBound
    return test
}
