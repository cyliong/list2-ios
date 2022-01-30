# list2-ios
This is a simple iOS list app 
(to-do list, tasks, shopping list, recipes, and the like) 
built with SwiftUI, showcasing the implementation of CRUD operations 
with DAO pattern.

iOS 14 or higher is required to run the app. 
If there is a need to support earlier versions of iOS, 
refer to a similar project, 
[list-ios](https://github.com/cyliong/list-ios).

## Features
- Display a list of items (`List`, `ForEach`)
- Navigate to a page to add or edit items 
  (`NavigationLink`, custom view with `Form` and `TextField`)
- Swipe to delete items (`onDelete(perform:)`)
- Store items in database (DAO, SQLite)

## Data Access Layer
The project implements a data access layer 
with the Data Access Object (DAO) pattern. 
It uses generics, inheritance and Singleton pattern 
to make the creation of data access objects, 
as well as performing CRUD operations easier.

*If you are looking for an alternative database option 
other than SQLite, check out the integration of SwiftUI and Realm 
on the [realm](https://github.com/cyliong/list2-ios/tree/realm) branch.*

## Widget
This project also implements a widget that can be added to 
the Home screen, with the following features:
- Display a list of items from a database shared between 
  the app and widget (SQLite database stored in an App Group container)
- Tap the widget to launch the app
- For medium and large widgets: 
  - Tap the Add button to launch the app's New Item screen 
    (Deep linking with a `Link` control, `onOpenURL(perform:)`, 
    `NavigationLink(destination:isActive:)`)
  - Tap a list item to launch the app's Edit Item screen 
    (Deep linking with `Link` controls, `onOpenURL(perform:)`, 
    `NavigationLink(destination:tag:selection:)`)
- Widget will be updated when list items are modified from the app 
  (using `WidgetCenter`'s `reloadTimelines(ofKind:)`)

## UI Testing
The project includes a sample implementation of UI test 
using the XCTest framework.

## Dependencies
- FMDB

## Requirements
- Xcode 13.2.1 or higher
- iOS 14 or higher
- Swift 5 or higher
