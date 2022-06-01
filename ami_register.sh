#!/bin/bash

set -euo pipefail

# Requires an awesome CLI tool: https://github.com/fujiwara/tfstate-lookup
instance_id=$(tfstate-lookup aws_instance.first.id)
aws ec2 create-image --instance-id "${instance_id}" --name wordpress-handson-ichikawa \
                     --tag-specifications 'ResourceType=image,Tags=[{Key=Name,Value=wordpress-handson-ichikawa}]'
