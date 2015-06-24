import Foundation
import CoreData

class History: NSManagedObject {

    @NSManaged var created_at: NSDate
    @NSManaged var updated_at: NSDate
    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var userId: String
    @NSManaged var userProfileImageUrl: String

}
    