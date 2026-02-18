import Foundation
import WidgetKit

struct SimpleEntry: TimelineEntry {
    let date: Date
    let spentToday: Int
    let currencyCode: String
}

class SharedDataManager {
    static let shared = SharedDataManager()
    
    private let userDefaults = UserDefaults(suiteName: "group.ch.nicolkrit.actualbudget")
    
    private enum Keys {
        static let spentToday = "spentToday"
        static let currencyCode = "currencyCode"
    }

    func save(spentToday: Int, currencyCode: String) {
        let defaults = userDefaults ?? .standard
        defaults.setValue(spentToday, forKey: Keys.spentToday)
        defaults.setValue(currencyCode, forKey: Keys.currencyCode)
        
        WidgetCenter.shared.reloadAllTimelines()
    }

    func readEntry() -> SimpleEntry {
        let defaults = userDefaults ?? .standard
        let spent = defaults.integer(forKey: Keys.spentToday)
        let code = defaults.string(forKey: Keys.currencyCode) ?? "CHF"
        return SimpleEntry(date: Date(), spentToday: spent, currencyCode: code)
    }
}
