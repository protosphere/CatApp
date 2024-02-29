# CatApp

CatApp is a simple SwiftUI application that displays a list of cat breeds along with an image of each breed, using `thecatapi.com`.

It uses [The Composible Architecture](https://github.com/pointfreeco/swift-composable-architecture); this helps to produce testable code whilst still feeling ergonomic to use with SwiftUI. Originally I approached the problem with a simpler MVVM-like solution, however I didn't feel that it played nicely with the way SwiftUI works. I believe the minor additional learning curve introduced by using The Composible Architecture is worthwhile.

The main list is displayed using a `LazyVStack` as opposed to a `List` so that a custom look can easily be achieved.

## Before Building 

Change `API_KEY_HERE` in `CatAPIClient.swift` to your API key from `thecatapi.com`.

## TODO

- Show more detail about each cat breed.
- Investigate why `AsyncImage` sometimes fails to load images; allow retrying failed image loads.
- Implement better support for VoiceOver/accessibility technologies.
- Add support for localisation.
