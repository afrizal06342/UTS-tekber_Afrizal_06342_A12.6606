import Foundation

final class DataManager {
  var defaults = UserDefaults.standard
  
  func save(course: Course) {
    if let encoded = try? JSONEncoder().encode(course) {
      defaults.set(encoded, forKey: "course")
    }
  }
  
  func get() -> Course? {
    if let savedCourse = defaults.object(forKey: "course") as? Data {
      if let decodedCourse = try? JSONDecoder().decode(Course.self, from: savedCourse) {
        return decodedCourse
      }
    }
    return nil
  }
  
  func delete() {
    defaults.removeObject(forKey: "course")
  }
}
