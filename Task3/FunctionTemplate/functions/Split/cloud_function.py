import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def cloud_function(json_input):
    logger.info(json_input)
    originalStr = json_input["originalStr"]
    batchSize = json_input["batchSize"]
    
    # Processing
    wordsArray = originalStr.split()
    stringBatches = [wordsArray[i:i+batchSize] for i in range(0, len(wordsArray), batchSize)]

    # return the result
    res = {
        "stringBatches": stringBatches
    }
    logger.info(res)
    return res
