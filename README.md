# Cristian ING Assignment

Hello,
I'm Cristian, an iOS developer boasting 8 years of experience in mobile development. I crafted this sample app leveraging Xcode 15 and Swift 5.0. Throughout this assignment, I integrated various technologies and programming paradigms, such as:
1. MVVM architecture
2. Coordinator pattern
3. Fundamental data structures
4. Server communication using URLSession
5. JSON parsing and decodable
6. Reactive programming using RxSwift and RxCocoa
7. Protocols delegates
8. Auto-layout (utilizing both XIB and programmatic constraints)
9. TableView and CollectionView integration
10. Loader view implementation
11. Dependency management using CocoaPods and Swift Package Manager (SPM)
12. GitHub for efficient version control
13. Unit testing with session mocking techniques
14. UI testing

The sample app showcases four distinct screens:
1. Specifics: Here, a TableView lists specifics. Users can select multiple specifics and reset these selections. Upon selecting at least one specific, users can advance to the next screen.
2. Channels: This screen offers a TableView of channels, permitting users to select a single channel. The list of channels are filtered based on previously chosen specifics. If no channels match user selections, a placeholder view prompts users to revert and reset their specific choices.
3. Campaigns: Featuring a CollectionView, this screen allows users to pick a campaign. They can also revert and reset channel selection using a dedicated button. After selecting a campaign, users are directed to the next screen. The campaign list filters according to the previously chosen channel.
4. Campaign Review: This final screen presents detailed information about the selected campaign. Users can proceed to send an email requesting more details. Once the email dispatches, users return to the initial screen, with all previous selections reset.

For this project, I adopted diverse layout loading techniques - using XIB, RxCocoa, and programmatic constraints. While this may seem unconventional, my objective was to demonstrate versatility across varied methods. Typically, in a mainstream project, adhering to a singular standard and architectural pattern is essential..

Please note, due to specific Xcode configuration constraints, I recommend employing an Xcode version post 14 for optimal performance.

Thanks in advance.
