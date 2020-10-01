# list2-ios
This is a simple iOS list app (to-do list, tasks, shopping list, recipes, and the like) built with SwiftUI,
showcasing the implementation of CRUD operations with DAO pattern.

iOS 13.1 or higher is required to run the app. If there is a need to support earlier versions of iOS, refer to a similar project, [list-ios](https://github.com/cyliong/list-ios).

## Features
- Display a list of items (`List`, `ForEach`)
- Navigate to a page to add or edit items (`NavigationLink`, custom view with `Form` and `TextField`)
- Swipe to delete items (`onDelete(perform:)`)
- Store items in database (DAO, SQLite)

## Data Access Layer
The project implements a data access layer with the Data Access Object (DAO) pattern. 
It uses generics, inheritance and Singleton pattern to make the creation of data access objects, as well as performing CRUD operations easier.

*If you are looking for an alternative database option other than SQLite, 
check out the the integration of SwiftUI and Realm 
on the [realm](https://github.com/cyliong/list2-ios/tree/realm) branch.*

## Widget
This project also implements a widget that can be added to the Home screen.

An App Group container is created to share data between the app and the widget.

In addition, `WidgetCenter` is used to reload widgets when the app updates its data.

## Dependencies
- FMDB

## Requirements
- Xcode 12 or higher
- iOS 13.1 or higher (Widget is supported by iOS 14 or higher)
- Swift 5 or higher
