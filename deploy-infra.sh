#! /bin/bash
STACK_NAME=awsbootstrap
STACK_NAME_2=s3-bucket
REGION=us-east-1
CLI_PROFILE=default

EC2_INSTANCE_TYPE=t2.micro

AWS_ID=`aws sts get-caller-identity --query "Account" --output text`
S3_BUCKET_NAME="${REGION}"-pipeline-"${AWS_ID}"

echo -e "\n================== Desplegando setup.yml ====================="

aws cloudformation deploy \
	--region $REGION \
	--profile $CLI_PROFILE \
	--stack-name $STACK_NAME_2 \
	--template-file setup.yml \
	--no-fail-on-empty-changeset \
	--parameter-override BucketName=$S3_BUCKET_NAME

echo -e "\n================== Desplegando main.yml ====================="

aws cloudformation deploy \
	--region $REGION \
	--profile $CLI_PROFILE \
	--stack-name $STACK_NAME \
	--template-file main.yml \
	--no-fail-on-empty-changeset \
	--capabilities CAPABILITY_NAMED_IAM \
	--parameter-override InstanceType=$EC2_INSTANCE_TYPE

if [ $? -eq 0 ]; then
	aws cloudformation list-exports \
		--profile default \
		--query "Exports[?Name=='InstanceId'].Value"
fi
