# Hacking With Swift - 100 Days of Swift

## Table of Contents
* [General Info](#general-info)
* [Projects](#projects)
* [Consolidation Projects](#consolidation-projects)

## General Info
A free education program to learn Swift over 100 days building real iOS apps.

* Disclosure: iPhone X<sub>R</sub> is the default device used for the UI layout. Early projects' UI layout are not dynamic and may break the app's functionality if other devices are used and/or orientation is changed.

## Projects:

### P1: Storm Viewer - app that lets users scroll through lists of images, then select one to view.

Focused Topics: Table views, image views, app bundles, FileManager, typecasting, view controllers, storyboards, outlets, Auto Layout, and loading images as UIImage, etc.

### P2: Guess The Flag - game that shows the name of a country with several random flags to users and asks the player to choose the correct flag belonging to that particular country named.

Focused Topics: Asset catalogs, buttons, colors, @IBAction, UIAlertController, etc.

### P3: Project 1 Update to add share/save image function via UIActivityViewController.

Focused Topics: Navigation bar, UIBarButtonItem and UIActivityViewController.

### P4: Web Browser - simple app that allows users to browse the web.

Focused Topics: WKWebView, loadView(), action sheets, delegation, URL, URLRequest, UIToolbar, UIProgressView, key-value observing, etc.

### P5: Word Scramble - app that asks users to make words with the letters of a given word (i.e. make anagrams out of a word).

Focused Topics: UITableView (reloading table view data and insert rows), UIAlertController (accepting user input), Strings & UTF-16, closures, NSRange, and capture lists.

### P6: 
* a. Project 2 Update to fix app in landscape mode using Auto Layout.
* b. Simple app where we create views by hand and position them using Auto Layout.

Focused Topics: Auto Layout (metrics, priorities, Visual Formatting Language, anchors).

### P7: Whitehouse Petitions - app that shows the Whitehouse petitions in the US.

Focused Topics: Downloading/parsing JSON with Data, Codable, UITabBarController, UIStoryBoard
* Note: Added a dynamic filtering search bar using UISearchController and UISearchBar to improve the functionality of Project 7 Challenge #2 (Not taught in Hacking With Swift up to this point).

### P8: Swifty Words - word game app based on the popular indie game 7 Little Words.

Focused Topics: Building iOS layouts programmatically using UIKit (e.g. UILabel, UIButton, UITextField, NSLayoutConstraint.activate(), safeAreaLayoutGuide, layoutMarginsGuide, etc.), enumerated(), joined(), replacingOccurrences(), and more. 

### P9: Project 7 Update to download/parse JSON data asynchronously with the user interface.

Focused Topics: Grand Central Dispatch, performSelector(), Quality of Service
* Note: P9 Challenges 1, 2, 3 modifies P1, P8, P7 respectively.

### P10: Names to Faces - app to help remember the names and faces of people met.

Focused Topics: UICollectionView, UIImagePickerController, UUID, NSObject subclases, fatalError()
* Note: P10 Challenge 3 modifies a copy of P1 to use a collection view controller rather than a table view controller.

### P11: Pachinko - a simple game app based on Pachinko

Focused Topics: SpriteKit, physics, blend modes, radians and CGFloat.

### P12: Project 10 Update to fix bug where names/faces added to app don't get saved.

Focused Topics: UserDefaults (saving data and user settings / backups and restores data), NSCoding, Codable
* Note: P12 Challenge 1, 2, 3 modifies copies of P3, P6, P5 respectively.

## Consolidation Projects:
Challenge/Milestone projects that cover multiple projects and the topics learned.

### C1 (Consolidation of P1-3): Flag Viewer - app that lists names and images of country flags created using TableViews, that when selected will view the flag in larger detail in another ViewController and have the functionality to share the image using UIActivityViewController.

### C2 (Consolidation of P4-6): Shopping List - app that lets you add items to create a shopping list.

### C3 (Consolidation of P7-9): Hangman - app to play the guessing game, Hangman.
