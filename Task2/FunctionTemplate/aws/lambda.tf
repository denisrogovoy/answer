# Shared credentials file and region configuration

variable "region" {
  type        = string
  description = "The AWS region for the deployment. See https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html"
  default = "us-east-1"
}

provider "aws" {
  shared_credentials_file = "credentials"
  region                  = var.region
}

############################################
# Configuration of the lambda functions    #
############################################

locals {
  function_names = ["Split", "Count", "Assemble", "SplitSecond", "Modify", "AssembleSecond"]
  function_paths = ["tmp/Split.zip", "tmp/Count.zip", "tmp/Assemble.zip", "tmp/SplitSecond.zip", "tmp/Modify.zip", "tmp/AssembleSecond.zip"]
  function_runtimes = ["python3.8", "python3.8", "python3.8", "python3.8", "python3.8", "python3.8"]
  function_handlers = ["lambda_function.lambda_handler", "lambda_function.lambda_handler", "lambda_function.lambda_handler", "lambda_function.lambda_handler", "lambda_function.lambda_handler", "lambda_function.lambda_handler"]
  function_layers = [[],[],[],[],[],[]]

  tags = {
    Owner = "Dennis"
    Environment = "DEV"
  }
}

data "aws_iam_policy" "cloud_watch_policy" {
  name = "AWSLambdaBasicExecutionRole"
}

# Create a new aws iam role
resource "aws_iam_role" "iam_for_lambda" {
  name = "Role-for-Lambda-functions"

  tags = local.tags

  managed_policy_arns = [data.aws_iam_policy.cloud_watch_policy.arn]

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}



# # Configuration of the lambda layers
# resource "aws_lambda_layer_version" "<your_function_name>" {
#   filename   = "./layers/<your_function_name>.zip"
#   layer_name = "<your_function_name>"
            
#   compatible_runtimes = ["python3.8"]
# }



resource "aws_lambda_function" "lambda" {
  count = length(local.function_names)

  filename      = local.function_paths[count.index]
  function_name = local.function_names[count.index]
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = local.function_handlers[count.index]
  timeout       = 300
  memory_size   =  256
  layers        = local.function_layers[count.index]
  runtime       = local.function_runtimes[count.index]
  source_code_hash = filebase64sha256(local.function_paths[count.index])

  tags = local.tags
}


############################################
# Gateway                                  #
############################################

resource "aws_api_gateway_rest_api" "api_gateway" {
  count = length(local.function_names)

  name        = "api-gateway-${local.function_names[count.index]}"
  description = "API Gateway for lambda function ${local.function_names[count.index]}"

  tags = local.tags
}

resource "aws_api_gateway_resource" "proxy" {
   count = length(local.function_names)
   
   rest_api_id = aws_api_gateway_rest_api.api_gateway[count.index].id
   parent_id   = aws_api_gateway_rest_api.api_gateway[count.index].root_resource_id
   path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
   count = length(local.function_names)

   rest_api_id   = aws_api_gateway_rest_api.api_gateway[count.index].id
   resource_id   = aws_api_gateway_resource.proxy[count.index].id
   http_method   = "ANY"
   authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
   count = length(local.function_names)

   rest_api_id = aws_api_gateway_rest_api.api_gateway[count.index].id
   resource_id = aws_api_gateway_method.proxy[count.index].resource_id
   http_method = aws_api_gateway_method.proxy[count.index].http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.lambda[count.index].invoke_arn
}

resource "aws_api_gateway_method" "proxy_root" {
   count = length(local.function_names)

   rest_api_id   = aws_api_gateway_rest_api.api_gateway[count.index].id
   resource_id   = aws_api_gateway_rest_api.api_gateway[count.index].root_resource_id
   http_method   = "ANY"
   authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
   count = length(local.function_names)

   rest_api_id = aws_api_gateway_rest_api.api_gateway[count.index].id
   resource_id = aws_api_gateway_method.proxy_root[count.index].resource_id
   http_method = aws_api_gateway_method.proxy_root[count.index].http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.lambda[count.index].invoke_arn
}

resource "aws_api_gateway_deployment" "api_gateway_deployment_split" {
   depends_on = [
     aws_api_gateway_integration.lambda[0],
     aws_api_gateway_integration.lambda_root[0],
   ]

   rest_api_id = aws_api_gateway_rest_api.api_gateway[0].id
   stage_name  = local.function_names[0]
}

resource "aws_api_gateway_deployment" "api_gateway_deployment_count" {
   depends_on = [
     aws_api_gateway_integration.lambda[1],
     aws_api_gateway_integration.lambda_root[1],
   ]

   rest_api_id = aws_api_gateway_rest_api.api_gateway[1].id
   stage_name  = local.function_names[1]
}

resource "aws_api_gateway_deployment" "api_gateway_deployment_assemble" {
   depends_on = [
     aws_api_gateway_integration.lambda[2],
     aws_api_gateway_integration.lambda_root[2],
   ]

   rest_api_id = aws_api_gateway_rest_api.api_gateway[2].id
   stage_name  = local.function_names[2]
}

resource "aws_api_gateway_deployment" "api_gateway_deployment_split_second" {
   depends_on = [
     aws_api_gateway_integration.lambda[3],
     aws_api_gateway_integration.lambda_root[3],
   ]

   rest_api_id = aws_api_gateway_rest_api.api_gateway[3].id
   stage_name  = local.function_names[3]
}

resource "aws_api_gateway_deployment" "api_gateway_deployment_modify" {
   depends_on = [
     aws_api_gateway_integration.lambda[4],
     aws_api_gateway_integration.lambda_root[4],
   ]

   rest_api_id = aws_api_gateway_rest_api.api_gateway[4].id
   stage_name  = local.function_names[4]
}

resource "aws_api_gateway_deployment" "api_gateway_deployment_assemble_second" {
   depends_on = [
     aws_api_gateway_integration.lambda[5],
     aws_api_gateway_integration.lambda_root[5],
   ]

   rest_api_id = aws_api_gateway_rest_api.api_gateway[5].id
   stage_name  = local.function_names[5]
}

resource "aws_lambda_permission" "apigw" {
   count = length(local.function_names)

   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.lambda[count.index].function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_api_gateway_rest_api.api_gateway[count.index].execution_arn}/*/*"
}



output "url_Split" {
  value = aws_api_gateway_deployment.api_gateway_deployment_split.invoke_url
}

output "url_Count" {
  value = aws_api_gateway_deployment.api_gateway_deployment_count.invoke_url
}

output "url_Assemble" {
  value = aws_api_gateway_deployment.api_gateway_deployment_assemble.invoke_url
}

output "url_SplitSecond" {
  value = aws_api_gateway_deployment.api_gateway_deployment_split_second.invoke_url
}

output "url_Modify" {
  value = aws_api_gateway_deployment.api_gateway_deployment_modify.invoke_url
}

output "url_AssembleSecond" {
  value = aws_api_gateway_deployment.api_gateway_deployment_assemble_second.invoke_url
}
