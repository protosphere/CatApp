import ComposableArchitecture

@Reducer
struct CatList {
    
    @ObservableState
    struct State: Equatable {
        enum Screen: Equatable {
            case loading
            case success([CatBreed])
            case error
        }
        
        var screen: Screen = .loading
    }
    
    enum Action {
        case breedsResponse(Result<[CatBreed], Error>)
        case retryTapped
        case onTask
    }
    
    private enum CancellableID {
        case breedsRequest
    }
    
    @Dependency(\.catAPIClient) var catAPIClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .breedsResponse(.failure):
                state.screen = .error
                return .none
                
            case let .breedsResponse(.success(breeds)):
                state.screen = .success(breeds)
                return .none

            case .retryTapped, .onTask:
                state.screen = .loading
                
                return .run { send in
                  await send(
                    .breedsResponse(
                      Result { try await self.catAPIClient.breeds() }
                    )
                  )
                }
                .cancellable(id: CancellableID.breedsRequest, cancelInFlight: true)
            }
        }
    }
}
