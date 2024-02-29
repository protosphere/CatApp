import ComposableArchitecture
import SwiftUI

struct CatListView: View {
    
    @Bindable var store: StoreOf<CatList>
    
    var body: some View {
        ZStack {
            switch store.screen {
            case .loading:
                ProgressView()
            case .success(let breeds):
                CatListContentView(breeds: breeds)
            case .error:
                VStack(spacing: 16) {
                    Text("Couldn't load cats.")
                    Button("Retry") {
                        store.send(.retryTapped)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Cat App")
        .task {
            await store.send(.onTask).finish()
        }
    }
}

struct CatListContentView: View {
    
    private let breeds: [CatBreed]
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(breeds) { breed in
                    CatView(title: breed.name) {
                        if let image = breed.image {
                            AsyncImage(url: image.url) { phase in
                                if let image = phase.image {
                                    image.resizable()
                                } else if phase.error != nil {
                                    Text("Couldn't load image.")
                                        .padding(16)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                } else {
                                    ProgressView()
                                        .padding(16)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                }
                            }
                            .aspectRatio(CGFloat(image.width) / CGFloat(image.height), contentMode: .fit)
                        } else {
                            Text("No image available.")
                                .padding(16)
                        }
                    }
                }
            }
            .padding([.top, .bottom], 8)
            .frame(maxWidth: .infinity)
        }
    }
    
    init(breeds: [CatBreed]) {
        self.breeds = breeds
    }
}
                        
struct CatView<Image: View>: View {
    
    let title: String
    let image: Image
    
    var body: some View {
        VStack(spacing: 0) {
            image
            
            Rectangle()
                .frame(height: 1, alignment: .top).foregroundColor(Color.gray)
            
            Text(title)
                .padding(16)
        }
        .background(Color(uiColor: .tertiarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray)
        )
        .padding([.leading, .trailing], 16)
        .padding([.top, .bottom], 8)
        .frame(maxWidth: .infinity)

    }
    
    init(title: String, @ViewBuilder image: () -> Image) {
        self.title = title
        self.image = image()
    }
}

#Preview {
    NavigationStack {
        CatListView(
            store: Store(initialState: CatList.State()) {
                CatList()
            }
        )
    }
}
