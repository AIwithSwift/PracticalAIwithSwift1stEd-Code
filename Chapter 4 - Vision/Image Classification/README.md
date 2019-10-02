# ICDemo

| Category | Details |
|:---|:---|
| Input Data | [Fruits-360: A dataset of images containing fruits](https://github.com/Horea94/Fruit-Images-Dataset) |
| Training | CreateML App |
| App UI | UIKit |
| Assets | [App Icon](https://pixabay.com/photos/fruit-basket-grapes-apples-pears-1114060/), [Launch Screen Image](https://pixabay.com/photos/fruit-vegetables-market-428057/) |
| Integration Difficulty | Moderate |

## Modifications

Original app just thinks all images are "Fruit". AI will introduce image analysis that will attempt to correctly identify fruit as one of over 100 types it knows.

**To get from Starter to Complete**:

1. Add .mlmodel file you have trained
2. Add wrapper class that hands off classification to DispatchQueue
3. Initialise classifier instance, set delegate to self and store in ViewController to respond to
4. Replace body of `classifyImage()` function in ViewController file