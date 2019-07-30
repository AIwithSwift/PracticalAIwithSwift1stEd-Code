# PracticalAIwithSwift1stEd-Code
Code for the book's first edition!

| Directory | App | Chapter | Notes |
|:---|:---:|:---:|:---|
|Chapter06-ImageClassifier | ✅ | ✅ | Chapter needs theory at end. |
|Chapter07-ActivityClassifier | ✴️ | ✴️ | Stage one complete. Stage two being made by Paris! Stage three to be made by Mars afterwards (awaiting Paris).|
|Chapter08-SoundClassifier | ✴️ | ✅ | Chapter needs theory at end. **App needs functionality to request permission to record (init request and plist values).**  |
|Chapter09-SentimentAnalyser | ✅ | ✅ | Chapter needs theory at end. |
|Chapter10-ImageComparer | ✅ | ✅ | Chapter needs theory at end. |
|Chapter11-StyleTransferer | ✅ | ✅ | Chapter needs theory at end. |
|Chapter13-Recommender| ✴️ | ⛔️ | Being made by Mars. Model retraining to be discussed in this, [it seems quite fiddly](https://developer.apple.com/documentation/coreml/mlupdatetask). Potential dataset [here](https://grouplens.org/datasets/hetrec-2011/).  |
|Chapter14-DrawingDetector | ✴️ | ⛔️ | Awaiting write-up with Paris. |
|Chapter15-SpeechRecognizer | ✅ | ✴️ | Chapter needs extension into training custom models/augmenting with domain-specific terminology.  |
|Chapter16-SwiftForTensorflow | ✴️ | ⛔️ | Being made by Paris. |
|Chapter17-ObjectDetector| ✅ | ✴️ | Chapter in progress with Paris. Chapter should cover both specific FaceDetector example and general Still Image tasks/inbuilt capabilities of Vision. Writeup should mention other types of detectors Apple has, such as [animals](https://developer.apple.com/documentation/vision/vnanimaldetector) and [whole human figures](https://developer.apple.com/documentation/vision/vndetecthumanrectanglesrequest). Apple's overview of what is possible is [here](https://developer.apple.com/documentation/vision/detecting_objects_in_still_images), which should be referenced when talking about detecting rectangles or barcodes. Part of chapter with above. Documentation to refer to in discussion (at least): [Cropping with Saliency](https://developer.apple.com/documentation/vision/cropping_images_using_saliency), [VNBarcodeObservation supportedSymbologies](https://developer.apple.com/documentation/vision/vnbarcodesymbology),  [VNBarcodeObservation payloadStringValue](https://developer.apple.com/documentation/vision/vnbarcodeobservation/2923485-payloadstringvalue). |
| ChapterXX-VideoAnalyser | ✴️ | ⛔️ | Paris looking at. ARKit + still image analysis correlation between frames (VNTrackingRequest). See: [Face Tracking](https://developer.apple.com/documentation/vision/tracking_the_user_s_face_in_real_time). |
| ChapterXX-NaturalLanguage ) | ✴️ | ⛔️ | Code in progress with Paris. Suggestions: **Detecting Text in images using Vision** (tie back into Ch17), [detecting people, places, organisations](https://developer.apple.com/documentation/naturallanguage/identifying_people_places_and_organizations), and [parts of speech](https://developer.apple.com/documentation/naturallanguage/identifying_parts_of_speech), [determining what language text is](https://developer.apple.com/documentation/naturallanguage/nllanguagerecognizer), [tokenizing sentences](https://developer.apple.com/documentation/naturallanguage/tokenizing_natural_language_text) (MAYBE this one isn't AI so we could skip and just mention it in the text?), [word embedding](https://developer.apple.com/documentation/createml/mlwordembedding) ([and NLEmbedding](https://developer.apple.com/documentation/naturallanguage/nlembedding))(interesting, but maybe too esoteric to cover? definitely AI though and even uses CreateML classes.. interesting from the perspective of [calculating the distance between strings](https://developer.apple.com/documentation/naturallanguage/nlembedding/3200310-distance))  |
| ChapterXX-Generator | ✴️ | ⛔️ | Markov Chain example complete. GAN example being made by Mars. MLRegressor example to be made by Mars. |

## TODO (not preventing tech review)

* Add to “finding or building a dataset”: 1. Some practical code snippets for bits that are there (scripts to build simple datasets, some api libraries in Swift, etc). 2. Using someone else’s by just converting an existing model with CoreMLtools. 
* **All SwiftUI apps** need bugfixes for: randomly resizing Text() elements, and aspectRatio(contentMode:)-ignoring Image() elements
* **DDDemo apps** need a working model or debugging to figure out why everything is sandwich.
* **NSTDemo apps** need a better model.
* **SCDemo apps** need constraints adjustments on CollectionView tiles.
* Restructure directories to match book!
* App Icons, launch screens, nice demo names!
* Credits for all assets!
* Code consistency, documentation and polish!
