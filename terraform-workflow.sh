#!/bin/bash

terraform plan -out="plan"
terraform apply "plan"
