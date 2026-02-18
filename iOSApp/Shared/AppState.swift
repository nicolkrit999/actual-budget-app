import Foundation
import Combine

final class AppState: ObservableObject {
    // --- NEW: Theme Management ---
    enum Theme: String, CaseIterable, Identifiable {
        case Dark = "Dark"
        case amoledDark = "Dark (AMOLED)"
        case systemLight = "System Light"
        var id: String { self.rawValue }
    }
    
    // IMPORTANT: This creates the connection to the Shared App Group
    // so the Widget can read the API Key and URL.
    private var userDefaults: UserDefaults {
        return UserDefaults(suiteName: "group.ch.nicolkrit.budget") ?? .standard
    }
    
    @Published var currentTheme: Theme {
        didSet { userDefaults.set(currentTheme.rawValue, forKey: Keys.currentTheme) }
    }
    
    @Published var baseURLString: String {
        didSet {
            userDefaults.set(baseURLString, forKey: Keys.baseURL)
            AppLogger.shared.updateRedactionBaseURL(baseURLString)
        }
    }
    @Published var apiKey: String {
        didSet { userDefaults.set(apiKey, forKey: Keys.apiKey) }
    }
    @Published var syncId: String {
        didSet { userDefaults.set(syncId, forKey: Keys.syncId) }
    }
    @Published var budgetEncryptionPassword: String {
        didSet { userDefaults.set(budgetEncryptionPassword, forKey: Keys.budgetEncryptionPassword) }
    }
    @Published var isDemoMode: Bool {
        didSet { userDefaults.set(isDemoMode, forKey: Keys.isDemoMode) }
    }
    @Published var currencyCode: String {
        didSet { userDefaults.set(currencyCode, forKey: Keys.currencyCode) }
    }

    var isConfigured: Bool { isDemoMode || (!baseURLString.isEmpty && !apiKey.isEmpty && !syncId.isEmpty) }

    init() {
        let defaults = UserDefaults(suiteName: "group.ch.nicolkrit.budget") ?? .standard
        
        self.baseURLString = defaults.string(forKey: Keys.baseURL) ?? ""
        self.apiKey = defaults.string(forKey: Keys.apiKey) ?? ""
        self.syncId = defaults.string(forKey: Keys.syncId) ?? ""
        self.budgetEncryptionPassword = defaults.string(forKey: Keys.budgetEncryptionPassword) ?? ""
        self.isDemoMode = defaults.bool(forKey: Keys.isDemoMode)
        
        self.currencyCode = defaults.string(forKey: Keys.currencyCode) ?? Locale.current.currency?.identifier ?? "CHF"
        
        let savedTheme = defaults.string(forKey: Keys.currentTheme) ?? ""
        self.currentTheme = Theme(rawValue: savedTheme) ?? .amoledDark
        AppLogger.shared.updateRedactionBaseURL(self.baseURLString)
    }

    func resetConfiguration() {
        baseURLString = ""
        apiKey = ""
        syncId = ""
        budgetEncryptionPassword = ""
        // Also clear them from storage
        userDefaults.removeObject(forKey: Keys.baseURL)
        userDefaults.removeObject(forKey: Keys.apiKey)
        userDefaults.removeObject(forKey: Keys.syncId)
        userDefaults.removeObject(forKey: Keys.budgetEncryptionPassword)
    }

    private enum Keys {
        static let baseURL = "ActualBaseURL"
        static let apiKey = "ActualAPIKey"
        static let syncId = "ActualSyncId"
        static let budgetEncryptionPassword = "ActualBudgetEncryptionPassword"
        static let isDemoMode = "ActualIsDemoMode"
        static let currencyCode = "ActualCurrencyCode"
        static let currentTheme = "ActualCurrentTheme"
    }
}
