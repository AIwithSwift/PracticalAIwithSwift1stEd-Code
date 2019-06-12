# NSTDemo

## Toolkit

| Category | Details |
|:---|:---|
| Input Data | Public Domain images from Pixabay and our own photographs |
| Training | Turi-Create, Python |
| App UI | UIKit |
| Assets | Images photoshopped together to create AppIcon ([1](https://en.wikipedia.org/wiki/File:Tsunami_by_hokusai_19th_century.jpg), [2](https://commons.wikimedia.org/wiki/File:Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg)) |
| Integration Difficulty | Advanced |

## Modifications from Starter to Complete

1. Add .mlmodel file
2. Add step into ViewController that resizes input image as per TuriCreate export image constraints
3. Add properties to StyleModel enum, change cases to match
4. Change body of function `styled(with:)` in Image file