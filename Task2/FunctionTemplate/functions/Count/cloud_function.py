import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def cloud_function(json_input):
    logger.info(json_input)
    batch = json_input["batch"]
    pattern = json_input["pattern"]
    
    # Processing
    counterValue = sum([1 for word in batch if word == pattern])

    # return the result
    res = {
        "counterValue": counterValue
    }
    logger.info(res)
    return res
