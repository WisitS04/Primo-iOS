func SetupTextField(_ txtField: UITextField, _ bgColor: UIColor, _ placeholderTxt: String, _ placeholderTxtColor: UIColor, _ keyboardType: UIKeyboardType = UIKeyboardType.default)
{
    txtField.backgroundColor = bgColor
    txtField.borderStyle = .roundedRect
    txtField.keyboardType = keyboardType
    txtField.attributedPlaceholder = NSAttributedString(string: placeholderTxt,
                                                        attributes: [NSForegroundColorAttributeName: placeholderTxtColor])
}

func HexStringToUIColor (hex:String) -> UIColor
{
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#"))
    {
        cString.remove(at: cString.startIndex)
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    if ((cString.characters.count) == 6)
    {
        return UIColor(
            red:    CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green:  CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue:   CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha:  CGFloat(1.0)
        )
    }
    else if ((cString.characters.count) == 8)
    {
        return UIColor(
            red:    CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0,
            green:  CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0,
            blue:   CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0,
            alpha:  CGFloat(rgbValue & 0x000000FF) / 255.0
        )
    }
    else
    {
        return UIColor.gray
    }
}

func GenServiceParam (ownedCardList: [PrimoCard] ,EditePoint :Bool = false ,card:  [PrimoCard]) -> [[String: Any]]
{
    var result: [[String: Any]] = []
    
    if(EditePoint){
        for mCard in card{
            var ownCard: [String: Any] = ["id": mCard.cardId]
            
            if (mCard.pointToUse == nil) {
                
                if(mCard.point == nil){
                    ownCard["point"] = 0
                }else{
                    ownCard["point"] = mCard.point
                }
                
            }else{
                ownCard["point"] = mCard.pointToUse
            }
            result.append(ownCard)
        }
    }else{
        for mCard in ownedCardList {
            var ownCard: [String: Any] = ["id": mCard.cardId]
            
            if (mCard.point == nil) {
                ownCard["point"] = 0
            }else{
                ownCard["point"] = mCard.point
            }
            result.append(ownCard)
        }
    }
  

//        if (mCard.point != nil) {
//            ownCard["point"] = mCard.point
//        } else {
//            ownCard["point"] = nil
//        }

    return result
}

extension Int
{
    func ToStringWithKilo() -> String {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .decimal
//        return formatter.string(from: NSNumber(value: Float(self) / 1000)) ?? "0"
        return String(format: "%.2f", Float(self) / 1000)
    }
}

extension String
{
    static let numberFormatter = NumberFormatter()
    var floatValueWithoutComma: Float {
        let noComma = self.replacingOccurrences(of: ",", with: "")
        if let result = String.numberFormatter.number(from: noComma) {
            return result.floatValue
        }
        return 0
    }

    func DecimalFormat(withComma: Bool = false) -> String
    {
        if (withComma) {
            if let value = Float(self) {
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                return formatter.string(from: NSNumber(value: value))!
            } else {
                return ""
            }
        }
        return self
    }
    
    var length: Int {
        return self.characters.count
    }
    
    subscript (i: Int) -> String {
        return self[Range(i ..< i + 1)]
    }
    
    func substring(from: Int) -> String {
        return self[Range(min(from, length) ..< length)]
    }
    
    func substring(to: Int) -> String {
        return self[Range(0 ..< max(0, to))]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return self[Range(start ..< end)]
    }
}

extension UIView {
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.layer.add(animation, forKey: nil)
    }
}
