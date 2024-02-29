import ComposableArchitecture
import SwiftUI

@main
struct CatApp: App {
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                CatListView(
                    store: Store(initialState: CatList.State()) {
                        CatList()
                    }
                )
            }
        }
    }
}
