# NLPDemo


| Category | Details |
|:---|:---|
| Input Data | [Epinions.com dataset from Carnegie Mellon](http://boston.lti.cs.cmu.edu/classes/95-865-K/HW/HW3/) |
| Training | CreateML, Playgrounds |
| App UI | UIKit |
| Assets | [App Icon](https://pixabay.com/photos/carnival-fasnet-swabian-alemannic-2092819/) |
| Integration Difficulty | Easy |

## Modifications

Original app just returns random sentiments with no intelligence. AI will introduce analysis-based classification of text sentiment.

**To get from Starter to Complete**:

1. Add .mlmodel file you have trained
2. Add fallback Sentiment enum value in case of failed classification
3. Add checks for empty or invalid model or text values
4. Replace body of `predictSentiment(with:)` function from Sentiment file