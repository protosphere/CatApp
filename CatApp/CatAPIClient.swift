import ComposableArchitecture
import Foundation

struct CatImage: Decodable, Equatable, Sendable {
    
    var url: URL
    var width: Int
    var height: Int
}

struct CatBreed: Decodable, Equatable, Identifiable, Sendable {

    var id: String
    var name: String
    var image: CatImage?
}

@DependencyClient
struct CatAPIClient {
    
    var breeds: @Sendable () async throws -> [CatBreed]
}

extension CatAPIClient: TestDependencyKey {
    
    static let previewValue = Self(
        breeds: {
            [
                CatBreed(
                    id: "one",
                    name: "Cat 1",
                    image: nil
                ),
                CatBreed(
                    id: "two",
                    name: "Cat 2",
                    image: nil
                ),
                CatBreed(
                    id: "three",
                    name: "Cat 3",
                    image: nil
                ),
                CatBreed(
                    id: "four",
                    name: "Cat 4",
                    image: nil
                )
            ]
        }
    )
    
    static let testValue = Self()
}

extension DependencyValues {
    
    var catAPIClient: CatAPIClient {
        get {
            self[CatAPIClient.self]
        }
        
        set {
            self[CatAPIClient.self] = newValue
        }
    }
}

extension CatAPIClient: DependencyKey {

    static let liveValue = CatAPIClient(
        breeds: {
            var urlComponents = URLComponents(string: "https://api.thecatapi.com/v1/breeds")!
            urlComponents.queryItems = [
                URLQueryItem(name: "api_key", value: "API_KEY_HERE"),
            ]
            
            let (data, _) = try await URLSession.shared.data(from: urlComponents.url!)
            return try JSONDecoder().decode([CatBreed].self, from: data)
        }
    )
}
