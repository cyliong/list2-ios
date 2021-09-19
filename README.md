# list2-ios
This is a simple list mobile app (to-do list, tasks, shopping list, recipes, and the like) showcasing the implementation of CRUD operations, built with SwiftUI for the iOS platform.

iOS 13.1 or higher is required to run the app. If there is a need to support earlier versions of iOS, refer to a similar project, [list-ios](https://github.com/cyliong/list-ios).

## Features
- Display a list of items (`List`, Realm `Results`)
- Navigate to a page to add or edit items (`NavigationLink`, custom view with `Form` and `TextField`)
- Swipe to delete items (`onDelete(perform:)`)
- Store items in database using data model (Realm `Object`)

## Dependencies
- Realm Database

## Requirements
- Xcode 12.5.1 or higher
- CocoaPods 1.11.1 or higher
- iOS 13.1 or higher
- Swift 5 or higher

## Setup
1. Open **Terminal** and navigate to your project directory by using the `cd` command.
2. Run `pod install` command.
3. Open `List2.xcworkspace` in Xcode.
