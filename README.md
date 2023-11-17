# Fall Ball 🎱

Fall Ball is an IOS game written in Swift. The objective for the player is to swipe up as fast as possible. 

## Code Break Down 👨‍💻

The entire game is a custom vertical tabview wrapped in a scrollview. A ball animation is overlayed on every color tab and only the current tab that the player is on is displayed. This creates the illusion of a falling ball.

### Important Code References 📖
* [ContentView](https://github.com/we-z/endlessfall/blob/main/endlessfaller/Views/ContentView.swift) (Main File)
* [Leaderboard](https://github.com/we-z/endlessfall/blob/main/endlessfaller/Views/GameCenterLeaderboardView.swift)
* [Ball Shop](https://github.com/we-z/endlessfall/blob/main/endlessfaller/Views/CharactersMenuView.swift)
* [Secret Shop](https://github.com/we-z/endlessfall/blob/main/endlessfaller/Views/SecretShopView.swift)
* [AppModel](https://github.com/we-z/endlessfall/blob/main/endlessfaller/Configs/AppModel.swift) (user data and more)
* [in game currency](https://github.com/we-z/endlessfall/blob/main/endlessfaller/Views/CurrencyPageView.swift) (Boins Menu)
* [GameKit Boiler code](https://github.com/we-z/endlessfall/blob/main/endlessfaller/Configs/GameCenter.swift)
* [StoreKit Boiler code](https://github.com/we-z/endlessfall/blob/main/endlessfaller/Configs/StoreKitManager.swift)
* [Skins designs File](https://github.com/we-z/endlessfall/blob/main/endlessfaller/Views/CharactersDesignsView.swift)
* [Animations File](https://github.com/we-z/endlessfall/blob/main/endlessfaller/Views/AnimationsView.swift)


### Upcoming Features 🚀
* Add hats to leaderboard
* Battle Royale
* Custom Trail effects
