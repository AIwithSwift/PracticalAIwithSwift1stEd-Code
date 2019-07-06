# NSTDemo

## Toolkit

| Category | Details |
|:---|:---|
| Input Data | Public Domain images from Pixabay ([abstract](https://pixabay.com/illustrations/texture-abstract-structure-color-1909992/), [apples](https://pixabay.com/photos/apples-jonagold-healthy-food-490474/), [bricks](https://pixabay.com/photos/wall-stones-hauswand-structure-450106/), [flowers](https://pixabay.com/photos/hydrangea-flower-nature-beautiful-3659614/), [foliage](https://pixabay.com/photos/fall-foliage-autumn-leaves-october-111315/), [honeycomb](https://pixabay.com/photos/beehive-bees-honeycomb-honey-bee-337695/), [mosaic](https://pixabay.com/photos/mosaic-tiles-pattern-texture-3394375/), [nebula](https://pixabay.com/illustrations/universe-sky-star-space-cosmos-2742113/)), plus a mass of general images from something like the  [COCO Dataset](http://cocodataset.org/#home) or your own photographs |
| Training | Turi-Create, Python |
| App UI | UIKit |
| Assets | Images photoshopped together to create App Icon ([1](https://en.wikipedia.org/wiki/File:Tsunami_by_hokusai_19th_century.jpg), [2](https://commons.wikimedia.org/wiki/File:Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg)) |
| Integration Difficulty | Advanced |

## Modifications

Original app just offers options to flip or rotate images. AI will introduce style conglomeration of two images.

**To get from Starter to Complete**:

1. Add .mlmodel file you have trained
2. Add step into ViewController that resizes input image as per TuriCreate export image constraints
3. Add properties to StyleModel enum, change cases to match
4. Change body of function `styled(with:)` in Image file