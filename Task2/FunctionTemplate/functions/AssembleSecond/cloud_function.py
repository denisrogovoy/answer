import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def cloud_function(json_input):
    logger.info(json_input)
    modifiedArray = json_input["modifiedArray"]
    thresholdStr = json_input["thresholdStr"]
    
    # Processing
    modifiedArrayWithoutEmptyString = [word for word in modifiedArray if word]
    changedStr = " ".join(modifiedArrayWithoutEmptyString)
    modifiedStr = thresholdStr + " " + changedStr

    # return the result
    res = {
        "modifiedStr": modifiedStr
    }
    logger.info(res)
    return res
