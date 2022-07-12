import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def cloud_function(json_input):
    logger.info(json_input)
    batch = json_input["batch"]
    pattern = json_input["pattern"]

    # Processing
    modifiedArray = [word for word in batch if word != pattern]
    modifiedStr = " ".join(modifiedArray)

    # return the result
    res = {
        "modifiedStr": modifiedStr
    }
    logger.info(res)
    return res
