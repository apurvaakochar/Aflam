# Aflam

Aflam is an iOS Application (iOS > 9.0) which retrieves a list of movies when a keyword is queried.

### UI

The app comprises of three views: **Feed**,  **Suggestions** and **Details**.

• Feed displays the movie list of the query made in a vertical flow

• It displays the poster, title and the release date

• It loads the next page, if available for the movie when the bottom of feed is reached

• The items in the cells are in autolayout, maintaining an aspect ratio of 2:3 for the poster

• On being tapped, it takes to the Details view of the movie where the poster is shown with the overview

• The overview text is vertically scrollable 

• The overview is show in a separate view so as to not make the feed too dense

• An Alert View is shown to address error scenarios

• When the user taps the search controller, a list of last ten successful searches appear

• On tapping, any suggestion, the movie list corresponding to the suggestion appears

• The suggestions are continuously filtered, depending on what the user is typing

• Alternatively the user can type and hit the search button 

• For iOS 11 and greater, the search controller is embedded in the navigationItem

• For other versions, it is embedded inside the tableView’s Header View

### Architecture

• MVVM was used

• Closures were used for Observer Mechanism

• Interactor is bound with the View Controller and handles the non UI Logic 

• Interactor is divided into Business and Presentation Logic

### Unit Tests

• Tested the Asynchronous fetching request

• Tested Data Model

• Tested date retrieval from Realm

### Libraries

[Kingfisher](https://github.com/onevcat/Kingfisher)
This was used for image cache management and async fetching from the URL

[Alamofire](https://github.com/Alamofire/Alamofire)
This was used for Networking

[RealmSwift](https://realm.io/docs/swift/latest)
Realm was used to manage the temporary data storage

**Screenshots are uploaded to the repository**
**The code is thoroughly documented for any further clarifications**

**Apurva Kochar**
