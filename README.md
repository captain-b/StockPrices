# StockPrices

This project retrieves live company stock information and prices from FinnHub, and displays them in a table view cell. Users may tap any of the table view cells to view more information about the company and the actual stock price. SwiftUI is avoided throughout the project in order to make the app compatible with older versions of iOS. UIKit is used instead.

## TODO:
- There are a lot of forced unwrappings. Alternatives must be setup incase a value is unexpectedly returned as nil.
- Although it's not required for a simple project like this, ideally our view controllers should be placed in a navigation controller.
- There is no way to natively display SVG files in iOS. FinnHub's API also returns an SVG file that is corrupt and cannot be displayed in iOS using third party libraries. Stock images have been imported manually for now, but we need to figure out a way to either A) Replace our image view with a web view in order to display the SVG file in an in-app browser or B) Use a third party API to convert our SVG image to a PNG image.
- We could add a protocol to let us know when a API call starts and ends, in order to display a loading animation any given view controller.
- Errors aren't being handled in the best way. At this time, the app only displays a localised description of the error. Ideally we would create custom error classes to make sure we display more appropriate messages to the user. This will allow us to debug the app during production.
