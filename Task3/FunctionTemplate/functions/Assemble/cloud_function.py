import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def cloud_function(json_input):
    logger.info(json_input)
    counterValueArray = json_input["counterValueArray"]
    
    # Processing
    sumValue = sum(counterValueArray)

    # return the result
    res = {
        "sum": sumValue
    }
    logger.info(res)
    return res
