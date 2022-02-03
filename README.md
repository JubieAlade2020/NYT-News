# NYT-News
This is an app that uses the New York Times API to display the top news stories for a given category. 

## Resources Used
* [New York Times API documentation](https://developer.nytimes.com/apis)
* [Kingfisher library for downloading and caching images from the web](https://github.com/onevcat/Kingfisher)

### Future Iterations
1. I would like to implement the pull-to-refresh feature and get rid of the refresh button.
2. I display a progress indicator when data is being fetched from the API, but I would like to display another indicator for when images are being downloaded by Kingfisher.
3. I would like to implement more tests, but hopefully the ones I provided demonstrate my understanding of writing iOS tests.

### Worth Noting
The New York Times API has a rate limit of 4,000 requests a day (about 10 a minute). If you hit the rate limit in the app, articles will not be fetched and an alert will be displayed. 

### Thank You!
Thank you for taking the time to review my app! I'm proud of what I was able to accomplish, but I'm always looking for ways to improve. Please feel free to leave feedback regarding areas that need improvement. 
