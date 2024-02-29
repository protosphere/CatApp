import ComposableArchitecture
import XCTest
@testable import CatApp

@MainActor
final class CatAppTests: XCTestCase {

    func testLoadSuccess() async {
        let store = TestStore(initialState: CatList.State()) {
            CatList()
        } withDependencies: {
            $0.catAPIClient.breeds = { .mock }
        }

        await store.send(.onTask)
        
        await store.receive(\.breedsResponse.success) {
            $0.screen = .success(.mock)
        }
    }
    
    func testLoadFailure() async {
        let store = TestStore(initialState: CatList.State()) {
            CatList()
        } withDependencies: {
            $0.catAPIClient.breeds = { throw TestError() }
        }
        
        await store.send(.onTask)
        
        await store.receive(\.breedsResponse.failure) {
            $0.screen = .error
        }
    }
    
    func testRetryFromFailure() async {
        let store = TestStore(
            initialState: CatList.State(screen: .error)
        ) {
            CatList()
        } withDependencies: {
            $0.catAPIClient.breeds = { .mock }
        }
        
        await store.send(.retryTapped) {
            $0.screen = .loading
        }
        
        await store.receive(\.breedsResponse.success) {
            $0.screen = .success(.mock)
        }
    }
}

private struct TestError: Equatable, Error {}

extension Array where Element == CatBreed {
    static let mock = [
        CatBreed(
            id: "one",
            name: "Cat 1",
            image: CatImage(
                url: URL(string: "https://test.test/image1.jpg")!,
                width: 200,
                height: 150
            )
        ),
        CatBreed(
            id: "two",
            name: "Cat 2",
            image: CatImage(
                url: URL(string: "https://test.test/image2.jpg")!,
                width: 200,
                height: 150
            )
        ),
        CatBreed(
            id: "three",
            name: "Cat 3",
            image: nil
        )
    ]
}
