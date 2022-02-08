# Word Scramble


<!-- Table of Contents -->
## Table of Contents
* [About The Project](#about-the-project)
* [Concepts Utilized](#concepts-utilized)
* [Screenshots](#screenshots)
* [Acknowledgements](#acknowledgements)


<!-- ABOUT THE PROJECT -->
## About The Project

Word Scramble is an app that asks users to make words with the letters of a given word (i.e. make anagrams out of a word).

#### [Challenges](https://www.hackingwithswift.com/read/5/7/wrap-up)
>1. Disallow answers that are shorter than three letters or are just our start word. For the three-letter check, the easiest thing to do is put a check into isReal() that returns false if the word length is under three letters. For the second part, just compare the start word against their input word and return false if they are the same.
>2. Refactor all the else statements we just added so that they call a new method called showErrorMessage(). This should accept an error message and a title, and do all the UIAlertController work from there.
>3. Add a left bar button item that calls startGame(), so users can restart with a new word whenever they want to.
>
>Bonus: Once you’ve done those three, there’s a really subtle bug in our game and I’d like you to try finding and fixing it.
>
>To trigger the bug, look for a three-letter word in your starting word, and enter it with an uppercase letter. Once it appears in the table, try entering it again all lowercase – you’ll see it gets entered. Can you figure out what causes this and how to fix it?

<p align="right">(<a href="#top">back to top</a>)</p>


<!-- CONCEPTS UTILIZED -->
## Concepts Utilized
* UITableView (reloading table view data and inserting rows)
* UIAlertController (accepting user input)
* Strings & UTF-16
* Closures
* NSRange
* Capture Lists

<p align="right">(<a href="#top">back to top</a>)</p>


<!-- SCREENSHOTS -->
## Screenshots
In Progress

<p align="right">(<a href="#top">back to top</a>)</p>


<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements
Hacking With Swift - [100 Days of Swift] by Paul Hudson

Project 5 - Word Scramble is coded in correspondence to the following days:
* [Day 27]
* [Day 28]
* [Day 29] - Challenge Day

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[100 Days of Swift]: https://www.hackingwithswift.com/100 (100 Days of Swift)
[Day 27]: https://www.hackingwithswift.com/100/27
[Day 28]: https://www.hackingwithswift.com/100/28
[Day 29]: https://www.hackingwithswift.com/100/29
