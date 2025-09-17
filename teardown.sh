#!/bin/bash
set -e

PROJECT_NAME="document-portal"   # Change this to match your stack prefix or tag

# Find stacks that match the project name in their StackName
stacks=$(aws cloudformation describe-stacks \
    --query "Stacks[?contains(StackName, \`${PROJECT_NAME}\`)].StackName" \
    --output text)

if [ -z "$stacks" ]; then
    echo "⚠️ No stacks found for project: $PROJECT_NAME"
    exit 0
fi

for stack in $stacks; do
    echo "🗑️ Deleting stack: $stack"
    aws cloudformation delete-stack --stack-name "$stack"
    aws cloudformation wait stack-delete-complete --stack-name "$stack"
    echo "✅ Deleted stack: $stack"
done

echo "🎉 All stacks for project '$PROJECT_NAME' deleted successfully."
