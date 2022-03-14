# The christian Knedel landing page, built using Hugo.
First of all, thanks for contributing to the christian-knedel.de website! We're happy you've decided to help up make our site & its content better, and we hope you'd like to keep doing so in the future.

Content/Post: https://github.com/ChristianKnedel/knedelverse/tree/main/content/post


## Build image
```
docker build -t hugoservice .
```

## Start the Development Server
```
docker run --rm -v /Users/christianknedel/NetBeansProjects/knedelverse:/hugo -p 1313:1313 hugoservice hugo server -w --bind=0.0.0.0
```

## Contributing
We welcome your contributions! Please refer to our contributing policies prior to submitting pull requests.