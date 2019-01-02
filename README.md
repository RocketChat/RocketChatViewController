# RocketChatViewController

RocketChatViewController is a Swift library that Rocket.Chat created to facilitate other native apps to have a chat screen inside their applications. The library helps other developers maintaining a list of messages, updating it and also having a composer element to write new messages with many facilities, such as autocomplete, editing and customizable actions.

We're using RocketChatViewController in our [iOS application](https://github.com/RocketChat/Rocket.Chat.iOS) for a while now so it's very stable and you can already use it in your iOS app.

The architecture of the list is purely inspired in [IGListKit](https://github.com/Instagram/IGListKit) and depends on [DifferenceKit](https://github.com/ra1028/DifferenceKit) library to run the differences on the list elements. The whole list is complete `UIKit` based and works on top of a `UICollectionView`.

## Creators

- [@cardoso](https://github.com/cardoso)
- [@filipealva](https://github.com/filipealva)
- [@rafaelks](https://github.com/rafaelks)
