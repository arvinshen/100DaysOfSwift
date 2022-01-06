# Hacking With Swift - 100 Days of Swift

## Table of Contents
* [General Info](#general-info)
* [Projects](#projects)
* [Consolidation Projects](#consolidation-projects)

## General Info
A free education program to learn Swift over 100 days building real iOS apps.

* Disclosure: iPhone X<sub>R</sub> is the default device used for the UI layout. Early projects' UI layout are not dynamic and may break the app's functionality if other devices are used and/or orientation is changed. Projects 1-12 challenges completed on original while challenges for projects 13 and onward are done on a copy of the project.

## Projects:

### P1: Storm Viewer
App that lets users scroll through lists of images, then select one to view.

Focused Topics: Table views, image views, app bundles, FileManager, typecasting, view controllers, storyboards, outlets, Auto Layout, and loading images as UIImage, etc.

### P2: Guess The Flag
Game that shows the name of a country with several random flags to users and asks the player to choose the correct flag belonging to that particular country named.

Focused Topics: Asset catalogs, buttons, colors, @IBAction, UIAlertController, etc.

### P3: Social Media
Project 1 Update to add share/save image function via UIActivityViewController.

Focused Topics: Navigation bar, UIBarButtonItem and UIActivityViewController.

### P4: Web Browser
Simple app that allows users to browse the web.

Focused Topics: WKWebView, loadView(), action sheets, delegation, URL, URLRequest, UIToolbar, UIProgressView, key-value observing, etc.

### P5: Word Scramble
App that asks users to make words with the letters of a given word (i.e. make anagrams out of a word).

Focused Topics: UITableView (reloading table view data and insert rows), UIAlertController (accepting user input), Strings & UTF-16, closures, NSRange, and capture lists.

### P6: Auto Layout
* a. Project 2 Update to fix app in landscape mode using Auto Layout.
* b. Simple app where we create views by hand and position them using Auto Layout.

Focused Topics: Auto Layout (metrics, priorities, Visual Formatting Language, anchors).

### P7: Whitehouse Petitions
App that shows the Whitehouse petitions in the US.

Focused Topics: Downloading/parsing JSON with Data, Codable, UITabBarController, UIStoryBoard
* Note: Added a dynamic filtering search bar using UISearchController and UISearchBar to improve the functionality of Project 7 Challenge #2 (Not taught in Hacking With Swift up to this point).

### P8: Swifty Words
Word game app based on the popular indie game 7 Little Words.

Focused Topics: Building iOS layouts programmatically using UIKit (e.g. UILabel, UIButton, UITextField, NSLayoutConstraint.activate(), safeAreaLayoutGuide, layoutMarginsGuide, etc.), enumerated(), joined(), replacingOccurrences(), and more. 

### P9: Grand Central Dispatch
Project 7 Update to download/parse JSON data asynchronously with the user interface.

Focused Topics: Grand Central Dispatch, performSelector(), Quality of Service
* Note: P9 Challenges 1, 2, 3 modifies P1, P8, P7 respectively.

### P10: Names to Faces
App to help remember the names and faces of people met.

Focused Topics: UICollectionView, UIImagePickerController, UUID, NSObject subclases, fatalError()
* Note: P10 Challenge 3 modifies a copy of P1 to use a collection view controller rather than a table view controller.

### P11: Pachinko
A simple game app based on Pachinko

Focused Topics: SpriteKit, physics, blend modes, radians and CGFloat.

### P12: UserDefaults
Project 10 Update to fix bug where names/faces added to app don't get saved.

Focused Topics: UserDefaults (saving data and user settings / backups and restores data), NSCoding, Codable
* Note: P12 Challenge 1, 2, 3 modifies copies of P3, P6a, P5 respectively.

### P13: Instafilter
App that allows users to choose a photo from their album, change and apply filters, and save the processed image back to photo album.

Focused Topics: Core Image, UISlider, and Writing images to iOS photo album.

### P14: Whack-a-Penguin
App to play a game inspired by whack-a-mole.

Focused Topics: SKCropNode, SKTexture, asyncAfter(), New SKAction types

### P15: Animation
App that performs animations when a button is tapped (sandbox for coding animations).

Focused Topics: Core Animation, animate(withDuration:), Spring animations, Alpha values, CGAffineTransform
* Note: P15 Challenge 1, 2, 3 modifies copies of P8, P13, P6a respectively.

### P16: Capital Cities
App that shows information about capital cities that have placemarks on the map.

Focused Topics: MapKit, MKMapView, MKAnnotation, MKPinAnnotationView, CLLocationCoordinate2D

### P17: Space Race
Simple survival game where the player pilots a spaceship through fields of space junk.

Focused Topics: Per-pixel collision detection, advanced particle systems, Timer, linear and angular damping

### P18: Debugging
Throwaway sandbox code going over debugging tools.

Focused Topics: print(), assert(), Breakpoints (exception & conditional breakpoints), View debugging
* Note: P18 Challenge 1 & 2 adds exception breakpoint and assert() respectively; Challenge 3 adds conditional breakpoint.


### P19: JavaScript Injection
A Safari extention which embeds a version of the app directly inside Safari's action menu, then manipulate Safari data (Capable of reading the URL and page title of the website the user visited, then show a large text area they can type JavaScript into and when extension is dismissed, it'll execute that JavaScript in Safari.)

Focused Topics: Extensions, NotificationCenter class, UITextView, and building a bridge between JavaScript and Swift functionalities.

### P20: Fireworks Night
Game where players will need to select and detonate groups of fireworks of the same color, which means tapping and swiping around the screen.

Focused Topics: follow(), UIBezierPath, for case let, Color blending, Shake gesture

## Consolidation Projects:
Challenge/Milestone projects that cover multiple projects and the topics learned.

### C1 (Consolidation of P1-3): Flag Viewer
App that lists names and images of country flags created using TableViews, that when selected will view the flag in larger detail in another ViewController and have the functionality to share the image using UIActivityViewController.

### C2 (Consolidation of P4-6): Shopping List
App that lets you add items to create a shopping list.

### C3 (Consolidation of P7-9): Hangman
App to play the guessing game, Hangman.

### C4 (Consolidation of P10-12): Photo Caption View
App that lets users take and save pictures, add captions and view them in a table view. Tapping the caption shows the picture in a new view controller.

### C5 (Consolidation of P13-15): CountryDB (Country Database)
App that lists countries that when selected will show detailed information about the country.

### C6 (Consolidation of P16-18): Ghost Pac Hunt
Shooting gallery type game to help Pac-man by shooting the ghosts. 
