import Foundation

@objc(NewsSourceEntity)
open class NewsSourceEntity: _NewsSourceEntity
{    
    public var link: URL
    {
        get {
            return URL(string: self.linkString)!
        }
        set {
            self.linkString = newValue.absoluteString
        }
    }
    
    public var imageUrl: URL?
    {
        get {
            return self.imageUrlString != nil ? URL(string: self.imageUrlString!) : nil
        }
        set {
            self.imageUrlString = newValue?.absoluteString
        }
    }
    
    public var imageLink: URL?
    {
        get {
            return self.imageLinkString != nil ? URL(string: self.imageLinkString!) : nil
        }
        set {
            self.imageLinkString = newValue?.absoluteString
        }
    }
}
