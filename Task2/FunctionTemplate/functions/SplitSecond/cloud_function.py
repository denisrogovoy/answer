import logging
import re

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def cloud_function(json_input):
    logger.info(json_input)
    originalStr = json_input["originalStr"]
    pattern = json_input["pattern"]
    batchSize = json_input["batchSize"]
    threshold = json_input["threshold"]
    
    # Processing
    occurrences = [m.start() for m in re.finditer(pattern, originalStr)]
    if threshold >= len(occurrences):
        res = {
            "thresholdStr": "",
            "stringBatchesModified": originalStr.split()
        }
        return res

    thresholdStr = originalStr[0:occurrences[threshold-1]+len(pattern)]

    wordsArray = originalStr[occurrences[threshold-1]+len(pattern):].split()
    stringBatches = [wordsArray[i:i+batchSize] for i in range(0, len(wordsArray), batchSize)]

    # return the result
    res = {
        "thresholdStr": thresholdStr,
        "stringBatchesModified": stringBatches
    }
    logger.info(res)
    return res