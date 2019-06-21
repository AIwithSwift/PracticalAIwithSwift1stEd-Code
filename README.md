# PracticalAIwithSwift1stEd-Code
Code for the book's first edition.

| Directory | App | Chapter | Notes |
|:---|:---:|:---:|:---|
|Chapter06-ImageClassifier | ✅ | ✅ | Chapter needs theory at end, and maybe roll in Object Detection |
|Chapter07-ActivityClassifier | ✴️ | ⛔️ | Being made by Mars (Speech Synthesis to say classifications?) |
|Chapter08-SoundClassifier | ✅ | ✅ | Chapter needs theory at end, and app needs functionality to request permission to record (init request and plist values), needs constraints adjustment on CollectionView tiles |
|Chapter09-SentimentAnalyser | ✅ | ✅ | Chapter needs theory at end |
|Chapter10-ImageComparer | ✅ | ⛔️ | Ready for writing with Paris. App needs bug fixes (**SwiftUI Issues: Text() resizing on binding change, Image() views ignore aspectRatio() setting**) |
|Chapter11-StyleTransferer | ✅ | ✴️ | Chapter in Progress with Paris; model in Progress with Paris |
|Chapter13-Recommender| ⛔️ | ⛔️ | To be made by Mars. Potential datasets: https://grouplens.org/datasets/hetrec-2011/ |
|Chapter14-DrawingDetector | ✴️ | ⛔️ | Being made by Mars. Stage one: scan in photo, adapt to grayscale image using methods from DocumentDetector in Ch17. Stage two: draw in app with stroke detection. [Turi docs](https://apple.github.io/turicreate/docs/userguide/drawing_classifier/) |
|Chapter15-SpeechRecognizer | ✅ | ✅ | Chapter needs extension into training custom models/augmenting with domain-specific terminology  |
|Chapter16-SwiftForTensorflow | ✴️ | ⛔️ | Being made by Paris |
|Chapter17-FaceDetector | ✅ | ⛔️ | Ready for chapter with Paris, possibly rolled in with other Still Image tasks. Writeup should mention other types of detectors Apple has, such as [animals](https://developer.apple.com/documentation/vision/vnanimaldetector) and [whole human figures](https://developer.apple.com/documentation/vision/vndetecthumanrectanglesrequest). Apple's overview of what is possible is [here](https://developer.apple.com/documentation/vision/detecting_objects_in_still_images). |
|Chapter17-Rectangle/Barcode/QRCode detector | ✴️| - | Being made by Mars, and applied further in DrawingDetector. |
|Chapter17-Other| - | - | Detecting Text, [Cropping with Saliency](https://developer.apple.com/documentation/vision/cropping_images_using_saliency)? |
| ? (video analysis) | - | - | ARKit? Still image analysis correlation between frames (VNTrackingRequest)? [Face Tracking](https://developer.apple.com/documentation/vision/tracking_the_user_s_face_in_real_time) |
| ChapterXX-NaturalLanguage ) | ⛔️ | ⛔️ | To be made by Paris. Suggestions: [detecting people, places, organisations](https://developer.apple.com/documentation/naturallanguage/identifying_people_places_and_organizations), and [parts of speech](https://developer.apple.com/documentation/naturallanguage/identifying_parts_of_speech), [determining what language text is](https://developer.apple.com/documentation/naturallanguage/nllanguagerecognizer), [tokenizing sentences](https://developer.apple.com/documentation/naturallanguage/tokenizing_natural_language_text) (MAYBE this one isn't AI so we could skip and just mention it in the text?), [word embedding](https://developer.apple.com/documentation/createml/mlwordembedding) ([and NLEmbedding](https://developer.apple.com/documentation/naturallanguage/nlembedding))(interesting, but maybe too esoteric to cover? definitely AI though and even uses CreateML classes.. interesting from the perspective of [calculating the distance between strings](https://developer.apple.com/documentation/naturallanguage/nlembedding/3200310-distance))  |
| ? (coremltools Task) | - | - | To be made by Mars. |
| ? (Retraining on device Task) | - | - | [This seems quite fiddly](https://developer.apple.com/documentation/coreml/mlupdatetask) |


## Other things to look at

* TBD