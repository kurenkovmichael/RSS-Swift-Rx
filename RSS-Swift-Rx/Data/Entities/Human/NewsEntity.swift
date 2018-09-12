import Foundation

@objc(NewsEntity)
open class NewsEntity: _NewsEntity
{
    public var link: URL?
    {
        get {
            if let linkString = self.linkString {
                return URL(string:linkString)
            } else {
                return nil
            }
        }
        set {
            self.linkString = newValue?.absoluteString
        }
    }
    
    public var isHtml: Bool
    {
        get {
            return self.isHtmlNumber?.boolValue ?? false
        }
        set {
            self.isHtmlNumber = NSNumber(value: newValue)
        }
    }
    
    public var category: [String]?
    {
        get {
            return self.categoryTransform as? [String]
        }
        set {
            self.categoryTransform = newValue as AnyObject
        }
    }
}
