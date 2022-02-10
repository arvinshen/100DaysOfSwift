# Shopping List


<!-- Table of Contents -->
## Table of Contents
* [About The Project](#about-the-project)
* [Screenshots](#screenshots)
* [Acknowledgements](#acknowledgements)


<!-- ABOUT THE PROJECT -->
## About The Project

Shopping List is an app that lets users add items to create a shopping list.

#### [Challenges](https://www.hackingwithswift.com/guide/3/3/challenge)
>It’s time to put your skills to the test by making your own complete app from scratch. This time your job is to create an app that lets people create a shopping list by adding items to a table view.
>
>The best way to tackle this app is to think about how you build project 5: it was a table view that showed items from an array, and we used a UIAlertController with a text field to let users enter free text that got appended to the array. That forms the foundation of this app, except this time you don’t need to validate items that get added – if users enter some text, assume it’s a real product and add it to their list.
>
>For bonus points, add a left bar button item that clears the shopping list – what method should be used afterwards to make the table view reload all its data?
>
>Here are some hints in case you hit problems:
>
>- Remember to change ViewController to build on UITableViewController, then change the storyboard to match.
>- Create a shoppingList property of type [String] to hold all the items the user wants to buy.
>- Create your UIAlertController with the style .alert, then call addTextField() to let the user enter text.
>- When you have a new shopping list item, make sure you insert() it into your shoppingList array before you call the insertRows(at:) method of your table view – your app will crash if you do this the wrong way around.
>
>You might be tempted to try to use UIActivityViewController to share the finished shopping list by email, but if you do that you’ll hit a problem: you have an array of strings, not a single string.
>
>There’s a special method that can create one string from an array, by stitching each part together using a separator you provide. I’ll be going into it in project 8, but if you’re keen to try it now here’s some code to get you started:
>
>```swift
>let list = shoppingList.joined(separator: "\n")
>```
>
>That will create a new list constant that is a regular string, with each shopping list item separated by “\n” – that’s Swift’s way of representing a new line.

<p align="right">(<a href="#top">back to top</a>)</p>


<!-- SCREENSHOTS -->
## Screenshots
In Progress

<p align="right">(<a href="#top">back to top</a>)</p>


<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements
Hacking With Swift - [100 Days of Swift] by Paul Hudson

Consolidation 2: Projects 4-6 - Shopping List is coded in correspondence to the following days:
* [Day 32] - Challenge Day

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[100 Days of Swift]: https://www.hackingwithswift.com/100 (100 Days of Swift)
[Day 32]: https://www.hackingwithswift.com/100/32
